import '../models/attendance_analytics.dart';
import '../models/deprivation_student.dart';
import '../models/theory_course.dart';

/// بيانات تجريبية واقعية لأستاذ المحاضرات النظرية (Mock Theory Data)
class MockTheoryData {
  static const Map<String, dynamic> teacherProfile = {
    'id': 'usr-theo-001',
    'full_name': 'د. عبد الله محمد السقاف',
    'teacher_title': 'أستاذ مشارك / رئيس قسم علوم الحاسوب',
    'department_name': 'كلية الحاسوب وتكنولوجيا المعلومات',
    'email': 'alsaqqaf@university.edu.ye',
    'active_courses_count': 3,
    'total_students_enrolled': 245,
    'at_risk_deprivation_count': 8,
    'final_deprived_count': 2,
  };

  static final List<TheoryCourse> theoryCourses = [
    const TheoryCourse(
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
    ),
    const TheoryCourse(
      id: 'crs-net-302',
      courseCode: 'IT302',
      courseName: 'شبكات الحاسوب والبروتوكولات',
      departmentName: 'هندسة تقنية المعلومات',
      creditHours: 3,
      sections: ['01'],
      totalStudents: 75,
      totalLecturesDelivered: 14,
      averageAttendanceRate: 79.2,
      atRiskStudentsCount: 4,
      deprivedStudentsCount: 1,
    ),
    const TheoryCourse(
      id: 'crs-os-304',
      courseCode: 'CS304',
      courseName: 'نظم التشغيل والبرمجة المتزامنة',
      departmentName: 'علوم الحاسوب',
      creditHours: 3,
      sections: ['01'],
      totalStudents: 75,
      totalLecturesDelivered: 12,
      averageAttendanceRate: 91.0,
      atRiskStudentsCount: 1,
      deprivedStudentsCount: 0,
    ),
  ];

  static AttendanceAnalytics getAnalyticsForCourse(String courseId) {
    if (courseId == 'crs-net-302') {
      return const AttendanceAnalytics(
        courseId: 'crs-net-302',
        courseCode: 'IT302',
        courseName: 'شبكات الحاسوب والبروتوكولات',
        totalLectures: 14,
        totalEnrolledStudents: 75,
        presentCount: 680,
        absentCount: 140,
        lateCount: 50,
        excusedCount: 30,
        weeklyTrends: [
          WeeklyTrendItem(weekNumber: 1, weekLabel: 'أسبوع 1', attendanceRate: 94.0, absentRate: 6.0),
          WeeklyTrendItem(weekNumber: 2, weekLabel: 'أسبوع 2', attendanceRate: 90.0, absentRate: 10.0),
          WeeklyTrendItem(weekNumber: 3, weekLabel: 'أسبوع 3', attendanceRate: 85.0, absentRate: 15.0),
          WeeklyTrendItem(weekNumber: 4, weekLabel: 'أسبوع 4', attendanceRate: 82.0, absentRate: 18.0),
          WeeklyTrendItem(weekNumber: 5, weekLabel: 'أسبوع 5', attendanceRate: 78.0, absentRate: 22.0),
          WeeklyTrendItem(weekNumber: 6, weekLabel: 'أسبوع 6', attendanceRate: 76.0, absentRate: 24.0),
          WeeklyTrendItem(weekNumber: 7, weekLabel: 'أسبوع 7', attendanceRate: 79.2, absentRate: 20.8),
        ],
      );
    }

    return const AttendanceAnalytics(
      courseId: 'crs-swe-301',
      courseCode: 'CS301',
      courseName: 'هندسة البرمجيات المتقدمة',
      totalLectures: 14,
      totalEnrolledStudents: 95,
      presentCount: 1120,
      absentCount: 120,
      lateCount: 60,
      excusedCount: 30,
      weeklyTrends: [
        WeeklyTrendItem(weekNumber: 1, weekLabel: 'أسبوع 1', attendanceRate: 96.0, absentRate: 4.0),
        WeeklyTrendItem(weekNumber: 2, weekLabel: 'أسبوع 2', attendanceRate: 93.0, absentRate: 7.0),
        WeeklyTrendItem(weekNumber: 3, weekLabel: 'أسبوع 3', attendanceRate: 89.0, absentRate: 11.0),
        WeeklyTrendItem(weekNumber: 4, weekLabel: 'أسبوع 4', attendanceRate: 88.0, absentRate: 12.0),
        WeeklyTrendItem(weekNumber: 5, weekLabel: 'أسبوع 5', attendanceRate: 84.0, absentRate: 16.0),
        WeeklyTrendItem(weekNumber: 6, weekLabel: 'أسبوع 6', attendanceRate: 85.0, absentRate: 15.0),
        WeeklyTrendItem(weekNumber: 7, weekLabel: 'أسبوع 7', attendanceRate: 86.5, absentRate: 13.5),
      ],
    );
  }

  static List<DeprivationStudent> getDeprivationStudentsForCourse(String courseId) {
    return [
      const DeprivationStudent(
        studentId: 'std-201',
        studentNumber: 'STD-2023-5011',
        fullName: 'خالد وليد النعيمي',
        departmentName: 'علوم الحاسوب',
        sectionNumber: '01',
        totalLectures: 14,
        absentLecturesCount: 4,
        absencePercentage: 28.5,
        riskLevel: DeprivationRiskLevel.deprived,
        warningStatus: 'تم إصدار قرار الحرمان النهائي',
        hasPendingExcuse: false,
      ),
      const DeprivationStudent(
        studentId: 'std-202',
        studentNumber: 'STD-2023-5024',
        fullName: 'رائد منصور اليافعي',
        departmentName: 'علوم الحاسوب',
        sectionNumber: '01',
        totalLectures: 14,
        absentLecturesCount: 3,
        absencePercentage: 21.4,
        riskLevel: DeprivationRiskLevel.warningSecond,
        warningStatus: 'إنذار ثانٍ حرج (متبقي غياب واحد للحرمان)',
        hasPendingExcuse: true,
      ),
      const DeprivationStudent(
        studentId: 'std-203',
        studentNumber: 'STD-2023-5038',
        fullName: 'منى عبد العزيز الحداد',
        departmentName: 'هندسة تقنية المعلومات',
        sectionNumber: '02',
        totalLectures: 14,
        absentLecturesCount: 2,
        absencePercentage: 14.3,
        riskLevel: DeprivationRiskLevel.low,
        warningStatus: 'تنبيه غياب أولي',
        hasPendingExcuse: false,
      ),
      const DeprivationStudent(
        studentId: 'std-204',
        studentNumber: 'STD-2023-5049',
        fullName: 'سامي عبد الرب البركاني',
        departmentName: 'علوم الحاسوب',
        sectionNumber: '01',
        totalLectures: 14,
        absentLecturesCount: 3,
        absencePercentage: 21.4,
        riskLevel: DeprivationRiskLevel.warningSecond,
        warningStatus: 'إنذار ثانٍ حرج',
        hasPendingExcuse: false,
      ),
      const DeprivationStudent(
        studentId: 'std-205',
        studentNumber: 'STD-2023-5062',
        fullName: 'أسماء طارق الرازحي',
        departmentName: 'نظم المعلومات',
        sectionNumber: '02',
        totalLectures: 14,
        absentLecturesCount: 2,
        absencePercentage: 14.3,
        riskLevel: DeprivationRiskLevel.warningFirst,
        warningStatus: 'إنذار أول (تجاوز 15%)',
        hasPendingExcuse: false,
      ),
    ];
  }
}
