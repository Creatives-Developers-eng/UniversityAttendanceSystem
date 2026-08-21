import 'package:flutter/material.dart';
import '../../shared/tokens/tokens.dart';
import '../../shared/widgets/app_state_view.dart';
import '../models/student_attendance_record.dart';
import '../models/student_course.dart';
import '../services/student_service.dart';
import '../widgets/attendance_history_card.dart';

/// شاشة تفاصيل المقرر الدراسي وسجل حضوره الفردي (Course Details View)
class CourseDetailsView extends StatefulWidget {
  final String courseId;
  final StudentCourse? initialCourse;
  final StudentService? studentService;

  const CourseDetailsView({
    super.key,
    required this.courseId,
    this.initialCourse,
    this.studentService,
  });

  @override
  State<CourseDetailsView> createState() => _CourseDetailsViewState();
}

class _CourseDetailsViewState extends State<CourseDetailsView> {
  late final StudentService _service;
  ScreenStateType _state = ScreenStateType.loading;
  StudentCourse? _course;
  List<StudentAttendanceRecord> _records = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _service = widget.studentService ?? StudentService();
    _loadCourseDetails();
  }

  Future<void> _loadCourseDetails() async {
    setState(() {
      _state = ScreenStateType.loading;
      _errorMessage = null;
    });

    try {
      final course = widget.initialCourse ?? await _service.getCourseDetails(widget.courseId);
      if (course == null) {
        setState(() {
          _state = ScreenStateType.empty;
        });
        return;
      }

      final records = await _service.getAttendanceHistory(
        courseCode: course.courseCode,
      );

      setState(() {
        _course = course;
        _records = records;
        _state = ScreenStateType.success;
      });
    } catch (e) {
      setState(() {
        _state = ScreenStateType.error;
        _errorMessage = 'تعذر تحميل تفاصيل المقرر: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_course?.courseName ?? 'تفاصيل المقرر'),
        actions: [
          IconButton(
            onPressed: _loadCourseDetails,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: AppStateView(
        state: _state,
        loadingMessage: 'جاري جلب تفاصيل المقرر وسجلاته...',
        emptyTitle: 'المقرر غير موجود',
        emptyMessage: 'لم نتمكن من العثور على بيانات هذا المقرر الدراسي.',
        emptyIcon: Icons.menu_book_outlined,
        errorMessage: _errorMessage,
        onRetry: _loadCourseDetails,
        child: _course == null
            ? const SizedBox.shrink()
            : RefreshIndicator(
                onRefresh: _loadCourseDetails,
                child: ListView(
                  padding: AppSpacing.paddingLG,
                  children: [
                    // بطاقة رأس المقرر
                    _buildCourseHeader(context, _course!),
                    AppSpacing.gapVerticalLG,
                    // بطاقة مؤشرات الحضور للمقرر
                    _buildAttendanceSummary(context, _course!),
                    AppSpacing.gapVerticalLG,
                    // عنوان قائمة الجلسات
                    Row(
                      children: [
                        const Icon(
                          Icons.history_edu_rounded,
                          color: AppColors.primary,
                          size: 20.0,
                        ),
                        AppSpacing.gapHorizontalSM,
                        Text(
                          'سجل جلسات هذا المقرر (${_records.length})',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.gapVerticalSM,
                    if (_records.isEmpty)
                      Container(
                        padding: AppSpacing.paddingLG,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.radiusMD),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          'لم يتم تسجيل أي جلسات حضور لهذه المادة بعد.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      )
                    else
                      ..._records.map((r) => AttendanceHistoryCard(record: r)),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildCourseHeader(BuildContext context, StudentCourse course) {
    final theme = Theme.of(context);
    final isPractical = course.sectionType == SectionType.practical;

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
            offset: const Offset(0, 4),
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
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                ),
                child: Text(
                  course.courseCode,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.0,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: isPractical
                      ? AppColors.secondary.withValues(alpha: 0.15)
                      : AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                ),
                child: Text(
                  '${course.sectionTypeArabic} (شعبة ${course.sectionNumber})',
                  style: TextStyle(
                    color: isPractical ? AppColors.secondary : AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapVerticalMD,
          Text(
            course.courseName,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          AppSpacing.gapVerticalSM,
          Row(
            children: [
              const Icon(Icons.school_rounded, size: 16.0, color: AppColors.textSecondary),
              const SizedBox(width: 6.0),
              Text(
                'الأستاذ المشرف: ${course.teacherName}',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13.0),
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          Row(
            children: [
              const Icon(Icons.timer_rounded, size: 16.0, color: AppColors.textSecondary),
              const SizedBox(width: 6.0),
              Text(
                'الساعات المعتمدة: ${course.creditHours} ساعات',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13.0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceSummary(BuildContext context, StudentCourse course) {
    final rate = course.attendancePercentage;
    Color rateColor = AppColors.success;
    String statusTitle = 'الوضع الأكاديمي: منتظم وآمن';

    if (course.isDeprived) {
      rateColor = AppColors.error;
      statusTitle = 'الوضع الأكاديمي: محروم لتجاوز حد الغياب (أقل من 75%)';
    } else if (course.isWarning) {
      rateColor = AppColors.warning;
      statusTitle = 'الوضع الأكاديمي: إنذار بالغياب (أقل من 85%)';
    }

    return Container(
      padding: AppSpacing.paddingLG,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusMD),
        border: Border.all(
          color: course.isDeprived ? AppColors.error : AppColors.border,
          width: course.isDeprived ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'نسبة الحضور الخاصة بالمادة',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.0),
              ),
              Text(
                '${rate.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18.0,
                  color: rateColor,
                ),
              ),
            ],
          ),
          AppSpacing.gapVerticalSM,
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.radiusSM),
            child: LinearProgressIndicator(
              value: course.totalLectures > 0 ? (rate / 100.0) : 1.0,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(rateColor),
              minHeight: 8.0,
            ),
          ),
          AppSpacing.gapVerticalMD,
          Text(
            statusTitle,
            style: TextStyle(
              color: rateColor,
              fontWeight: FontWeight.w600,
              fontSize: 12.0,
            ),
          ),
          AppSpacing.gapVerticalMD,
          const Divider(color: AppColors.border, height: 1.0),
          AppSpacing.gapVerticalMD,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetric('إجمالي الجلسات', course.totalLectures.toString(), AppColors.textPrimary),
              _buildMetric('حضور', course.attendedLectures.toString(), AppColors.success),
              _buildMetric('غياب', course.absentLectures.toString(), AppColors.error),
              _buildMetric('تأخير', course.lateLectures.toString(), AppColors.warning),
              _buildMetric('عذر', course.excusedLectures.toString(), const Color(0xFF0284C7)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String title, String val, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 11.0, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 4.0),
        Text(
          val,
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700, color: color),
        ),
      ],
    );
  }
}
