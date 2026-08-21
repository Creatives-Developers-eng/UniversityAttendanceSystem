import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/app/theme.dart';
import 'package:mobile_app/student/services/student_service.dart';
import 'package:mobile_app/student/views/courses_view.dart';
import 'package:mobile_app/student/widgets/course_card.dart';

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
  group('CoursesView Widget Tests', () {
    late StudentService mockService;

    setUp(() {
      mockService = StudentService(forceMockData: true);
    });

    testWidgets('Renders all courses and supports searching', (tester) async {
      await tester.pumpWidget(_buildTestApp(CoursesView(studentService: mockService)));
      await tester.pumpAndSettle();

      expect(find.text('المقررات والشعب المسجلة'), findsOneWidget);
      expect(find.byType(CourseCard), findsWidgets);
      expect(find.text('هندسة البرمجيات المتقدمة'), findsOneWidget);

      // البحث في حقل البحث
      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, 'CS301');
      await tester.pumpAndSettle();

      expect(find.text('هندسة البرمجيات المتقدمة'), findsOneWidget);
      expect(find.text('تطوير تطبيقات الهواتف الذكية'), findsNothing);
    });

    testWidgets('Filters by section type (Practical vs Theoretical)', (tester) async {
      await tester.pumpWidget(_buildTestApp(CoursesView(studentService: mockService)));
      await tester.pumpAndSettle();

      // تصفية حسب الشعب العملية
      final practicalChip = find.textContaining('شعب عملية');
      expect(practicalChip, findsOneWidget);
      await tester.tap(practicalChip);
      await tester.pumpAndSettle();

      expect(find.text('هندسة البرمجيات المتقدمة'), findsOneWidget);
      expect(find.text('نظم إدارة قواعد البيانات'), findsNothing);
    });
  });
}
