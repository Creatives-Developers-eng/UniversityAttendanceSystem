import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/app/theme.dart';
import 'package:mobile_app/student/services/student_service.dart';
import 'package:mobile_app/student/views/student_profile_view.dart';
import 'package:mobile_app/student/widgets/student_id_card.dart';

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
  group('StudentProfileView Widget Tests', () {
    late StudentService mockService;

    setUp(() {
      mockService = StudentService(forceMockData: true);
    });

    testWidgets('Renders student digital ID card and details', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(_buildTestApp(StudentProfileView(studentService: mockService)));
      await tester.pumpAndSettle();

      expect(find.text('الملف الشخصي والبطاقة الجامعية'), findsOneWidget);
      expect(find.byType(StudentIdCard), findsOneWidget);
      expect(find.text('جامعة المستقبل الذكية'), findsOneWidget);
      expect(find.text('أحمد علي عبد الله'), findsWidgets);
      expect(find.text('الرقم الجامعي'), findsOneWidget);
      expect(find.text('STD-2023-4019'), findsWidgets);
      expect(find.text('القسم الأكاديمي'), findsOneWidget);
      expect(find.text('هندسة تقنية المعلومات'), findsWidgets);
    });

    testWidgets('Displays logout confirmation dialog on button press', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(_buildTestApp(StudentProfileView(studentService: mockService)));
      await tester.pumpAndSettle();

      final logoutBtn = find.text('تسجيل الخروج من الحساب');
      expect(logoutBtn, findsOneWidget);

      await tester.ensureVisible(logoutBtn);
      await tester.tap(logoutBtn);
      await tester.pumpAndSettle();

      expect(find.text('هل أنت متأكد من رغبتك في تسجيل الخروج من التطبيق؟'), findsOneWidget);
      expect(find.text('إلغاء'), findsOneWidget);
      expect(find.text('تأكيد الخروج'), findsOneWidget);

      // إلغاء الخروج
      await tester.tap(find.text('إلغاء'));
      await tester.pumpAndSettle();

      expect(find.text('هل أنت متأكد من رغبتك في تسجيل الخروج من التطبيق؟'), findsNothing);
    });
  });
}
