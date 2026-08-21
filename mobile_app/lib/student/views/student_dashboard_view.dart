import 'package:flutter/material.dart';
import '../../app/routes.dart';
import '../../shared/tokens/tokens.dart';
import '../../shared/widgets/app_state_view.dart';
import '../models/attendance_stats.dart';
import '../models/student_attendance_record.dart';
import '../models/student_course.dart';
import '../models/student_profile.dart';
import '../services/student_service.dart';
import '../widgets/attendance_history_card.dart';
import '../widgets/attendance_rate_card.dart';
import '../widgets/course_card.dart';
import '../widgets/quick_qr_scan_button.dart';
import '../widgets/student_header_card.dart';
import 'attendance_history_view.dart';
import 'course_details_view.dart';
import 'courses_view.dart';
import 'student_profile_view.dart';

/// الشاشة الرئيسية ولوحة تحكم الطالب الشاملة (Student Dashboard View)
/// تضم شريط التنقل السفلي والوصول السريع للمقررات وسجلات الحضور والـ QR
class StudentDashboardView extends StatefulWidget {
  final StudentService? studentService;
  final int initialTabIndex;

  const StudentDashboardView({
    super.key,
    this.studentService,
    this.initialTabIndex = 0,
  });

  @override
  State<StudentDashboardView> createState() => _StudentDashboardViewState();
}

class _StudentDashboardViewState extends State<StudentDashboardView> {
  late final StudentService _service;
  late int _currentIndex;

  ScreenStateType _state = ScreenStateType.loading;
  StudentProfile? _profile;\n  List<StudentCourse> _courses = [];
  List<StudentAttendanceRecord> _recentRecords = [];
  AttendanceStats _stats = const AttendanceStats();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _service = widget.studentService ?? StudentService();
    _currentIndex = widget.initialTabIndex;
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _state = ScreenStateType.loading;
      _errorMessage = null;
    });

    try {
      final profileFuture = _service.getStudentProfile();
      final coursesFuture = _service.getEnrolledCourses();
      final recordsFuture = _service.getAttendanceHistory();
      final statsFuture = _service.getAttendanceStats();

      final results = await Future.wait([
        profileFuture,
        coursesFuture,
        recordsFuture,
        statsFuture,
      ]);

      if (!mounted) return;

      setState(() {
        _profile = results[0] as StudentProfile;
        _courses = results[1] as List<StudentCourse>;
        _recentRecords = (results[2] as List<StudentAttendanceRecord>).take(3).toList();
        _stats = results[3] as AttendanceStats;
        _state = ScreenStateType.success;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _state = ScreenStateType.error;
        _errorMessage = 'تعذر تحميل بيانات لوحة التحكم: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeDashboard(context),
          CoursesView(studentService: _service),
          AttendanceHistoryView(studentService: _service),
          StudentProfileView(studentService: _service),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: AppColors.surface,
        elevation: 3.0,
        indicatorColor: AppColors.primaryLight.withValues(alpha: 0.15),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded, color: AppColors.primary),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded, color: AppColors.primary),
            label: 'المقررات',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history_rounded, color: AppColors.primary),
            label: 'سجل الحضور',
          ),
          NavigationDestination(
            icon: Icon(Icons.badge_outlined),
            selectedIcon: Icon(Icons.badge_rounded, color: AppColors.primary),
            label: 'البطاقة الذكية',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeDashboard(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم الطالب'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.qrScanner);
            },
            icon: const Icon(Icons.qr_code_scanner_rounded),
            tooltip: 'مسح رمز QR',
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
        loadingMessage: 'جاري تحميل لوحة تحكم الطالب...',
        emptyTitle: 'لا توجد بيانات',
        emptyMessage: 'لم يتم العثور على بيانات الطالب الأكاديمية.',
        emptyIcon: Icons.school_outlined,
        errorMessage: _errorMessage,
        onRetry: _loadDashboardData,
        child: _profile == null
            ? const SizedBox.shrink()
            : RefreshIndicator(
                onRefresh: _loadDashboardData,
                child: ListView(
                  padding: AppSpacing.paddingLG,
                  children: [
                    // بطاقة رأس لوحة التحكم
                    StudentHeaderCard(
                      profile: _profile!,
                      onProfileTap: () {
                        setState(() {
                          _currentIndex = 3; // الانتقال لتبويب البطاقة والملف
                        });
                      },
                    ),
                    AppSpacing.gapVerticalLG,
                    // زر مسح الـ QR السريع
                    QuickQrScanButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.qrScanner);
                      },
                    ),
                    AppSpacing.gapVerticalLG,
                    // بطاقة إحصائيات ومعدل الحضور
                    AttendanceRateCard(
                      stats: _stats,
                      onHistoryTap: () {
                        setState(() {
                          _currentIndex = 2; // الانتقال لتبويب سجل الحضور
                        });
                      },
                    ),
                    AppSpacing.gapVerticalLG,
                    // قسم المقررات المسجلة
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.menu_book_rounded,
                              color: AppColors.primary,
                              size: 20.0,
                            ),
                            AppSpacing.gapHorizontalSM,
                            Text(
                              'المقررات المسجلة (${_courses.length})',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _currentIndex = 1; // الانتقال لتبويب المقررات
                            });
                          },
                          child: const Text('عرض الكل'),
                        ),
                      ],
                    ),
                    AppSpacing.gapVerticalSM,
                    if (_courses.isEmpty)
                      Container(
                        padding: AppSpacing.paddingLG,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.radiusMD),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Text(
                          'لا توجد مقررات مسجلة حالياً.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      )
                    else
                      ..._courses.take(3).map(
                            (course) => CourseCard(
                              course: course,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CourseDetailsView(
                                      courseId: course.id,
                                      initialCourse: course,
                                      studentService: _service,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                    AppSpacing.gapVerticalLG,
                    // قسم آخر سجلات الحضور
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.history_rounded,
                              color: AppColors.primary,
                              size: 20.0,
                            ),
                            AppSpacing.gapHorizontalSM,
                            Text(
                              'آخر المحاضرات المسجلة',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _currentIndex = 2; // الانتقال لتبويب سجل الحضور
                            });
                          },
                          child: const Text('السجل الكامل'),
                        ),
                      ],
                    ),
                    AppSpacing.gapVerticalSM,
                    if (_recentRecords.isEmpty)
                      Container(
                        padding: AppSpacing.paddingLG,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.radiusMD),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Text(
                          'لا توجد سجلات حضور سابقة.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      )
                    else
                      ..._recentRecords.map((r) => AttendanceHistoryCard(record: r)),
                    AppSpacing.gapVerticalXL,
                  ],
                ),
              ),
      ),
    );
  }
}
