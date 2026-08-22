import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/app/theme.dart';
import 'package:mobile_app/theoretical_teacher/models/theory_course.dart';
import 'package:mobile_app/theoretical_teacher/services/theoretical_teacher_service.dart';
import 'package:mobile_app/theoretical_teacher/views/theory_reports_view.dart';
import 'package:mobile_app/theoretical_teacher/widgets/attendance_bar_chart.dart';
import 'package:mobile_app/theoretical_teacher/widgets/attendance_pie_chart.dart';
import 'package:mobile_app/theoretical_teacher/widgets/deprivation_risk_card.dart';

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
  group('TheoryReportsView Widget Tests', () {
    late TheoreticalTeacherService mockService;
    late TheoryCourse mockCourse;

    setUp(() {
      mockService = TheoreticalTeacherService(forceMockData: true);
      mockCourse = const TheoryCourse(
        id: 'crs-swe-301',
        courseCode: 'CS301',
        courseName: 'هندسة البرمجيات المتقدمة',
        departmentName: 'علوم الحاسوب',
        creditHours: 3,
        sections: ['01', '02'],
        totalStudents: 95,
        totalLecturesDelivered: 14,
        averageAttendanceRate: 86.5,
        atRiskStudentsCount: 3,
        deprivedStudentsCount: 1,
      );
    });

    testWidgets('Renders tabs, metrics, and analytics charts in tab 1', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_buildTestApp(
        TheoryReportsView(
          course: mockCourse,
          theoreticalService: mockService,
        ),
      ));
      await tester.pumpAndSettle();

      // التحقق من عنوان الصفحة والتبويبات
      expect(find.text('تقارير CS301'), findsOneWidget);
      expect(find.text('التحليلات والمخططات'), findsOneWidget);
      expect(find.text('كشف الحرمان والإنذارات'), findsOneWidget);

      // التحقق من المخططات
      expect(find.byType(AttendancePieChart), findsOneWidget);
      expect(find.byType(AttendanceBarChart), findsOneWidget);
    });

    testWidgets('Switches to Tab 2 and interacts with deprivation list & search', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_buildTestApp(
        TheoryReportsView(
          course: mockCourse,
          theoreticalService: mockService,
        ),
      ));
      await tester.pumpAndSettle();

      // الانتقال للتبويب الثاني
      final tab2 = find.text('كشف الحرمان والإنذارات');
      await tester.tap(tab2);
      await tester.pumpAndSettle();

      // التحقق من بطاقات الطلاب المعرضين للحرمان
      expect(find.byType(DeprivationRiskCard), findsWidgets);
      expect(find.text('خالد وليد النعيمي'), findsOneWidget);

      // فحص حقل البحث
      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, 'خالد');
      await tester.pumpAndSettle();

      expect(find.text('خالد وليد النعيمي'), findsOneWidget);
      expect(find.text('رائد منصور اليافعي'), findsNothing);
    });

    testWidgets('Opens export report bottom sheet', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_buildTestApp(
        TheoryReportsView(
          course: mockCourse,
          theoreticalService: mockService,
        ),
      ));
      await tester.pumpAndSettle();

      final exportIcon = find.byIcon(Icons.file_download_outlined);
      expect(exportIcon, findsOneWidget);

      await tester.tap(exportIcon);
      await tester.pumpAndSettle();

      expect(find.text('تصدير تقرير الحضور والغياب'), findsOneWidget);
      expect(find.textContaining('PDF'), findsOneWidget);
      expect(find.textContaining('Excel'), findsOneWidget);
    });
  });
}
