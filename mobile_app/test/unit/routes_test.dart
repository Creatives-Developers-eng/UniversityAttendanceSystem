import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/app/routes.dart';

void main() {
  group('AppRoutes Verification', () {
    test('Route constants are defined properly', () {
      expect(AppRoutes.initial, '/');
      expect(AppRoutes.splash, '/splash');
      expect(AppRoutes.login, '/login');
      expect(AppRoutes.deviceActivation, '/device-activation');
      expect(AppRoutes.studentDashboard, '/student/dashboard');
      expect(AppRoutes.delegateDashboard, '/delegate/dashboard');
      expect(AppRoutes.practicalTeacherDashboard, '/practical-teacher/dashboard');
      expect(AppRoutes.theoreticalTeacherDashboard, '/theoretical-teacher/dashboard');
      expect(AppRoutes.qrScanner, '/student/qr-scanner');
      expect(AppRoutes.localSession, '/delegate/session');
      expect(AppRoutes.courses, '/student/courses');
      expect(AppRoutes.courseDetails, '/student/course-details');
      expect(AppRoutes.attendanceHistory, '/attendance/history');
      expect(AppRoutes.profile, '/profile');
      expect(AppRoutes.settings, '/settings');
      expect(AppRoutes.labGroups, '/practical-teacher/lab-groups');
      expect(AppRoutes.labAttendance, '/practical-teacher/lab-attendance');
    });

    test('onGenerateRoute produces valid routes for defined paths', () {
      final initialRoute = AppRoutes.onGenerateRoute(const RouteSettings(name: AppRoutes.initial));
      expect(initialRoute, isA<MaterialPageRoute>());

      final loginRoute = AppRoutes.onGenerateRoute(const RouteSettings(name: AppRoutes.login));
      expect(loginRoute, isA<MaterialPageRoute>());

      final studentRoute = AppRoutes.onGenerateRoute(const RouteSettings(name: AppRoutes.studentDashboard));
      expect(studentRoute, isA<MaterialPageRoute>());

      final coursesRoute = AppRoutes.onGenerateRoute(const RouteSettings(name: AppRoutes.courses));
      expect(coursesRoute, isA<MaterialPageRoute>());

      final courseDetailsRoute = AppRoutes.onGenerateRoute(const RouteSettings(name: AppRoutes.courseDetails, arguments: 'CS301'));
      expect(courseDetailsRoute, isA<MaterialPageRoute>());

      final delegateRoute = AppRoutes.onGenerateRoute(const RouteSettings(name: AppRoutes.delegateDashboard));
      expect(delegateRoute, isA<MaterialPageRoute>());

      final localSessionRoute = AppRoutes.onGenerateRoute(const RouteSettings(name: AppRoutes.localSession));
      expect(localSessionRoute, isA<MaterialPageRoute>());

      final delegateSheetRoute = AppRoutes.onGenerateRoute(const RouteSettings(name: AppRoutes.delegateAttendanceSheet));
      expect(delegateSheetRoute, isA<MaterialPageRoute>());

      final practicalRoute = AppRoutes.onGenerateRoute(const RouteSettings(name: AppRoutes.practicalTeacherDashboard));
      expect(practicalRoute, isA<MaterialPageRoute>());

      final labGroupsRoute = AppRoutes.onGenerateRoute(const RouteSettings(name: AppRoutes.labGroups));
      expect(labGroupsRoute, isA<MaterialPageRoute>());

      final labAttendanceRoute = AppRoutes.onGenerateRoute(const RouteSettings(name: AppRoutes.labAttendance));
      expect(labAttendanceRoute, isA<MaterialPageRoute>());

      final historyRoute = AppRoutes.onGenerateRoute(const RouteSettings(name: AppRoutes.attendanceHistory));
      expect(historyRoute, isA<MaterialPageRoute>());

      final profileRoute = AppRoutes.onGenerateRoute(const RouteSettings(name: AppRoutes.profile));
      expect(profileRoute, isA<MaterialPageRoute>());

      final notFoundRoute = AppRoutes.onGenerateRoute(const RouteSettings(name: '/unknown-route'));
      expect(notFoundRoute, isA<MaterialPageRoute>());
    });
  });
}
