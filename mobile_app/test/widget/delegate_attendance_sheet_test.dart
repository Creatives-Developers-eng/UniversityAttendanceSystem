import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/app/theme.dart';
import 'package:mobile_app/delegate/services/delegate_service.dart';
import 'package:mobile_app/delegate/views/delegate_attendance_sheet.dart';

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
  group('DelegateAttendanceSheet Widget Tests', () {
    late DelegateService mockService;

    setUp(() {
      mockService = DelegateService(forceMockData: true);
    });

    testWidgets('Renders attendance sheet students list and state chips', (tester) async {
      await tester.pumpWidget(_buildTestApp(DelegateAttendanceSheet(\n        sectionId: 'sec-001-p',\n        courseCode: 'CS301',\n        courseName: 'هندسة البرمجيات المتقدمة',\n        sectionNumber: '01',\n        delegateService: mockService,\n      )));\n      await tester.pumpAndSettle();\n\n      // التحقق من ترويسة الصفحة\n      expect(find.textContaining('كشف حضور: هندسة البرمجيات المتقدمة'), findsOneWidget);\n      expect(find.textContaining('CS301 - شعبة 01'), findsOneWidget);\n\n      // التحقق من أزرار التصفية\n      expect(find.textContaining('الكل ('), findsOneWidget);\n      expect(find.textContaining('حاضر ('), findsOneWidget);\n      expect(find.textContaining('غائب ('), findsOneWidget);\n      expect(find.textContaining('معذور ('), findsOneWidget);\n\n      // التحقق من قائمة الطلاب\n      expect(find.text('أحمد علي عبد الله'), findsOneWidget);\n      expect(find.text('STD-2023-4019 | هندسة تقنية المعلومات'), findsOneWidget);\n    });\n\n    testWidgets('Filters students by search query and state chips', (tester) async {\n      await tester.pumpWidget(_buildTestApp(DelegateAttendanceSheet(\n        sectionId: 'sec-001-p',\n        courseCode: 'CS301',\n        courseName: 'هندسة البرمجيات المتقدمة',\n        sectionNumber: '01',\n        delegateService: mockService,\n      )));\n      await tester.pumpAndSettle();\n\n      // البحث عن طالب محدد\n      final searchField = find.byType(TextField);\n      expect(searchField, findsOneWidget);\n\n      await tester.enterText(searchField, 'سارة');\n      await tester.pumpAndSettle();\n\n      expect(find.text('سارة محمد القحطاني'), findsOneWidget);\n      expect(find.text('أحمد علي عبد الله'), findsNothing);\n\n      // مسح البحث\n      final clearBtn = find.byIcon(Icons.clear_rounded);\n      expect(clearBtn, findsOneWidget);\n      await tester.tap(clearBtn);\n      await tester.pumpAndSettle();\n\n      expect(find.text('أحمد علي عبد الله'), findsOneWidget);\n\n      // تصفية حسب معذور\n      final excusedChip = find.textContaining('معذور (');\n      expect(excusedChip, findsOneWidget);\n\n      await tester.tap(excusedChip);\n      await tester.pumpAndSettle();\n\n      expect(find.text('حسام ناصر الشمري'), findsOneWidget);\n      expect(find.textContaining('عذر طبي معتمد من الكلية'), findsOneWidget);\n    });\n\n    testWidgets('Opens manual attendance dialog from FloatingActionButton', (tester) async {\n      await tester.pumpWidget(_buildTestApp(DelegateAttendanceSheet(\n        sectionId: 'sec-001-p',\n        courseCode: 'CS301',\n        courseName: 'هندسة البرمجيات المتقدمة',\n        sectionNumber: '01',\n        delegateService: mockService,\n      )));\n      await tester.pumpAndSettle();\n\n      final fab = find.byType(FloatingActionButton);\n      expect(fab, findsOneWidget);\n\n      await tester.tap(fab);\n      await tester.pumpAndSettle();\n\n      expect(find.text('تسجيل تحضير يدوي'), findsOneWidget);\n      expect(find.text('حالة الحضور المراد تسجيلها'), findsOneWidget);\n      expect(find.text('مبرر التحضير اليدوي *'), findsOneWidget);\n    });\n  });\n}\n