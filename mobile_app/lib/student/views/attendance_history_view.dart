import 'package:flutter/material.dart';
import '../../shared/tokens/tokens.dart';
import '../../shared/widgets/app_state_view.dart';
import '../models/student_attendance_record.dart';
import '../services/student_service.dart';
import '../widgets/attendance_history_card.dart';

/// شاشة سجل الحضور والغياب الشامل للطالب (Attendance History View)
class AttendanceHistoryView extends StatefulWidget {
  final StudentService? studentService;
  final String? initialCourseCode;

  const AttendanceHistoryView({
    super.key,
    this.studentService,
    this.initialCourseCode,
  });

  @override
  State<AttendanceHistoryView> createState() => _AttendanceHistoryViewState();
}

class _AttendanceHistoryViewState extends State<AttendanceHistoryView> {
  late final StudentService _service;
  ScreenStateType _state = ScreenStateType.loading;
  List<StudentAttendanceRecord> _allRecords = [];
  List<StudentAttendanceRecord> _filteredRecords = [];
  String _selectedStateFilter = 'ALL'; // ALL | Present | Late | Absent | Excused
  String? _selectedCourseFilter;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _service = widget.studentService ?? StudentService();
    _selectedCourseFilter = widget.initialCourseCode ?? 'ALL';
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _state = ScreenStateType.loading;
      _errorMessage = null;
    });

    try {
      final records = await _service.getAttendanceHistory();
      if (!mounted) return;

      setState(() {
        _allRecords = records;
        _applyFilters();
        _state = records.isEmpty ? ScreenStateType.empty : ScreenStateType.success;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _state = ScreenStateType.error;
        _errorMessage = 'تعذر تحميل سجل الحضور: $e';
      });
    }
  }

  void _applyFilters() {
    List<StudentAttendanceRecord> result = List.from(_allRecords);

    // تصفية حسب حالة الحضور
    if (_selectedStateFilter != 'ALL') {
      result = result
          .where((r) => r.attendanceState.toLowerCase() == _selectedStateFilter.toLowerCase())
          .toList();
    }

    // تصفية حسب المقرر
    if (_selectedCourseFilter != null &&
        _selectedCourseFilter!.isNotEmpty &&
        _selectedCourseFilter != 'ALL') {
      result = result
          .where((r) => r.courseCode.toLowerCase() == _selectedCourseFilter!.toLowerCase())
          .toList();
    }

    _filteredRecords = result;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // جمع قائمة المقررات الفريدة للاختيار
    final courseCodes = <String>{'ALL', ..._allRecords.map((r) => r.courseCode)}.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل الحضور والغياب'),
        actions: [
          IconButton(
            onPressed: _loadHistory,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: AppStateView(
        state: _state,
        loadingMessage: 'جاري تحميل سجلات الحضور...',
        emptyTitle: 'لا توجد سجلات حضور',
        emptyMessage: 'لم يتم تسجيل أي جلسات حضور أو غياب سابقة حتى الآن.',
        emptyIcon: Icons.history_rounded,
        errorMessage: _errorMessage,
        onRetry: _loadHistory,
        child: RefreshIndicator(
          onRefresh: _loadHistory,
          child: ListView(
            padding: AppSpacing.paddingLG,
            children: [
              // اختيار المقرر للتصفية
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.radiusMD),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: courseCodes.contains(_selectedCourseFilter) ? _selectedCourseFilter : 'ALL',
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
                    items: courseCodes.map((code) {
                      return DropdownMenuItem<String>(
                        value: code,
                        child: Text(
                          code == 'ALL' ? 'جميع المقررات الدراسية' : 'مقرر $code',
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedCourseFilter = val;
                          _applyFilters();
                        });
                      }
                    },
                  ),
                ),
              ),
              AppSpacing.gapVerticalMD,
              // أزرار تصفية الحالات (الكل / حاضر / متأخر / غائب / معذور)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildStateFilterChip('ALL', 'الكل (${_allRecords.length})', AppColors.primary),
                    AppSpacing.gapHorizontalSM,
                    _buildStateFilterChip(
                      'Present',
                      'حاضر (${_allRecords.where((r) => r.isPresent).length})',
                      AppColors.success,
                    ),
                    AppSpacing.gapHorizontalSM,
                    _buildStateFilterChip(
                      'Late',
                      'متأخر (${_allRecords.where((r) => r.isLate).length})',
                      AppColors.warning,
                    ),
                    AppSpacing.gapHorizontalSM,
                    _buildStateFilterChip(
                      'Absent',
                      'غائب (${_allRecords.where((r) => r.isAbsent).length})',
                      AppColors.error,
                    ),
                    AppSpacing.gapHorizontalSM,
                    _buildStateFilterChip(
                      'Excused',
                      'معذور (${_allRecords.where((r) => r.isExcused).length})',
                      const Color(0xFF0284C7),
                    ),
                  ],
                ),
              ),
              AppSpacing.gapVerticalLG,
              // عدد السجلات المعروضة
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'السجلات المعروضة (${_filteredRecords.length})',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Row(
                    children: [
                      Icon(Icons.filter_list_rounded, size: 14.0, color: AppColors.textSecondary),
                      SizedBox(width: 4.0),
                      Text(
                        'الأحدث أولاً',
                        style: TextStyle(fontSize: 12.0, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
              AppSpacing.gapVerticalSM,
              if (_filteredRecords.isEmpty)
                Container(
                  padding: AppSpacing.paddingXL,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.radiusMD),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.filter_alt_off_rounded, size: 48.0, color: AppColors.textSecondary),
                      AppSpacing.gapVerticalMD,
                      Text(
                        'لا توجد سجلات تطابق الفلتر المحدد',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                )
              else
                ..._filteredRecords.map((r) => AttendanceHistoryCard(record: r)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStateFilterChip(String key, String label, Color activeColor) {
    final isSelected = _selectedStateFilter.toLowerCase() == key.toLowerCase();
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedStateFilter = key;
            _applyFilters();
          });
        }
      },
      selectedColor: activeColor,
      backgroundColor: AppColors.surface,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        fontSize: 12.0,
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
