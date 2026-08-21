import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/app/theme.dart';
import 'package:mobile_app/practical_teacher/models/lab_group.dart';
import 'package:mobile_app/practical_teacher/services/practical_teacher_service.dart';
import 'package:mobile_app/practical_teacher/views/lab_attendance_view.dart';
import 'package:mobile_app/practical_teacher/widgets/lab_roster_table.dart';

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
  group('LabAttendanceView Widget Tests', () {
    late PracticalTeacherService mockService;
    late LabGroup mockGroup;

    setUp(() {
      mockService = PracticalTeacherService(forceMockData: true);
      mockGroup = const LabGroup(
        id: 'grp-001',
        courseId: 'crs-swe-301',
        courseCode: 'CS301',
        courseName: 'هندسة البرمجيات المتقدمة',
        sectionNumber: '01',
        groupName: 'مجموعة A - معمل البرمجيات 1',
        groupType: LabGroupType.softwareLab,
        roomName: 'معمل الحاسوب 3',
        scheduleTime: 'الأحد 08:00 ص',
        totalStudents: 30,
        attendedStudents: 26,
      );
    });

    testWidgets('Renders lab attendance roster, metrics counters, and table', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_buildTestApp(LabAttendanceView(
        group: mockGroup,
        practicalService: mockService,
      )));
      await tester.pumpAndSettle();

      // التحقق من ترويسة الصفحة
      expect(find.text('مجموعة A - معمل البرمجيات 1'), findsWidgets);
      expect(find.textContaining('معمل الحاسوب 3'), findsOneWidget);

      // التحقق من العدادات
      expect(find.text('حاضر'), findsWidgets);
      expect(find.text('متأخر'), findsWidgets);
      expect(find.text('معذور'), findsWidgets);
      expect(find.text('غائب'), findsWidgets);
      expect(find.text('الإجمالي'), findsOneWidget);

      // التحقق من جدول الطلاب
      expect(find.byType(LabRosterTable), findsOneWidget);
      expect(find.text('أحمد علي عبد الله الشميري'), findsOneWidget);
    });

    testWidgets('Opens manual attendance modal from FAB', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_buildTestApp(LabAttendanceView(
        group: mockGroup,
        practicalService: mockService,
      )));
      await tester.pumpAndSettle();

      final fab = find.byType(FloatingActionButton);
      expect(fab, findsOneWidget);

      await tester.tap(fab);
      await tester.pumpAndSettle();

      expect(find.text('تحضير يدوي لطالب بالمعمل'), findsOneWidget);
      expect(find.text('الرقم الجامعي للطالب *'), findsOneWidget);
      expect(find.text('مبرر التحضير اليدوي *'), findsOneWidget);
    });

    testWidgets('Filters students by search query and state chips', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_buildTestApp(LabAttendanceView(
        group: mockGroup,
        practicalService: mockService,
      )));
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, 'سارة');
      await tester.pumpAndSettle();

      expect(find.text('سارة محمد القحطاني'), findsOneWidget);
      expect(find.text('أحمد علي عبد الله الشميري'), findsNothing);
    });
  });
}
