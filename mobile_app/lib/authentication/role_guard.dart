import '../app/routes.dart';
import 'user_session.dart';

/// نظام حراسة وتوجيه المسارات بحسب دور المستخدم وحالة جهازه
/// مسؤول عن منع الوصول غير المصرح به وضمان توجيه كل مستخدم لواجهته المعتمدة
class RoleGuard {
  RoleGuard._();

  /// التحقق مما إذا كان جهاز المستخدم موثقاً ومرتبطاً بحسابه
  static bool isDeviceBound(UserSession? session) {
    return session != null && session.deviceState == DeviceState.bound;
  }

  /// تحديد المسار التوجيهي الافتراضي بناءً على حالة الجلسة وتوثيق الجهاز والدور
  static String resolveInitialRoute(UserSession? session) {
    if (session == null) {
      return AppRoutes.login;
    }

    // إذا لم يكن الجهاز مرتبطاً وموثقاً، يتم تحويله لمسار التفعيل
    if (!isDeviceBound(session)) {
      return AppRoutes.deviceActivation;
    }

    // التوجيه إلى لوحة التحكم الخاصة بالدور المعتمد
    return getDashboardRoute(session.role);
  }

  /// إرجاع مسار لوحة التحكم الرسمي المخصص للدور
  static String getDashboardRoute(UserRole role) {
    switch (role) {
      case UserRole.student:
        return AppRoutes.studentDashboard;
      case UserRole.delegate:
        return AppRoutes.delegateDashboard;
      case UserRole.practicalTeacher:
        return AppRoutes.practicalTeacherDashboard;
      case UserRole.theoreticalTeacher:
        return AppRoutes.theoreticalTeacherDashboard;
    }
  }

  /// فحص صلاحية نفاذ دور معين لمسار محدد داخل التطبيق
  static bool canAccess(UserRole role, String targetRoute) {
    // المسارات العامة المتاحة لجميع المستخدمين الموثقين
    final commonAllowedRoutes = <String>{
      AppRoutes.profile,
      AppRoutes.settings,
      AppRoutes.attendanceHistory,
      AppRoutes.deviceActivation,
    };

    if (commonAllowedRoutes.contains(targetRoute)) {
      return true;
    }

    switch (role) {
      case UserRole.student:
        return targetRoute == AppRoutes.studentDashboard ||
            targetRoute == AppRoutes.qrScanner ||
            targetRoute == AppRoutes.attendanceHistory;

      case UserRole.delegate:
        return targetRoute == AppRoutes.delegateDashboard ||
            targetRoute == AppRoutes.localSession ||
            targetRoute == AppRoutes.studentDashboard ||
            targetRoute == AppRoutes.qrScanner ||
            targetRoute == AppRoutes.attendanceHistory;

      case UserRole.practicalTeacher:
        return targetRoute == AppRoutes.practicalTeacherDashboard ||
            targetRoute == AppRoutes.attendanceHistory;

      case UserRole.theoreticalTeacher:
        return targetRoute == AppRoutes.theoreticalTeacherDashboard ||
            targetRoute == AppRoutes.attendanceHistory;
    }
  }

  /// التحقق من إمكانية التنقل إلى مسار مستهدف مع الجلسة الحالية
  static bool validateNavigation(UserSession? session, String targetRoute) {
    if (session == null) {
      return targetRoute == AppRoutes.login || targetRoute == AppRoutes.splash;
    }

    if (!isDeviceBound(session)) {
      return targetRoute == AppRoutes.deviceActivation ||
          targetRoute == AppRoutes.login ||
          targetRoute == AppRoutes.splash;
    }

    return canAccess(session.role, targetRoute);
  }
}
