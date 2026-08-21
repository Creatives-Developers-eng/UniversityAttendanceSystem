import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../shared/tokens/tokens.dart';
import '../../shared/widgets/app_state_view.dart';
import '../models/delegate_student_entry.dart';
import '../services/delegate_service.dart';

/// كشف حضور وغياب طلاب الشعبة للمندوب (Delegate Attendance Sheet View)
class DelegateAttendanceSheet extends StatefulWidget {
  final String sectionId;
  final String? sessionId;
  final String courseCode;
  final String courseName;
  final String sectionNumber;
  final DelegateService? delegateService;

  const DelegateAttendanceSheet({
    super.key,
    required this.sectionId,
    this.sessionId,
    required this.courseCode,
    required this.courseName,
    required this.sectionNumber,
    this.delegateService,
  });

  @override
  State<DelegateAttendanceSheet> createState() => _DelegateAttendanceSheetState();
}

class _DelegateAttendanceSheetState extends State<DelegateAttendanceSheet> {
  late final DelegateService _service;
  ScreenStateType _state = ScreenStateType.loading;

  List<DelegateStudentEntry> _allStudents = [];
  List<DelegateStudentEntry> _filteredStudents = [];
  String _selectedFilter = 'ALL'; // ALL | PRESENT | LATE | ABSENT | EXCUSED
  String _searchQuery = '';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _service = widget.delegateService ?? DelegateService();
    _loadSheetData();
  }

  Future<void> _loadSheetData() async {
    setState(() {
      _state = ScreenStateType.loading;
      _errorMessage = null;
    });

    try {
      final list = await _service.getSectionAttendanceSheet(
        widget.sectionId,
        sessionId: widget.sessionId,
      );
      if (!mounted) return;

      setState(() {
        _allStudents = list;
        _applyFilters();
        _state = list.isEmpty ? ScreenStateType.empty : ScreenStateType.success;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _state = ScreenStateType.error;
        _errorMessage = 'تعذر تحميل كشف حضور الطلاب: $e';
      });
    }
  }

  void _applyFilters() {
    List<DelegateStudentEntry> result = List.from(_allStudents);

    if (_selectedFilter != 'ALL') {
      result = result
          .where((s) => s.attendanceState.toUpperCase() == _selectedFilter.toUpperCase())
          .toList();
    }

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      result = result
          .where((s) =>
              s.fullName.toLowerCase().contains(q) ||
              s.studentNumber.toLowerCase().contains(q))
          .toList();
    }

    _filteredStudents = result;
  }

  void _showAddManualExceptionDialog() {
    final studentNumberController = TextEditingController();
    final reasonController = TextEditingController();
    String selectedState = 'PRESENT';
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.edit_note_rounded, color: AppColors.primary),
              SizedBox(width: 8.0),
              Text('تسجيل تحضير يدوي'),
            ],
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'تسجيل حضور أو استثناء لطالب في هذا الكشف مع إرفاق المبرر.',
                    style: TextStyle(fontSize: 12.0, color: AppColors.textSecondary),
                  ),
                  AppSpacing.gapVerticalMD,
                  TextFormField(
                    controller: studentNumberController,
                    decoration: const InputDecoration(
                      labelText: 'الرقم الجامعي للطالب *',
                      hintText: 'STD-2023-XXXX',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'الرقم الجامعي إلزامي';
                      }
                      return null;
                    },
                  ),
                  AppSpacing.gapVerticalMD,
                  DropdownButtonFormField<String>(
                    initialValue: selectedState,
                    decoration: const InputDecoration(
                      labelText: 'حالة الحضور المراد تسجيلها',
                      prefixIcon: Icon(Icons.check_circle_outline_rounded),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'PRESENT', child: Text('حاضر (Present)')),
                      DropdownMenuItem(value: 'LATE', child: Text('متأخر (Late)')),
                      DropdownMenuItem(value: 'EXCUSED', child: Text('معذور (Excused)')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() {
                          selectedState = val;
                        });
                      }
                    },
                  ),
                  AppSpacing.gapVerticalMD,
                  TextFormField(
                    controller: reasonController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'مبرر التحضير اليدوي *',
                      hintText: 'مثال: عذر مرضي / تعذر الاتصال بالشبكة المحلية',
                      prefixIcon: Icon(Icons.description_outlined),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'المبرر إلزامي لتوثيق التحضير اليدوي';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  final sNum = studentNumberController.text.trim();
                  final reason = reasonController.text.trim();
                  Navigator.of(ctx).pop();

                  try {
                    final newEntry = await _service.requestManualAttendance(
                      widget.sessionId ?? 'ses-current',
                      'std-${DateTime.now().millisecondsSinceEpoch}',
                      selectedState,
                      reason,
                    );

                    if (!mounted) return;

                    setState(() {
                      // تحديث أو إضافة الطالب في القائمة
                      final existingIndex = _allStudents.indexWhere((s) => s.studentNumber == sNum);
                      if (existingIndex != -1) {
                        _allStudents[existingIndex] = _allStudents[existingIndex].copyWith(
                          attendanceState: selectedState,
                          attendanceMethod: 'MANUAL',
                          markedAt: DateTime.now(),
                          manualReason: reason,
                          isVerified: true,
                        );
                      } else {
                        _allStudents.insert(
                          0,
                          newEntry.copyWith(studentNumber: sNum, fullName: 'طالب $sNum'),
                        );
                      }
                      _applyFilters();
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('تم تسجيل حالة الطالب ($sNum) يدوياً بنجاح'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('فشل التسجيل اليدوي: $e'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                }
              },
              child: const Text('حفظ التعديل'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final presentCount = _allStudents.where((s) => s.isPresent).length;
    final lateCount = _allStudents.where((s) => s.isLate).length;
    final absentCount = _allStudents.where((s) => s.isAbsent).length;
    final excusedCount = _allStudents.where((s) => s.isExcused).length;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'كشف حضور: ${widget.courseName}',
              style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w700),
            ),
            Text(
              '${widget.courseCode} - شعبة ${widget.sectionNumber}',
              style: const TextStyle(fontSize: 11.0, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _showAddManualExceptionDialog,
            icon: const Icon(Icons.person_add_alt_1_rounded),
            tooltip: 'تحضير يدوي',
          ),
          IconButton(
            onPressed: _loadSheetData,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: AppStateView(
        state: _state,
        loadingMessage: 'جاري تحميل كشف طلاب الشعبة...',
        emptyTitle: 'لا يوجد طلاب مسجلين',
        emptyMessage: 'لم يتم العثور على أي طلاب مقيدين في هذه الشعبة الدراسية.',
        emptyIcon: Icons.people_outline_rounded,
        errorMessage: _errorMessage,
        onRetry: _loadSheetData,
        child: RefreshIndicator(
          onRefresh: _loadSheetData,
          child: ListView(
            padding: AppSpacing.paddingLG,
            children: [
              // حقل البحث السريع
              TextField(
                decoration: InputDecoration(
                  hintText: 'البحث باسم الطالب أو الرقم الجامعي...',
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
              // أزرار تصفية الحالات
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('ALL', 'الكل (${_allStudents.length})', AppColors.primary),
                    AppSpacing.gapHorizontalSM,
                    _buildFilterChip('PRESENT', 'حاضر ($presentCount)', AppColors.success),
                    AppSpacing.gapHorizontalSM,
                    _buildFilterChip('LATE', 'متأخر ($lateCount)', AppColors.warning),
                    AppSpacing.gapHorizontalSM,
                    _buildFilterChip('ABSENT', 'غائب ($absentCount)', AppColors.error),
                    AppSpacing.gapHorizontalSM,
                    _buildFilterChip('EXCUSED', 'معذور ($excusedCount)', const Color(0xFF0284C7)),
                  ],
                ),
              ),
              AppSpacing.gapVerticalLG,
              // ترويسة عدد الطلاب المعروضين
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'الطلاب المقيدين (${_filteredStudents.length})',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'نسبة الحضور: ${_allStudents.isNotEmpty ? ((presentCount + lateCount) / _allStudents.length * 100).toStringAsFixed(1) : 0}%',
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              AppSpacing.gapVerticalSM,
              if (_filteredStudents.isEmpty)
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
                      Icon(Icons.search_off_rounded, size: 40.0, color: AppColors.textSecondary),
                      AppSpacing.gapVerticalMD,
                      Text(
                        'لا يوجد طلاب يطابقون خيارات البحث المحددة.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                )
              else
                ..._filteredStudents.map((student) => _buildStudentCard(context, student)),
              AppSpacing.gapVerticalXL,
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddManualExceptionDialog,
        icon: const Icon(Icons.add_task_rounded),
        label: const Text('تحضير استثنائي'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildStudentCard(BuildContext context, DelegateStudentEntry student) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.spacingSM),
      padding: AppSpacing.paddingMD,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusMD),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18.0,
                backgroundColor: student.stateColor.withValues(alpha: 0.12),
                child: Text(
                  student.fullName.isNotEmpty ? student.fullName.characters.first : 'ط',
                  style: TextStyle(
                    color: student.stateColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 14.0,
                  ),
                ),
              ),
              AppSpacing.gapHorizontalMD,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.fullName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      '${student.studentNumber} | ${student.departmentName}',
                      style: const TextStyle(fontSize: 11.0, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: student.stateColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                  border: Border.all(color: student.stateColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  student.stateArabic,
                  style: TextStyle(
                    color: student.stateColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 11.0,
                  ),
                ),
              ),
            ],
          ),
          if (student.markedAt != null || student.manualReason != null) ...[
            const SizedBox(height: 8.0),
            const Divider(color: AppColors.border, height: 1.0),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (student.markedAt != null)
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded, size: 13.0, color: AppColors.textSecondary),
                      const SizedBox(width: 4.0),
                      Text(
                        'وقت التسجيل: ${DateFormat('HH:mm:ss').format(student.markedAt!)} (${student.methodArabic})',
                        style: const TextStyle(fontSize: 11.0, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                if (student.manualReason != null)
                  Expanded(
                    child: Text(
                      'المبرر: ${student.manualReason!}',
                      style: const TextStyle(fontSize: 11.0, color: Color(0xFF0284C7), fontStyle: FontStyle.italic),
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip(String key, String label, Color activeColor) {
    final isSelected = _selectedFilter.toUpperCase() == key.toUpperCase();
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
