import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/app/app.dart';
import 'package:mobile_app/app/routes.dart';

void main() {
  group('UniversityAttendanceApp Widget Verification', () {
    testWidgets('App initializes with Arabic RTL localization and correct title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const UniversityAttendanceApp(
          initialRoute: AppRoutes.initial,
        ),
      );
      await tester.pumpAndSettle();

      // Verify MaterialApp is present
      final materialAppFinder = find.byType(MaterialApp);
      expect(materialAppFinder, findsOneWidget);

      final MaterialApp materialApp = tester.widget(materialAppFinder);
      expect(materialApp.title, 'نظام الحضور الجامعي الذكي');
      expect(materialApp.locale, const Locale('ar'));
      expect(materialApp.supportedLocales, contains(const Locale('ar')));
      expect(materialApp.supportedLocales, contains(const Locale('en')));
      expect(materialApp.debugShowCheckedModeBanner, isFalse);
    });

    testWidgets('App renders Arabic text and RTL directionality in placeholder screens', (WidgetTester tester) async {
      await tester.pumpWidget(
        const UniversityAttendanceApp(
          initialRoute: AppRoutes.login,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('تسجيل الدخول'), findsWidgets);
      expect(find.text('أدخل بيانات حسابك للمتابعة'), findsOneWidget);
    });
  });
}
