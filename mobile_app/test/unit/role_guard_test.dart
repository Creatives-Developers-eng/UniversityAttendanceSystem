import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/app/routes.dart';
import 'package:mobile_app/authentication/role_guard.dart';
import 'package:mobile_app/authentication/user_session.dart';

void main() {
  group('RoleGuard Routing & Access Tests', () {
    test('resolveInitialRoute redirects null session to login', () {
      expect(RoleGuard.resolveInitialRoute(null), AppRoutes.login);
    });

    test('resolveInitialRoute redirects unbound device to activation', () {
      const unboundSession = UserSession(
        userId: 'u1',
        username: 'student1',
        fullName: 'أحمد علي',
        role: UserRole.student,
        deviceState: DeviceState.unregistered,
      );
      expect(RoleGuard.resolveInitialRoute(unboundSession), AppRoutes.deviceActivation);

      const pendingSession = UserSession(
        userId: 'u2',
        username: 'delegate1',
        fullName: 'عمر خالد',
        role: UserRole.delegate,
        deviceState: DeviceState.pendingVerification,
      );
      expect(RoleGuard.resolveInitialRoute(pendingSession), AppRoutes.deviceActivation);

      const revokedSession = UserSession(
        userId: 'u3',
        username: 'teacher1',
        fullName: 'د. سامي',
        role: UserRole.practicalTeacher,
        deviceState: DeviceState.revoked,
      );
      expect(RoleGuard.resolveInitialRoute(revokedSession), AppRoutes.deviceActivation);
    });

    test('resolveInitialRoute directs bound devices to their specific role dashboard', () {
      const studentSession = UserSession(
        userId: 'u1',
        username: 'student1',
        fullName: 'أحمد علي',
        role: UserRole.student,
        deviceState: DeviceState.bound,
      );
      expect(RoleGuard.resolveInitialRoute(studentSession), AppRoutes.studentDashboard);

      const delegateSession = UserSession(
        userId: 'u2',
        username: 'delegate1',
        fullName: 'عمر خالد',
        role: UserRole.delegate,
        deviceState: DeviceState.bound,
      );
      expect(RoleGuard.resolveInitialRoute(delegateSession), AppRoutes.delegateDashboard);

      const practicalSession = UserSession(
        userId: 'u3',
        username: 'practical1',
        fullName: 'م. فهد',
        role: UserRole.practicalTeacher,
        deviceState: DeviceState.bound,
      );
      expect(RoleGuard.resolveInitialRoute(practicalSession), AppRoutes.practicalTeacherDashboard);

      const theoreticalSession = UserSession(
        userId: 'u4',
        username: 'theor1',
        fullName: 'د. يوسف',
        role: UserRole.theoreticalTeacher,
        deviceState: DeviceState.bound,
      );
      expect(RoleGuard.resolveInitialRoute(theoreticalSession), AppRoutes.theoreticalTeacherDashboard);
    });

    test('canAccess enforces strict role separation', () {
      // Student permissions
      expect(RoleGuard.canAccess(UserRole.student, AppRoutes.studentDashboard), isTrue);
      expect(RoleGuard.canAccess(UserRole.student, AppRoutes.qrScanner), isTrue);
      expect(RoleGuard.canAccess(UserRole.student, AppRoutes.delegateDashboard), isFalse);
      expect(RoleGuard.canAccess(UserRole.student, AppRoutes.localSession), isFalse);
      expect(RoleGuard.canAccess(UserRole.student, AppRoutes.practicalTeacherDashboard), isFalse);

      // Delegate permissions
      expect(RoleGuard.canAccess(UserRole.delegate, AppRoutes.delegateDashboard), isTrue);
      expect(RoleGuard.canAccess(UserRole.delegate, AppRoutes.localSession), isTrue);
      expect(RoleGuard.canAccess(UserRole.delegate, AppRoutes.studentDashboard), isTrue);

      // Teachers permissions
      expect(RoleGuard.canAccess(UserRole.practicalTeacher, AppRoutes.practicalTeacherDashboard), isTrue);
      expect(RoleGuard.canAccess(UserRole.practicalTeacher, AppRoutes.studentDashboard), isFalse);
      expect(RoleGuard.canAccess(UserRole.theoreticalTeacher, AppRoutes.theoreticalTeacherDashboard), isTrue);
      expect(RoleGuard.canAccess(UserRole.theoreticalTeacher, AppRoutes.localSession), isFalse);

      // Common routes
      expect(RoleGuard.canAccess(UserRole.student, AppRoutes.profile), isTrue);
      expect(RoleGuard.canAccess(UserRole.practicalTeacher, AppRoutes.settings), isTrue);
    });
  });
}
