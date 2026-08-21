import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/app/theme.dart';
import 'package:mobile_app/theoretical_teacher/services/theoretical_teacher_service.dart';
import 'package:mobile_app/theoretical_teacher/views/theoretical_dashboard_view.dart';
import 'package:mobile_app/theoretical_teacher/widgets/attendance_bar_chart.dart';
import 'package:mobile_app/theoretical_teacher/widgets/attendance_pie_chart.dart';
import 'package:mobile_app/theoretical_teacher/widgets/deprivation_risk_card.dart';
import 'package:mobile_app/theoretical_teacher/widgets/theoretical_header_card.dart';
import 'package:mobile_app/theoretical_teacher/widgets/theory_course_card.dart';

Widget _buildTestApp(Widget child) {
  return MaterialApp(
    locale: const Locale('ar'),
    supportedLocales: const [Locale('ar'), Locale('en')],
    localizationsDelegates: const [\n      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    theme: AppTheme.lightTheme,
    home: child,
  );
}

void main() {
  group('TheoreticalDashboardView Widget Tests', () {\n    late TheoreticalTeacherService mockService;

    setUp(() {
      mockService = TheoreticalTeacherService(forceMockData: true);
    });

    testWidgets('Renders dashboard header, charts, at-risk section, and courses', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_buildTestApp(
        TheoreticalDashboardView(theoreticalService: mockService),
      ));
      await tester.pumpAndSettle();

      // التحقق من عنوان لوحة التحكم
      expect(find.text('لوحة تحكم الأستاذ النظري'), findsOneWidget);

      // التحقق من ترويسة الأستاذ النظري
      expect(find.byType(TheoreticalHeaderCard), findsOneWidget);
      expect(find.textContaining('السقاف'), findsOneWidget);

      // التحقق من وجود المخطط الدائري ومخطط الأعمدة
      expect(find.byType(AttendancePieChart), findsOneWidget);
      expect(find.byType(AttendanceBarChart), findsOneWidget);

      // التحقق من وجود بطاقات الطلاب المعرضين للحرمان
      expect(find.byType(DeprivationRiskCard), findsWidgets);

      // التحقق من بطاقات المقررات النظرية
      expect(find.byType(TheoryCourseCard), findsWidgets);
      expect(find.text('هندسة البرمجيات المتقدمة'), findsWidgets);
    });

    testWidgets('Triggers warning action on at-risk student card', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_buildTestApp(
        TheoreticalDashboardView(theoreticalService: mockService),
      ));
      await tester.pumpAndSettle();

      final sendWarningBtn = find.text('إرسال إنذار');
      if (sendWarningBtn.evaluate().isNotEmpty) {
        await tester.tap(sendWarningBtn.first);
        await tester.pumpAndSettle();

        expect(find.textContaining('تم إرسال الإشعار بنجاح'), findsOneWidget);
      }
    });
  });
}
