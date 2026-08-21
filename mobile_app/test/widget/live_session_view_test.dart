import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/app/theme.dart';
import 'package:mobile_app/delegate/models/delegate_section.dart';
import 'package:mobile_app/delegate/models/delegate_session.dart';
import 'package:mobile_app/delegate/services/delegate_service.dart';
import 'package:mobile_app/delegate/views/live_session_view.dart';
import 'package:mobile_app/delegate/widgets/live_qr_broadcaster_card.dart';
import 'package:mobile_app/delegate/widgets/session_controls_bar.dart';

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
  group('LiveSessionView Widget Tests', () {
    late DelegateService mockService;
    late DelegateSession mockSession;

    setUp(() {
      mockService = DelegateService(forceMockData: true);
      mockSession = DelegateSession(
        id: 'ses-live-test',
        sectionId: 'sec-001-p',
        courseCode: 'CS301',
        courseName: 'هندسة البرمجيات المتقدمة',
        sectionNumber: '01',
        sectionType: DelegateSectionType.practical,
        teacherName: 'د. محمد السعيد',
        delegateId: 'usr-std-001',
        delegateName: 'أحمد علي',
        sessionState: DelegateSessionState.active,
        openedAt: DateTime.now(),
        totalExpectedStudents: 30,
        attendedCount: 0,
        roomName: 'معمل الحاسوب 3',
      );
    });

    testWidgets('Renders live session components, QR broadcaster, and controls', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_buildTestApp(LiveSessionView(
        session: mockSession,
        delegateService: mockService,
      )));
      await tester.pump(const Duration(milliseconds: 300));

      // التحقق من عنوان المادة والقاعة
      expect(find.text('هندسة البرمجيات المتقدمة'), findsOneWidget);
      expect(find.textContaining('معمل الحاسوب 3'), findsOneWidget);

      // التحقق من العدادات الإحصائية
      expect(find.text('الحاضرين'), findsOneWidget);
      expect(find.text('في الطابور'), findsOneWidget);
      expect(find.text('المتبقين'), findsOneWidget);
      expect(find.text('الإجمالي'), findsOneWidget);

      // التحقق من بطاقة الـ QR الديناميكي
      expect(find.byType(LiveQrBroadcasterCard), findsOneWidget);
      expect(find.text('رمز التحضير الديناميكي (Dynamic QR)'), findsOneWidget);
      expect(find.text('بث نشط'), findsOneWidget);

      // التحقق من شريط التحكم السفلي
      expect(find.byType(SessionControlsBar), findsOneWidget);
      expect(find.text('إيقاف مؤقت'), findsOneWidget);
      expect(find.text('إنهاء الجلسة'), findsOneWidget);
    });

    testWidgets('Toggles broadcasting pause and resume', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_buildTestApp(LiveSessionView(
        session: mockSession,
        delegateService: mockService,
      )));
      await tester.pump(const Duration(milliseconds: 300));

      // النقر على إيقاف مؤقت
      final pauseBtn = find.text('إيقاف مؤقت');
      expect(pauseBtn, findsOneWidget);

      await tester.tap(pauseBtn);
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('استئناف'), findsOneWidget);
      expect(find.text('متوقف مؤقتاً'), findsOneWidget);

      // استئناف
      await tester.tap(find.text('استئناف'));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('إيقاف مؤقت'), findsOneWidget);
      expect(find.text('بث نشط'), findsOneWidget);
    });

    testWidgets('Opens manual attendance dialog and validates inputs', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_buildTestApp(LiveSessionView(
        session: mockSession,
        delegateService: mockService,
      )));
      await tester.pump(const Duration(milliseconds: 300));

      final manualBtn = find.byTooltip('تحضير يدوي استثنائي');
      expect(manualBtn, findsOneWidget);

      await tester.tap(manualBtn);
      await tester.pump(const Duration(milliseconds: 300));

      // التحقق من فتح الحوار
      expect(find.text('تحضير يدوي استثنائي'), findsOneWidget);
      expect(find.text('الرقم الجامعي للطالب *'), findsOneWidget);
      expect(find.text('سبب التحضير اليدوي *'), findsOneWidget);

      // الضغط على تأكيد دون إدخال للتحقق من التحقق من الصحة
      await tester.tap(find.text('تأكيد التحضير'));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('الرجاء إدخال الرقم الجامعي'), findsOneWidget);
      expect(find.text('المبرر إلزامي لتوثيق الاستثناء'), findsOneWidget);
    });
  });
}
