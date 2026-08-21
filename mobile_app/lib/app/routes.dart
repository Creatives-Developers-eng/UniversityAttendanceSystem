import 'package:flutter/material.dart';
import '../authentication/activation_view.dart';
import '../delegate/models/delegate_session.dart';
import '../delegate/views/delegate_attendance_sheet.dart';
import '../delegate/views/delegate_dashboard_view.dart';
import '../delegate/views/live_session_view.dart';
import '../shared/tokens/tokens.dart';
import '../student/views/attendance_history_view.dart';
import '../student/views/course_details_view.dart';
import '../student/views/courses_view.dart';
import '../student/views/student_dashboard_view.dart';
import '../student/views/student_profile_view.dart';

/// المسارات الرسمية ونظام التوجيه لتطبيق الحضور الجامعي الذكي
class AppRoutes {
  AppRoutes._();

  // --- أسماء المسارات (Route Names) ---
  static const String initial = '/';
  static const String splash = '/splash';
  static const String login = '/login';
  static const String deviceActivation = '/device-activation';
  static const String studentDashboard = '/student/dashboard';
  static const String delegateDashboard = '/delegate/dashboard';
  static const String practicalTeacherDashboard = '/practical-teacher/dashboard';
  static const String theoreticalTeacherDashboard = '/theoretical-teacher/dashboard';
  static const String qrScanner = '/student/qr-scanner';
  static const String localSession = '/delegate/session';
  static const String attendanceHistory = '/attendance/history';
  static const String profile = '/profile';
  static const String settings = '/settings';

  static const String courses = '/student/courses';
  static const String courseDetails = '/student/course-details';
  static const String delegateAttendanceSheet = '/delegate/attendance-sheet';

  /// مولد المسارات والتنقل الآمن (Route Generator)
  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case initial:
      case splash:
        return _buildRoute(
          const _PlaceholderScreen(
            title: 'شاشة البداية والتحميل',
            subtitle: 'نظام الحضور الجامعي الذكي',
            icon: Icons.school_rounded,
          ),
          routeSettings,
        );

      case login:
        return _buildRoute(
          const _PlaceholderScreen(
            title: 'تسجيل الدخول',
            subtitle: 'أدخل بيانات حسابك للمتابعة',
            icon: Icons.login_rounded,
          ),
          routeSettings,
        );

      case deviceActivation:
        return _buildRoute(
          const ActivationView(),
          routeSettings,
        );

      case studentDashboard:
        return _buildRoute(
          const StudentDashboardView(),
          routeSettings,
        );

      case courses:
        return _buildRoute(
          const CoursesView(),
          routeSettings,
        );

      case courseDetails:
        final courseId = routeSettings.arguments as String? ?? '';
        return _buildRoute(
          CourseDetailsView(courseId: courseId),
          routeSettings,
        );

      case delegateDashboard:
        return _buildRoute(
          const DelegateDashboardView(),
          routeSettings,
        );

      case localSession:
        final session = routeSettings.arguments as DelegateSession?;
        if (session != null) {
          return _buildRoute(
            LiveSessionView(session: session),
            routeSettings,
          );
        }
        return _buildRoute(
          const DelegateDashboardView(),
          routeSettings,
        );

      case delegateAttendanceSheet:
        final args = routeSettings.arguments as Map<String, dynamic>? ?? {};
        return _buildRoute(
          DelegateAttendanceSheet(
            sectionId: args['sectionId'] as String? ?? 'sec-001-p',
            sessionId: args['sessionId'] as String?,
            courseCode: args['courseCode'] as String? ?? 'CS301',
            courseName: args['courseName'] as String? ?? 'مقرر دراسي',
            sectionNumber: args['sectionNumber'] as String? ?? '01',
          ),
          routeSettings,
        );

      case practicalTeacherDashboard:
        return _buildRoute(
          const _PlaceholderScreen(
            title: 'لوحة تحكم الأستاذ العملي',
            subtitle: 'إدارة الشعب والمعامل والتحضير الميداني',
            icon: Icons.science_rounded,
          ),
          routeSettings,
        );

      case theoreticalTeacherDashboard:
        return _buildRoute(
          const _PlaceholderScreen(
            title: 'لوحة تحكم الأستاذ النظري',
            subtitle: 'إدارة المحاضرات النظرية واعتماد الغيابات',
            icon: Icons.menu_book_rounded,
          ),
          routeSettings,
        );

      case qrScanner:
        return _buildRoute(
          const _PlaceholderScreen(
            title: 'مسح رمز الاستجابة السريعة',
            subtitle: 'وجّه الكاميرا نحو رمز QR الجلسة',
            icon: Icons.qr_code_scanner_rounded,
          ),
          routeSettings,
        );

      case attendanceHistory:
        final courseCode = routeSettings.arguments as String?;
        return _buildRoute(
          AttendanceHistoryView(initialCourseCode: courseCode),
          routeSettings,
        );

      case profile:
        return _buildRoute(
          const StudentProfileView(),
          routeSettings,
        );

      case settings:
        return _buildRoute(
          const _PlaceholderScreen(
            title: 'الإعدادات',
            subtitle: 'خيارات المظهر واللغة والإشعارات',
            icon: Icons.settings_rounded,
          ),
          routeSettings,
        );

      default:
        return _buildRoute(
          _NotFoundScreen(routeName: routeSettings.name ?? 'غير معروف'),
          routeSettings,
        );
    }
  }

  static MaterialPageRoute _buildRoute(Widget screen, RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => screen,
      settings: settings,
    );
  }
}

/// شاشة موحدة للمسارات غير المعرفة (404 Not Found)
class _NotFoundScreen extends StatelessWidget {
  final String routeName;

  const _NotFoundScreen({required this.routeName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('الصفحة غير موجودة'),
      ),
      body: Center(
        child: Padding(
          padding: AppSpacing.paddingLG,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.search_off_rounded,
                size: 72.0,
                color: AppColors.error,
              ),
              AppSpacing.gapVerticalLG,
              Text(
                'المسار المطلوب غير متوفر',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapVerticalSM,
              Text(
                'لم نتمكن من العثور على المسار ($routeName)',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapVerticalXL,
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('العودة للخلف'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// شاشة تمهيدية هيكلية قابلة للاستبدال مع تقدم المراحل
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _PlaceholderScreen({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Padding(
          padding: AppSpacing.paddingLG,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 40.0,
                  color: AppColors.primary,
                ),
              ),
              AppSpacing.gapVerticalLG,
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapVerticalSM,
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
