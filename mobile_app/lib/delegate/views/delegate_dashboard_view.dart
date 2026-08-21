import 'package:flutter/material.dart';
import '../../shared/tokens/tokens.dart';
import '../../shared/widgets/app_state_view.dart';
import '../models/delegate_section.dart';
import '../models/delegate_session.dart';
import '../services/delegate_service.dart';
import '../widgets/delegate_header_card.dart';
import '../widgets/delegate_session_card.dart';
import '../widgets/start_session_modal.dart';
import 'delegate_attendance_sheet.dart';
import 'live_session_view.dart';

/// لوحة تحكم المندوب الرئيسية (Delegate Dashboard View)
class DelegateDashboardView extends StatefulWidget {
  final DelegateService? delegateService;

  const DelegateDashboardView({
    super.key,
    this.delegateService,
  });

  @override
  State<DelegateDashboardView> createState() => _DelegateDashboardViewState();
}

class _DelegateDashboardViewState extends State<DelegateDashboardView> {
  late final DelegateService _service;
  ScreenStateType _state = ScreenStateType.loading;

  List<DelegateSection> _sections = [];
  List<DelegateSession> _recentSessions = [];
  DelegateSession? _activeSession;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _service = widget.delegateService ?? DelegateService();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _state = ScreenStateType.loading;
      _errorMessage = null;
    });

    try {
      final sectionsFuture = _service.getDelegatedSections();
      final sessionsFuture = _service.getRecentSessions();
      final activeFuture = _service.getActiveSession();

      final results = await Future.wait([
        sectionsFuture,
        sessionsFuture,
        activeFuture,
      ]);

      if (!mounted) return;

      setState(() {
        _sections = results[0] as List<DelegateSection>;
        _recentSessions = results[1] as List<DelegateSession>;
        _activeSession = results[2] as DelegateSession?;
        _state = ScreenStateType.success;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _state = ScreenStateType.error;
        _errorMessage = 'تعذر تحميل بيانات لوحة تحكم المندوب: $e';
      });
    }
  }

  void _openStartSessionSheet() {
    StartSessionModal.show(
      context,
      sections: _sections,
      onStartSession: (selectedSection, roomName) async {
        try {
          final newSession = await _service.startSession(selectedSection, roomName);
          if (!mounted) return;

          setState(() {
            _activeSession = newSession;
          });

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => LiveSessionView(
                session: newSession,
                delegateService: _service,
              ),
            ),
          ).then((_) => _loadDashboardData());
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('فشل بدء الجلسة: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
    );
  }

  Future<void> _syncSession(DelegateSession session) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 16.0,
                height: 16.0,
                child: CircularProgressIndicator(strokeWidth: 2.0, color: Colors.white),
              ),
              SizedBox(width: 12.0),
              Text('جاري مزامنة بيانات الجلسة مع الخادم المركزي...'),
            ],
          ),
          duration: Duration(seconds: 1),
        ),
      );

      await _service.syncSession(session.id);
      if (!mounted) return;

      _loadDashboardData();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تمت مزامنة الجلسة بنجاح مع المركز!'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تعذر إتمام المزامنة: $e'),
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
        title: const Text('لوحة تحكم المندوب'),
        actions: [
          IconButton(
            onPressed: _loadDashboardData,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: AppStateView(
        state: _state,
        loadingMessage: 'جاري تحميل بيانات المندوب والجلسات...',
        emptyTitle: 'لا توجد شعب مفوضة',
        emptyMessage: 'لم يتم تفويضك لإدارة أي شعب في هذا الفصل.',
        emptyIcon: Icons.group_off_rounded,
        errorMessage: _errorMessage,
        onRetry: _loadDashboardData,
        child: RefreshIndicator(
          onRefresh: _loadDashboardData,
          child: ListView(
            padding: AppSpacing.paddingLG,
            children: [
              // بطاقة المندوب الرئيسية
              DelegateHeaderCard(
                delegateName: 'أحمد علي عبد الله',
                delegateStudentNumber: 'STD-2023-4019',
                activeSectionsCount: _sections.length,
              ),
              AppSpacing.gapVerticalLG,
              // شريط تنبيه الجلسة النشطة
              if (_activeSession != null) ...[
                _buildActiveSessionBanner(context, _activeSession!),
                AppSpacing.gapVerticalLG,
              ],
              // زر بدء جلسة جديدة السريع
              SizedBox(
                width: double.infinity,
                height: 52.0,
                child: ElevatedButton.icon(
                  onPressed: _openStartSessionSheet,
                  icon: const Icon(Icons.play_circle_fill_rounded, size: 22.0),
                  label: const Text(
                    'بدء جلسة حضور جديدة في القاعة',
                    style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.radiusMD),
                    ),
                  ),
                ),
              ),
              AppSpacing.gapVerticalLG,
              // قائمة الشعب المفوض بها
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.menu_book_rounded, color: AppColors.primary, size: 20.0),
                      AppSpacing.gapHorizontalSM,
                      Text(
                        'الشعب المخصصة لك (${_sections.length})',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              AppSpacing.gapVerticalSM,
              if (_sections.isEmpty)
                Container(
                  padding: AppSpacing.paddingLG,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.radiusMD),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Text(
                    'لا توجد شعب مفوض بها حالياً.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                )
              else
                ..._sections.map((section) => _buildSectionRow(context, section)),
              AppSpacing.gapVerticalLG,
              // سجل الجلسات السابقة والمزامنة
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.history_rounded, color: AppColors.primary, size: 20.0),
                      AppSpacing.gapHorizontalSM,
                      Text(
                        'سجل الجلسات والمزامنة (${_recentSessions.length})',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              AppSpacing.gapVerticalSM,
              if (_recentSessions.isEmpty)
                Container(
                  padding: AppSpacing.paddingLG,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.radiusMD),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Text(
                    'لم يتم استضافة أي جلسات حضور سابقة.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                )
              else
                ..._recentSessions.map(
                  (session) => DelegateSessionCard(
                    session: session,
                    onTap: session.isActive
                        ? () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => LiveSessionView(
                                  session: session,
                                  delegateService: _service,
                                ),
                              ),
                            ).then((_) => _loadDashboardData());
                          }
                        : null,
                    onOpenSheetTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => DelegateAttendanceSheet(
                            sectionId: session.sectionId,
                            sessionId: session.id,
                            courseCode: session.courseCode,
                            courseName: session.courseName,
                            sectionNumber: session.sectionNumber,
                            delegateService: _service,
                          ),
                        ),
                      );
                    },
                    onSyncTap: () => _syncSession(session),
                  ),
                ),
              AppSpacing.gapVerticalXL,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveSessionBanner(BuildContext context, DelegateSession session) {
    return Container(
      padding: AppSpacing.paddingLG,
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.radiusMD),
        border: Border.all(color: AppColors.success, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.wifi_tethering_rounded,
              color: AppColors.success,
              size: 24.0,
            ),
          ),
          AppSpacing.gapHorizontalMD,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'جلسة حضور مباشرة قيد التشغيل الآن',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.success,
                    fontSize: 13.0,
                  ),
                ),
                Text(
                  '${session.courseName} (${session.courseCode}) - شعبة ${session.sectionNumber}',
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => LiveSessionView(
                    session: session,
                    delegateService: _service,
                  ),
                ),
              ).then((_) => _loadDashboardData());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('العودة للجلسة', style: TextStyle(fontSize: 12.0)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionRow(BuildContext context, DelegateSection section) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.spacingSM),
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusMD),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.radiusSM),
            ),
            child: Icon(
              section.isPractical ? Icons.science_rounded : Icons.menu_book_rounded,
              color: AppColors.primary,
              size: 20.0,
            ),
          ),
          AppSpacing.gapHorizontalMD,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.courseName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  '${section.courseCode} | ${section.sectionTypeArabic} (شعبة ${section.sectionNumber}) - ${section.totalStudents} طالب',
                  style: const TextStyle(
                    fontSize: 11.0,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DelegateAttendanceSheet(
                    sectionId: section.id,
                    courseCode: section.courseCode,
                    courseName: section.courseName,
                    sectionNumber: section.sectionNumber,
                    delegateService: _service,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.people_alt_outlined, size: 16.0),
            label: const Text('الطلاب', style: TextStyle(fontSize: 12.0)),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
