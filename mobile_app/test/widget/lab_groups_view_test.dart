import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/app/theme.dart';
import 'package:mobile_app/practical_teacher/services/practical_teacher_service.dart';
import 'package:mobile_app/practical_teacher/views/lab_groups_view.dart';
import 'package:mobile_app/practical_teacher/widgets/lab_group_card.dart';

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
  group('LabGroupsView Widget Tests', () {
    late PracticalTeacherService mockService;

    setUp(() {
      mockService = PracticalTeacherService(forceMockData: true);
    });

    testWidgets('Renders lab groups list and filter chips', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_buildTestApp(LabGroupsView(practicalService: mockService)));
      await tester.pumpAndSettle();

      // التحقق من ترويسة الصفحة
      expect(find.text('مجموعات المعامل والشعب'), findsOneWidget);

      // التحقق من وجود رقائق التصفية
      expect(find.textContaining('الكل ('), findsOneWidget);
      expect(find.textContaining('معامل البرمجيات ('), findsOneWidget);
      expect(find.textContaining('معامل الشبكات ('), findsOneWidget);

      // التحقق من بطاقات المجموعات
      expect(find.byType(LabGroupCard), findsWidgets);
    });

    testWidgets('Filters lab groups by search input', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_buildTestApp(LabGroupsView(practicalService: mockService)));
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, 'سيسكو');
      await tester.pumpAndSettle();

      expect(find.textContaining('سيسكو'), findsWidgets);
      expect(find.text('مجموعة B - معمل البرمجيات 1'), findsNothing);
    });
  });
}
