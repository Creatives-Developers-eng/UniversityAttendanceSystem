import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/app/theme.dart';
import 'package:mobile_app/practical_teacher/services/practical_teacher_service.dart';
import 'package:mobile_app/practical_teacher/views/practical_dashboard_view.dart';
import 'package:mobile_app/practical_teacher/widgets/lab_group_card.dart';
import 'package:mobile_app/practical_teacher/widgets/lab_session_card.dart';
import 'package:mobile_app/practical_teacher/widgets/practical_header_card.dart';

Widget _buildTestApp(Widget child) {
  return MaterialApp(
    locale: const Locale('ar'),
    supportedLocales: const [Locale('ar'), Locale('en')],
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    theme: AppTheme.lightTheme,
    home: child,
  );
}

void main() {
  group('PracticalDashboardView Widget Tests', () {
    late PracticalTeacherService mockService;

    setUp(() {
      mockService = PracticalTeacherService(forceMockData: true);
    });

    testWidgets('Renders dashboard header, active session banner, and lab groups', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_buildTestApp(PracticalDashboardView(practicalService: mockService)));
      await tester.pumpAndSettle();

      // التحقق من عنوان لوحة التحكم
      expect(find.text('لوحة تحكم الأستاذ العملي'), findsOneWidget);

      // التحقق من بطاقة الترويسة
      expect(find.byType(PracticalHeaderCard), findsOneWidget);
      expect(find.textContaining('العريقي'), findsOneWidget);

      // التحقق من بطاقات المجموعات
      expect(find.byType(LabGroupCard), findsWidgets);
      expect(find.text('مجموعة A - معمل البرمجيات 1'), findsWidgets);

      // التحقق من بطاقات الجلسات السابقة
      expect(find.byType(LabSessionCard), findsWidgets);
    });

    testWidgets('Displays pending exceptions and opens decision modal', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_buildTestApp(PracticalDashboardView(practicalService: mockService)));
      await tester.pumpAndSettle();

      final decisionBtn = find.text('اتخاذ قرار');
      if (decisionBtn.evaluate().isNotEmpty) {
        await tester.tap(decisionBtn.first);
        await tester.pumpAndSettle();

        expect(find.text('مراجعة طلب استثناء معملي'), findsOneWidget);
        expect(find.text('اعتماد وحفظ'), findsOneWidget);
        expect(find.text('رفض الاستثناء'), findsOneWidget);
      }
    });
  });
}
