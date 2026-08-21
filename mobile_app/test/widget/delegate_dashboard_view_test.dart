import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/app/theme.dart';
import 'package:mobile_app/delegate/services/delegate_service.dart';
import 'package:mobile_app/delegate/views/delegate_dashboard_view.dart';
import 'package:mobile_app/delegate/widgets/delegate_header_card.dart';
import 'package:mobile_app/delegate/widgets/delegate_session_card.dart';

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
  group('DelegateDashboardView Widget Tests', () {
    late DelegateService mockService;

    setUp(() {
      mockService = DelegateService(forceMockData: true);
    });

    testWidgets('Renders delegate dashboard header, start session button, and sections', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_buildTestApp(DelegateDashboardView(delegateService: mockService)));
      await tester.pumpAndSettle();

      // التحقق من عنوان لوحة التحكم
      expect(find.text('لوحة تحكم المندوب'), findsOneWidget);

      // التحقق من بطاقة الترويسة
      expect(find.byType(DelegateHeaderCard), findsOneWidget);
      expect(find.text('أحمد علي عبد الله'), findsOneWidget);
      expect(find.text('مندوب الدفعة المعتمد'), findsOneWidget);

      // التحقق من زر بدء الجلسة السريع
      expect(find.text('بدء جلسة حضور جديدة في القاعة'), findsOneWidget);

      // التحقق من الشعب المخصصة
      expect(find.textContaining('الشعب المخصصة لك'), findsOneWidget);
      expect(find.text('هندسة البرمجيات المتقدمة'), findsWidgets);

      // التحقق من بطاقات الجلسات السابقة
      expect(find.byType(DelegateSessionCard), findsWidgets);
      expect(find.text('تمت المزامنة'), findsWidgets);
    });

    testWidgets('Opens Start Session modal when tapping start session button', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_buildTestApp(DelegateDashboardView(delegateService: mockService)));
      await tester.pumpAndSettle();

      final startBtn = find.text('بدء جلسة حضور جديدة في القاعة');
      expect(startBtn, findsOneWidget);

      await tester.tap(startBtn);
      await tester.pumpAndSettle();

      // التحقق من فتح النافذة المنبثقة
      expect(find.text('بدء جلسة حضور جديدة'), findsOneWidget);
      expect(find.text('بدء الجلسة وتشغيل الخادم المحلي'), findsOneWidget);
    });
  });
}
