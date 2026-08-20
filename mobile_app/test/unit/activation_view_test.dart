import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/app/routes.dart';
import 'package:mobile_app/app/theme.dart';
import 'package:mobile_app/authentication/activation_service.dart';
import 'package:mobile_app/authentication/activation_view.dart';
import 'package:mobile_app/authentication/user_session.dart';

void main() {
  group('ActivationView Widget Tests', () {
    Widget buildTestApp({
      ActivationService? service,
      UserSession? session,
      ValueChanged<UserSession>? onComplete,
    }) {
      return MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: ActivationView(
          activationService: service,
          currentSession: session,
          onActivationComplete: onComplete,
        ),
      );
    }

    testWidgets('Renders activation screen elements correctly', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('توثيق وتفعيل الجهاز'), findsOneWidget);
      expect(find.text('تفعيل الجهاز الأكاديمي'), findsOneWidget);
      expect(find.text('رمز التفعيل'), findsOneWidget);
      expect(find.text('تأكيد وربط الجهاز'), findsOneWidget);
      expect(find.byIcon(Icons.phonelink_lock_rounded), findsOneWidget);
    });

    testWidgets('Shows validation error on empty submission', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      // Click submit with empty code
      await tester.tap(find.text('تأكيد وربط الجهاز'));
      await tester.pumpAndSettle();

      expect(find.text('يرجى إدخال رمز التفعيل'), findsOneWidget);
    });

    testWidgets('Submits valid code and triggers success callback', (tester) async {
      UserSession? completedSession;

      await tester.pumpWidget(
        buildTestApp(
          onComplete: (session) {
            completedSession = session;
          },
        ),
      );
      await tester.pumpAndSettle();

      // Enter code
      await tester.enterText(find.byType(TextFormField), 'ACT-9000');
      await tester.pumpAndSettle();

      // Submit
      await tester.tap(find.text('تأكيد وربط الجهاز'));
      await tester.pump(); // Start loading

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 400)); // Service finishes
      await tester.pump(const Duration(seconds: 1)); // 900ms delay finishes
      await tester.pumpAndSettle();

      expect(completedSession?.deviceState, DeviceState.bound);
      expect(find.text('لوحة تحكم الطالب'), findsWidgets);
    });
  });
}
