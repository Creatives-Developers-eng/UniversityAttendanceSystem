import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/app/theme.dart';
import 'package:mobile_app/student/services/student_service.dart';
import 'package:mobile_app/student/views/student_dashboard_view.dart';
import 'package:mobile_app/student/widgets/attendance_rate_card.dart';
import 'package:mobile_app/student/widgets/quick_qr_scan_button.dart';
import 'package:mobile_app/student/widgets/student_header_card.dart';

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
  group('StudentDashboardView Widget Tests', () {
    late StudentService mockService;

    setUp(() {
      mockService = StudentService(forceMockData: true);
    });

    testWidgets('Renders dashboard header, QR button, stats and courses', (tester) async {
      await tester.pumpWidget(_buildTestApp(StudentDashboardView(studentService: mockService)));
      await tester.pumpAndSettle();

      // التحقق من عنوان لوحة التحكم والـ AppBar
      expect(find.text('لوحة تحكم الطالب'), findsOneWidget);

      // التحقق من بطاقة الرأس والاسم
      expect(find.byType(StudentHeaderCard), findsOneWidget);
      expect(find.text('أحمد علي عبد الله'), findsOneWidget);
      expect(find.text('STD-2023-4019'), findsOneWidget);

      // التحقق من زر الـ QR السريع
      expect(find.byType(QuickQrScanButton), findsOneWidget);
      expect(find.text('تسجيل الحضور الآن (QR)'), findsOneWidget);

      // التحقق من بطاقة معدل الحضور
      expect(find.byType(AttendanceRateCard), findsOneWidget);
      expect(find.text('معدل الحضور العام'), findsOneWidget);

      // التحقق من شريط التنقل السفلي والوجهات
      expect(find.text('الرئيسية'), findsOneWidget);
      expect(find.text('المقررات'), findsOneWidget);
      expect(find.text('سجل الحضور'), findsOneWidget);
      expect(find.text('البطاقة الذكية'), findsOneWidget);
    });

    testWidgets('Switches tabs between Home, Courses, History, and Smart ID Card', (tester) async {
      await tester.pumpWidget(_buildTestApp(StudentDashboardView(studentService: mockService)));
      await tester.pumpAndSettle();

      // النقر على تبويب المقررات
      await tester.tap(find.text('المقررات'));
      await tester.pumpAndSettle();
      expect(find.text('المقررات والشعب المسجلة'), findsOneWidget);

      // النقر على تبويب سجل الحضور
      await tester.tap(find.text('سجل الحضور'));
      await tester.pumpAndSettle();
      expect(find.text('سجل الحضور والغياب'), findsOneWidget);

      // النقر على تبويب البطاقة الذكية
      await tester.tap(find.text('البطاقة الذكية'));
      await tester.pumpAndSettle();
      expect(find.text('الملف الشخصي والبطاقة الجامعية'), findsOneWidget);
      expect(find.text('جامعة المستقبل الذكية'), findsOneWidget);
    });
  });
}
