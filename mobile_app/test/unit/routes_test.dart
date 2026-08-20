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
      expect(AppRoutes.attendanceHistory, '/attendance/history');
      expect(AppRoutes.profile, '/profile');
      expect(AppRoutes.settings, '/settings');
    });

    test('onGenerateRoute produces valid routes for defined paths', () {
      final initialRoute = AppRoutes.onGenerateRoute(const RouteSettings(name: AppRoutes.initial));
      expect(initialRoute, isA<MaterialPageRoute>());

      final loginRoute = AppRoutes.onGenerateRoute(const RouteSettings(name: AppRoutes.login));
      expect(loginRoute, isA<MaterialPageRoute>());

      final studentRoute = AppRoutes.onGenerateRoute(const RouteSettings(name: AppRoutes.studentDashboard));
      expect(studentRoute, isA<MaterialPageRoute>());

      final notFoundRoute = AppRoutes.onGenerateRoute(const RouteSettings(name: '/unknown-route'));
      expect(notFoundRoute, isA<MaterialPageRoute>());
    });
  });
}
