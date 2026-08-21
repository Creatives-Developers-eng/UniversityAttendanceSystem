import 'package:flutter/material.dart';
import '../../shared/tokens/tokens.dart';
import '../../shared/widgets/app_state_view.dart';
import '../models/lab_group.dart';
import '../models/lab_session.dart';
import '../models/lab_student_record.dart';
import '../services/practical_teacher_service.dart';
import '../widgets/exception_approval_modal.dart';
import '../widgets/lab_group_card.dart';
import '../widgets/lab_session_card.dart';
import '../widgets/practical_header_card.dart';
import 'lab_attendance_view.dart';
import 'lab_groups_view.dart';

/// لوحة تحكم الأستاذ العملي الشاملة (Practical Teacher Dashboard View)
class PracticalDashboardView extends StatefulWidget {
  final PracticalTeacherService? practicalService;

  const PracticalDashboardView({
    super.key,
    this.practicalService,
  });

  @override
  State<PracticalDashboardView> createState() => _PracticalDashboardViewState();
}

class _PracticalDashboardViewState extends State<PracticalDashboardView> {
  late final PracticalTeacherService _service;
  ScreenStateType _state = ScreenStateType.loading;
  Map<String, dynamic> _teacherProfile = {};
  List<LabGroup> _labGroups = [];
  List<LabSession> _sessions = [];
  LabSession? _activeSession;
  List<LabStudentRecord> _pendingExceptions = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _service = widget.practicalService ?? PracticalTeacherService();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _state = ScreenStateType.loading;
      _errorMessage = null;
    });

    try {
      final profileFuture = _service.getTeacherProfile();
      final groupsFuture = _service.getLabGroups();
      final sessionsFuture = _service.getLabSessions();
      final activeFuture = _service.getActiveLabSession();

      final results = await Future.wait([
        profileFuture,
        groupsFuture,
        sessionsFuture,
        activeFuture,
      ]);

      final profile = results[0] as Map<String, dynamic>;
      final groups = results[1] as List<LabGroup>;
      final sessions = results[2] as List<LabSession>;
      final active = results[3] as LabSession?;

      // جمع الاستثناءات المعلقة من كافة المجموعات
      final List<LabStudentRecord> pending = [];
      for (final g in groups) {
        final roster = await _service.getLabAttendanceRoster(g.id);
        pending.addAll(roster.where((s) => s.hasPendingException));
      }

      if (!mounted) return;

      setState(() {
        _teacherProfile = profile;
        _labGroups = groups;
        _sessions = sessions;
        _activeSession = active;
        _pendingExceptions = pending;
        _state = groups.isEmpty && sessions.isEmpty
            ? ScreenStateType.empty
            : ScreenStateType.success;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _state = ScreenStateType.error;
        _errorMessage = 'تعذر تحميل بيانات لوحة تحكم المعامل: $e';
      });
    }
  }

  void _navigateToLabAttendance(LabGroup group, {String? sessionId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LabAttendanceView(
          group: group,
          sessionId: sessionId ?? group.activeSessionId,
          practicalService: _service,
        ),
      ),
    ).then((_) => _loadDashboardData());
  }

  Future<void> _handleStartSession(LabGroup group) async {
    try {
      final session = await _service.startLabSession(group, group.roomName);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم بدء جلسة المعمل بنجاح: ${group.groupName}'),
          backgroundColor: AppColors.success,
        ),
      );
      _navigateToLabAttendance(group, sessionId: session.id);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل بدء الجلسة: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم الأستاذ العملي'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LabGroupsView(practicalService: _service),
                ),
              ).then((_) => _loadDashboardData());
            },
            icon: const Icon(Icons.hub_outlined),
            tooltip: 'مجموعات المعامل',
          ),
          IconButton(
            onPressed: _loadDashboardData,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'تحديث البيانات',
          ),
        ],
      ),
      body: AppStateView(
        state: _state,
        loadingMessage: 'جاري تحميل بيانات المعامل والجلسات العملية...',
        emptyTitle: 'لا توجد معامل مسندة',
        emptyMessage: 'لم يتم العثور على أي شعب أو مجموعات معملية مسندة إليك حالياً.',
        emptyIcon: Icons.science_outlined,
        errorMessage: _errorMessage,
        onRetry: _loadDashboardData,
        child: RefreshIndicator(
          onRefresh: _loadDashboardData,
          child: ListView(
            padding: AppSpacing.paddingLG,
            children: [
              // بطاقة الترويسة الرئيسية
              PracticalHeaderCard(
                teacherProfile: _teacherProfile,
                onRefresh: _loadDashboardData,
                onExceptionsTap: () {
                  if (_pendingExceptions.isNotEmpty && _labGroups.isNotEmpty) {
                    _navigateToLabAttendance(_labGroups.first);
                  }
                },
              ),
              AppSpacing.gapVerticalLG,
              // بنر الجلسة المباشرة الجارية إن وجدت
              if (_activeSession != null) ...[
                _buildActiveSessionBanner(context, _activeSession!),
                AppSpacing.gapVerticalLG,
              ],
              // قسم طلبات الاستثناءات المعلقة التي تتطلب قراراً
              if (_pendingExceptions.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.pending_actions_rounded,
                          color: AppColors.warning,
                          size: 20.0,
                        ),
                        AppSpacing.gapHorizontalSM,
                        Text(
                          'طلبات الاستثناءات المعلقة (${_pendingExceptions.length})',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'تتطلب اعتمادك',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: AppColors.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapVerticalSM,
                ..._pendingExceptions.take(2).map((std) => _buildPendingExceptionCard(context, std)),
                AppSpacing.gapVerticalLG,
              ],
              // قسم مجموعات المعامل المسندة
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.computer_rounded,
                        color: Color(0xFF0F766E),
                        size: 20.0,
                      ),
                      AppSpacing.gapHorizontalSM,
                      Text(
                        'مجموعات المعامل والشعب (${_labGroups.length})',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LabGroupsView(practicalService: _service),
                        ),
                      ).then((_) => _loadDashboardData());
                    },
                    child: const Text('استعراض الكل'),
                  ),
                ],
              ),
              AppSpacing.gapVerticalSM,
              ..._labGroups.map(
                (group) => LabGroupCard(
                  group: group,
                  onRosterTap: () => _navigateToLabAttendance(group),
                  onStartSessionTap: () {
                    if (group.isLiveNow) {
                      _navigateToLabAttendance(group);
                    } else {
                      _handleStartSession(group);
                    }
                  },
                ),
              ),
              AppSpacing.gapVerticalLG,
              // قسم سجل الجلسات المعملية الأخيرة
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.history_edu_rounded,
                        color: AppColors.primary,
                        size: 20.0,
                      ),
                      AppSpacing.gapHorizontalSM,
                      Text(
                        'سجل الجلسات المعملية الأخيرة',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              AppSpacing.gapVerticalSM,
              if (_sessions.isEmpty)
                Container(
                  padding: AppSpacing.paddingLG,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.radiusMD),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Text(
                    'لا توجد جلسات سابقة مسجلة حتى الآن.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                )
              else
                ..._sessions.map(
                  (ses) => LabSessionCard(
                    session: ses,
                    onTap: () {
                      final group = _labGroups.firstWhere(
                        (g) => g.id == ses.groupId,
                        orElse: () => _labGroups.first,
                      );
                      _navigateToLabAttendance(group, sessionId: ses.id);
                    },
                  ),
                ),
              AppSpacing.gapVerticalXL,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveSessionBanner(BuildContext context, LabSession session) {
    return Container(
      padding: AppSpacing.paddingMD,
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4), // Green 50
        borderRadius: BorderRadius.circular(AppRadius.radiusMD),
        border: Border.all(color: const Color(0xFF86EFAC)), // Green 300
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.sensors_rounded, color: AppColors.success, size: 24.0),
          ),
          AppSpacing.gapHorizontalMD,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text(
                      'جلسة معملية نشطة حالياً',
                      style: TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.0,
                      ),
                    ),
                    SizedBox(width: 6.0),
                    Text(
                      '• بث مباشر',
                      style: TextStyle(color: AppColors.success, fontSize: 11.0),
                    ),
                  ],
                ),
                const SizedBox(height: 2.0),
                Text(
                  session.groupName,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.0),
                ),
                Text(
                  '${session.courseCode} - ${session.roomName}',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 11.5),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final group = _labGroups.firstWhere(
                (g) => g.id == session.groupId,
                orElse: () => _labGroups.first,
              );
              _navigateToLabAttendance(group, sessionId: session.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              minimumSize: const Size(80.0, 36.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.radiusSM),
              ),
            ),
            child: const Text('متابعة الكشف'),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingExceptionCard(BuildContext context, LabStudentRecord student) {
    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusMD),
        side: const BorderSide(color: Color(0xFFFDE68A), width: 1.2),
      ),
      child: Padding(
        padding: AppSpacing.paddingMD,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(AppRadius.radiusSM),
              ),
              child: const Icon(Icons.person_outline_rounded, color: Color(0xFFD97706), size: 20.0),
            ),
            AppSpacing.gapHorizontalMD,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.fullName,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    'السبب: ${student.manualReason ?? "عذر غير محدد"}',
                    style: const TextStyle(fontSize: 11.5, color: Color(0xFF92400E)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            AppSpacing.gapHorizontalSM,
            ElevatedButton(
              onPressed: () {
                ExceptionApprovalModal.show(
                  context,
                  student: student,
                  onDecision: (approved, notes) async {
                    if (_labGroups.isNotEmpty) {
                      await _service.approveException(
                        _labGroups.first.id,
                        student.studentId,
                        approved: approved,
                        teacherNotes: notes,
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(approved ? 'تم اعتماد الاستثناء بنجاح' : 'تم رفض الاستثناء'),
                            backgroundColor: approved ? AppColors.success : AppColors.error,
                          ),
                        );
                        _loadDashboardData();
                      }
                    }
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD97706),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                minimumSize: const Size(70.0, 32.0),
                visualDensity: VisualDensity.compact,
              ),
              child: const Text('اتخاذ قرار'),
            ),
          ],
        ),
      ),
    );
  }
}
