import 'package:flutter/material.dart';
import '../../shared/tokens/tokens.dart';
import '../../shared/widgets/app_state_view.dart';
import '../models/lab_group.dart';
import '../models/lab_student_record.dart';
import '../services/practical_teacher_service.dart';
import '../widgets/exception_approval_modal.dart';
import '../widgets/lab_roster_table.dart';
import '../widgets/manual_lab_attendance_modal.dart';

/// شاشة كشف حضور المعمل العملي والتحضير الميداني واعتماد الاستثناءات (Lab Attendance View)
class LabAttendanceView extends StatefulWidget {
  final LabGroup group;
  final String? sessionId;
  final PracticalTeacherService? practicalService;

  const LabAttendanceView({
    super.key,
    required this.group,
    this.sessionId,
    this.practicalService,
  });

  @override
  State<LabAttendanceView> createState() => _LabAttendanceViewState();
}

class _LabAttendanceViewState extends State<LabAttendanceView> {
  late final PracticalTeacherService _service;
  ScreenStateType _state = ScreenStateType.loading;
  List<LabStudentRecord> _allStudents = [];
  List<LabStudentRecord> _filteredStudents = [];
  String _selectedFilter = 'ALL'; // ALL | PRESENT | LATE | EXCUSED | ABSENT | PENDING
  String _searchQuery = '';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _service = widget.practicalService ?? PracticalTeacherService();
    _loadRoster();
  }

  Future<void> _loadRoster() async {
    setState(() {
      _state = ScreenStateType.loading;
      _errorMessage = null;
    });

    try {
      final roster = await _service.getLabAttendanceRoster(
        widget.group.id,
        sessionId: widget.sessionId,
      );
      if (!mounted) return;

      setState(() {
        _allStudents = roster;
        _applyFilters();
        _state = roster.isEmpty ? ScreenStateType.empty : ScreenStateType.success;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _state = ScreenStateType.error;
        _errorMessage = 'تعذر تحميل كشف حضور المعمل: $e';
      });
    }
  }

  void _applyFilters() {
    List<LabStudentRecord> result = List.from(_allStudents);

    if (_selectedFilter == 'PENDING') {
      result = result.where((s) => s.hasPendingException).toList();
    } else if (_selectedFilter != 'ALL') {
      result = result.where((s) => s.attendanceState.toUpperCase() == _selectedFilter).toList();
    }

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      result = result.where((s) {
        return s.fullName.toLowerCase().contains(q) ||
            s.studentNumber.toLowerCase().contains(q) ||
            s.departmentName.toLowerCase().contains(q);
      }).toList();
    }

    _filteredStudents = result;
  }

  Future<void> _handleStateChange(LabStudentRecord student, String newState) async {
    try {
      await _service.recordManualAttendance(
        widget.group.id,
        student.studentNumber,
        state: newState,
        reason: 'تعديل مباشر من أستاذ المعمل في كشف الحضور',
      );
      if (!mounted) return;
      _loadRoster();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل تعديل حالة الطالب: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _openExceptionReview(LabStudentRecord student) {
    ExceptionApprovalModal.show(
      context,
      student: student,
      onDecision: (approved, notes) async {
        try {
          await _service.approveException(
            widget.group.id,
            student.studentId,
            approved: approved,
            teacherNotes: notes,
          );
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(approved ? 'تم اعتماد الاستثناء بنجاح' : 'تم رفض الاستثناء'),
              backgroundColor: approved ? AppColors.success : AppColors.error,
            ),
          );
          _loadRoster();
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('فشل معالجة الاستثناء: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
    );
  }

  void _openManualAttendanceDialog() {
    ManualLabAttendanceModal.show(
      context,
      onSubmit: (studentNumber, state, reason) async {
        try {
          await _service.recordManualAttendance(
            widget.group.id,
            studentNumber,
            state: state,
            reason: reason,
          );
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تسجيل التحضير اليدوي بنجاح'),
              backgroundColor: AppColors.success,
            ),
          );
          _loadRoster();
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('فشل تسجيل التحضير: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalCount = _allStudents.length;
    final presentCount = _allStudents.where((s) => s.isPresent).length;
    final lateCount = _allStudents.where((s) => s.isLate).length;
    final excusedCount = _allStudents.where((s) => s.isExcused).length;
    final absentCount = _allStudents.where((s) => s.isAbsent).length;
    final pendingExceptions = _allStudents.where((s) => s.hasPendingException).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.groupName),
        actions: [
          IconButton(
            onPressed: _openManualAttendanceDialog,
            icon: const Icon(Icons.person_add_alt_1_rounded),
            tooltip: 'تحضير يدوي لطالب',
          ),
          IconButton(
            onPressed: _loadRoster,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'تحديث الكشف',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openManualAttendanceDialog,
        backgroundColor: const Color(0xFF0F766E),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.edit_note_rounded),
        label: const Text(
          'تحضير يدوي',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: AppStateView(
        state: _state,
        loadingMessage: 'جاري تحميل كشف طلاب المعمل...',
        emptyTitle: 'لا يوجد طلاب مسجلين',
        emptyMessage: 'لم يتم العثور على أي طلاب مقيدين في هذه المجموعة المعملية.',
        emptyIcon: Icons.group_off_outlined,
        errorMessage: _errorMessage,
        onRetry: _loadRoster,
        child: RefreshIndicator(
          onRefresh: _loadRoster,
          child: ListView(
            padding: AppSpacing.paddingLG,
            children: [
              // بطاقة رأس كشف المعمل
              _buildHeaderCard(context),
              AppSpacing.gapVerticalLG,
              // عدادات الإحصائيات (حاضر / متأخر / معذور / غائب)
              _buildMetricsRow(
                presentCount: presentCount,
                lateCount: lateCount,
                excusedCount: excusedCount,
                absentCount: absentCount,
                totalCount: totalCount,
              ),
              AppSpacing.gapVerticalLG,
              // حقل البحث
              TextField(
                decoration: InputDecoration(
                  hintText: 'البحث باسم الطالب، الرقم الجامعي، أو القسم...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              _searchQuery = '';
                              _applyFilters();
                            });
                          },
                          icon: const Icon(Icons.clear_rounded),
                        )
                      : null,
                  filled: true,
                  fillColor: AppColors.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.radiusMD),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                    _applyFilters();
                  });
                },
              ),
              AppSpacing.gapVerticalMD,
              // أزرار التصفية (الكل / حاضر / متأخر / معذور / غائب / استثناءات معلقة)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('ALL', 'الكل ($totalCount)', AppColors.primary),
                    AppSpacing.gapHorizontalSM,
                    _buildFilterChip('PRESENT', 'حاضر ($presentCount)', AppColors.success),
                    AppSpacing.gapHorizontalSM,
                    _buildFilterChip('LATE', 'متأخر ($lateCount)', AppColors.warning),
                    AppSpacing.gapHorizontalSM,
                    _buildFilterChip('EXCUSED', 'معذور ($excusedCount)', const Color(0xFF0284C7)),
                    AppSpacing.gapHorizontalSM,
                    _buildFilterChip('ABSENT', 'غائب ($absentCount)', AppColors.error),
                    if (pendingExceptions > 0) ...[
                      AppSpacing.gapHorizontalSM,
                      _buildFilterChip(
                        'PENDING',
                        'استثناء معلق ($pendingExceptions)',
                        const Color(0xFFD97706),
                      ),
                    ],
                  ],
                ),
              ),
              AppSpacing.gapVerticalLG,
              // ترويسة قائمة الطلاب
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'كشف الطلاب (${_filteredStudents.length})',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Text(
                    'تعديل فوري ومباشر',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              AppSpacing.gapVerticalSM,
              // جدول كشف الطلاب
              LabRosterTable(
                students: _filteredStudents,
                onStateChange: _handleStateChange,
                onReviewException: _openExceptionReview,
              ),
              const SizedBox(height: 80.0), // مسافة للـ FAB
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    final theme = Theme.of(context);
    final group = widget.group;

    return Container(
      padding: AppSpacing.paddingLG,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusMD),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                ),
                child: Text(
                  group.courseCode,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.0,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F766E).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                ),
                child: Text(
                  '${group.groupTypeArabic} (شعبة ${group.sectionNumber})',
                  style: const TextStyle(
                    color: Color(0xFF0F766E),
                    fontWeight: FontWeight.w600,
                    fontSize: 11.5,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapVerticalSM,
          Text(
            group.courseName,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4.0),
          Row(
            children: [
              const Icon(Icons.meeting_room_outlined, size: 14.0, color: AppColors.textSecondary),
              const SizedBox(width: 4.0),
              Text(
                'القاعة: ${group.roomName}',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.0),
              ),
              Container(
                width: 1.0,
                height: 12.0,
                color: AppColors.border,
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
              ),
              const Icon(Icons.schedule_rounded, size: 14.0, color: AppColors.textSecondary),
              const SizedBox(width: 4.0),
              Text(
                group.scheduleTime,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsRow({
    required int presentCount,
    required int lateCount,
    required int excusedCount,
    required int absentCount,
    required int totalCount,
  }) {
    return Row(
      children: [
        _buildMetricTile('حاضر', presentCount.toString(), AppColors.success),
        AppSpacing.gapHorizontalSM,
        _buildMetricTile('متأخر', lateCount.toString(), AppColors.warning),
        AppSpacing.gapHorizontalSM,
        _buildMetricTile('معذور', excusedCount.toString(), const Color(0xFF0284C7)),
        AppSpacing.gapHorizontalSM,
        _buildMetricTile('غائب', absentCount.toString(), AppColors.error),
        AppSpacing.gapHorizontalSM,
        _buildMetricTile('الإجمالي', totalCount.toString(), AppColors.textPrimary),
      ],
    );
  }

  Widget _buildMetricTile(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.radiusMD),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 2.0),
            Text(
              value,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String key, String label, Color activeColor) {
    final isSelected = _selectedFilter == key;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedFilter = key;
            _applyFilters();
          });
        }
      },
      selectedColor: activeColor,
      backgroundColor: AppColors.surface,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        fontSize: 11.5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusSM),
        side: BorderSide(
          color: isSelected ? activeColor : AppColors.border,
        ),
      ),
      showCheckmark: false,
    );
  }
}
