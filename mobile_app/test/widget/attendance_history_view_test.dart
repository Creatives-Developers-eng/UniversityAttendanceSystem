import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/app/theme.dart';
import 'package:mobile_app/student/services/student_service.dart';
import 'package:mobile_app/student/views/attendance_history_view.dart';
import 'package:mobile_app/student/widgets/attendance_history_card.dart';

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
  group('AttendanceHistoryView Widget Tests', () {
    late StudentService mockService;

    setUp(() {
      mockService = StudentService(forceMockData: true);
    });

    testWidgets('Renders attendance history records and state chips', (tester) async {
      await tester.pumpWidget(_buildTestApp(AttendanceHistoryView(studentService: mockService)));
      await tester.pumpAndSettle();

      expect(find.text('سجل الحضور والغياب'), findsOneWidget);
      expect(find.byType(AttendanceHistoryCard), findsWidgets);
      expect(find.textContaining('الكل ('), findsOneWidget);
      expect(find.textContaining('حاضر ('), findsOneWidget);
      expect(find.textContaining('غائب ('), findsOneWidget);
    });

    testWidgets('Filters records when tapping state chips', (tester) async {
      await tester.pumpWidget(_buildTestApp(AttendanceHistoryView(studentService: mockService)));
      await tester.pumpAndSettle();

      // تصفية حسب غائب
      final absentChip = find.textContaining('غائب (');
      expect(absentChip, findsOneWidget);
      await tester.tap(absentChip);
      await tester.pumpAndSettle();

      expect(find.text('نظم إدارة قواعد البيانات'), findsOneWidget);
    });
  });
}
