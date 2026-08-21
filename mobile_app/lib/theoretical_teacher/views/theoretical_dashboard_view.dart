import 'package:flutter/material.dart';
import '../../shared/tokens/tokens.dart';
import '../../shared/widgets/app_state_view.dart';
import '../models/attendance_analytics.dart';
import '../models/deprivation_student.dart';
import '../models/theory_course.dart';
import '../services/theoretical_teacher_service.dart';
import '../widgets/attendance_bar_chart.dart';
import '../widgets/attendance_pie_chart.dart';
import '../widgets/deprivation_risk_card.dart';
import '../widgets/theoretical_header_card.dart';
import '../widgets/theory_course_card.dart';
import 'theory_reports_view.dart';

/// لوحة تحكم الأستاذ النظري الشاملة (Theoretical Dashboard View)
class TheoreticalDashboardView extends StatefulWidget {
  final TheoreticalTeacherService? theoreticalService;

  const TheoreticalDashboardView({
    super.key,
    this.theoreticalService,
  });

  @override
  State<TheoreticalDashboardView> createState() => _TheoreticalDashboardViewState();
}

class _TheoreticalDashboardViewState extends State<TheoreticalDashboardView> {
  late final TheoreticalTeacherService _service;
  ScreenStateType _state = ScreenStateType.loading;
  Map<String, dynamic> _teacherProfile = {};
  List<TheoryCourse> _courses = [];
  AttendanceAnalytics? _primaryAnalytics;
  List<DeprivationStudent> _atRiskStudents = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _service = widget.theoreticalService ?? TheoreticalTeacherService();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _state = ScreenStateType.loading;
      _errorMessage = null;
    });

    try {
      final profileFuture = _service.getTeacherProfile();
      final coursesFuture = _service.getTheoryCourses();
      final atRiskFuture = _service.getAllAtRiskStudents();

      final results = await Future.wait([
        profileFuture,
        coursesFuture,
        atRiskFuture,
      ]);

      final profile = results[0] as Map<String, dynamic>;
      final courses = results[1] as List<TheoryCourse>;
      final atRisk = results[2] as List<DeprivationStudent>;

      AttendanceAnalytics? analytics;
      if (courses.isNotEmpty) {
        analytics = await _service.getCourseAnalytics(courses.first.id);
      }

      if (!mounted) return;

      setState(() {
        _teacherProfile = profile;
        _courses = courses;
        _atRiskStudents = atRisk;
        _primaryAnalytics = analytics;
        _state = courses.isEmpty ? ScreenStateType.empty : ScreenStateType.success;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _state = ScreenStateType.error;
        _errorMessage = 'تعذر تحميل بيانات لوحة تحكم المقررات النظرية: $e';
      });
    }
  }

  void _navigateToReports(TheoryCourse course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TheoryReportsView(
          course: course,
          theoreticalService: _service,
        ),
      ),
    ).then((_) => _loadDashboardData());
  }

  Future<void> _handleSendWarning(DeprivationStudent student, String warningType) async {
    try {
      final courseId = _courses.isNotEmpty ? _courses.first.id : 'crs-swe-301';
      await _service.sendDeprivationWarning(courseId, student.studentId, warningType);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إرسال الإشعار بنجاح للطالب: ${student.fullName}'),
          backgroundColor: AppColors.success,
        ),
      );
      _loadDashboardData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل إرسال الإنذار: $e'),
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
        title: const Text('لوحة تحكم الأستاذ النظري'),
        actions: [
          IconButton(
            onPressed: _loadDashboardData,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'تحديث المؤشرات',
          ),
        ],
      ),
      body: AppStateView(
        state: _state,
        loadingMessage: 'جاري تحميل المقررات النظرية والتقارير الإحصائية...',
        emptyTitle: 'لا توجد مقررات نظرية مسندة',
        emptyMessage: 'لم يتم العثور على أي مقررات نظرية مسندة إليك لهذا الفصل.',
        emptyIcon: Icons.menu_book_outlined,
        errorMessage: _errorMessage,
        onRetry: _loadDashboardData,
        child: RefreshIndicator(
          onRefresh: _loadDashboardData,
          child: ListView(
            padding: AppSpacing.paddingLG,
            children: [
              // بطاقة الترويسة الرئيسية
              TheoreticalHeaderCard(
                teacherProfile: _teacherProfile,
                onRefresh: _loadDashboardData,
                onAtRiskTap: () {
                  if (_courses.isNotEmpty) {
                    _navigateToReports(_courses.first);
                  }
                },
              ),
              AppSpacing.gapVerticalLG,
              // قسم الرسوم البيانية الإحصائية المجمعة
              if (_primaryAnalytics != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.pie_chart_outline_rounded,
                          color: AppColors.primary,
                          size: 20.0,
                        ),
                        AppSpacing.gapHorizontalSM,
                        Text(
                          'المؤشر العام للحضور والغياب',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _primaryAnalytics!.courseCode,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapVerticalSM,
                AttendancePieChart(analytics: _primaryAnalytics!),
                AppSpacing.gapVerticalLG,
                AttendanceBarChart(weeklyTrends: _primaryAnalytics!.weeklyTrends),
                AppSpacing.gapVerticalLG,
              ],
              // قسم الطلاب في المنطقة الحرجة للحرمان
              if (_atRiskStudents.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.notification_important_rounded,
                          color: AppColors.error,
                          size: 20.0,
                        ),
                        AppSpacing.gapHorizontalSM,
                        Text(
                          'الطلاب المعرضين للحرمان (${_atRiskStudents.length})',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'تجاوز نسبة 15%',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapVerticalSM,
                ..._atRiskStudents.take(3).map(
                      (std) => DeprivationRiskCard(
                        student: std,
                        onSendWarning: (type) => _handleSendWarning(std, type),
                      ),
                    ),
                AppSpacing.gapVerticalLG,
              ],
              // قسم المقررات النظرية المسندة
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.collections_bookmark_rounded,
                        color: AppColors.primary,
                        size: 20.0,
                      ),
                      AppSpacing.gapHorizontalSM,
                      Text(
                        'المقررات النظرية المسندة (${_courses.length})',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'الفصل الحالي',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              AppSpacing.gapVerticalSM,
              ..._courses.map(
                (course) => TheoryCourseCard(
                  course: course,
                  onReportsTap: () => _navigateToReports(course),
                  onDeprivationListTap: () => _navigateToReports(course),
                ),
              ),
              AppSpacing.gapVerticalXL,
            ],
          ),
        ),
      ),
    );
  }
}
