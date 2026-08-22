import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:mobile_app/core/offline/cache_policy.dart';
import 'package:mobile_app/core/offline/connectivity_service.dart';
import 'package:mobile_app/core/offline/offline_cache_manager.dart';
import 'package:mobile_app/student/models/student_profile.dart';
import 'package:mobile_app/student/models/student_course.dart';
import 'package:mobile_app/student/models/student_attendance_record.dart';
import 'package:mobile_app/student/models/attendance_stats.dart';
import 'package:mobile_app/delegate/models/delegate_section.dart';
import 'package:mobile_app/delegate/models/delegate_session.dart';
import 'package:mobile_app/practical_teacher/models/lab_group.dart';
import 'package:mobile_app/practical_teacher/models/lab_session.dart';
import 'package:mobile_app/theoretical_teacher/models/theory_course.dart';

class FakeConnectivityForCache implements Connectivity {
  bool isOnline;
  final StreamController<ConnectivityResult> _ctrl = StreamController<ConnectivityResult>.broadcast();

  FakeConnectivityForCache({this.isOnline = true});

  @override
  Future<ConnectivityResult> checkConnectivity() async {
    return isOnline ? ConnectivityResult.wifi : ConnectivityResult.none;
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged => _ctrl.stream;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OfflineCacheManager Unit Tests', () {
    late OfflineCacheManager cacheManager;
    late SharedPreferences prefs;
    late FakeConnectivityForCache fakeConnectivity;
    late ConnectivityService connectivityService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      fakeConnectivity = FakeConnectivityForCache(isOnline: true);
      connectivityService = ConnectivityService(connectivity: fakeConnectivity);
      cacheManager = OfflineCacheManager(
        prefs: prefs,
        connectivityService: connectivityService,
      );
    });

    test('putJson and getJson persist and retrieve data properly', () async {
      await cacheManager.putJson('cache_test_key', {'name': 'جامعة صنعاء', 'id': 100});

      final retrieved = await cacheManager.getJson('cache_test_key');
      expect(retrieved, isNotNull);
      expect(retrieved['name'], equals('جامعة صنعاء'));
      expect(retrieved['id'], equals(100));

      final exists = await cacheManager.containsKey('cache_test_key');
      expect(exists, isTrue);
    });

    test('invalidate removes specific key', () async {
      await cacheManager.putJson('cache_item_1', 'val1');
      await cacheManager.putJson('cache_item_2', 'val2');

      final removed = await cacheManager.invalidate('cache_item_1');
      expect(removed, isTrue);
      expect(await cacheManager.getJson('cache_item_1'), isNull);
      expect(await cacheManager.getJson('cache_item_2'), equals('val2'));
    });

    test('clearAll clears only cache_ prefixed keys', () async {
      await prefs.setString('pref_user_theme', 'dark');
      await cacheManager.putJson('cache_data_1', 'abc');
      await cacheManager.putJson('cache_data_2', 'xyz');

      await cacheManager.clearAll();

      expect(await cacheManager.getJson('cache_data_1'), isNull);
      expect(await cacheManager.getJson('cache_data_2'), isNull);
      expect(prefs.getString('pref_user_theme'), equals('dark'));
    });

    test('getLastUpdated and isExpired return correct metadata', () async {
      await cacheManager.putJson('cache_time_test', 'test_val', ttl: const Duration(seconds: 1));

      final lastUpdated = await cacheManager.getLastUpdated('cache_time_test');
      expect(lastUpdated, isNotNull);
      expect(lastUpdated!.isBefore(DateTime.now().add(const Duration(seconds: 1))), isTrue);

      expect(await cacheManager.isExpired('cache_time_test'), isFalse);

      // Wait for expiration
      await Future.delayed(const Duration(milliseconds: 1100));
      expect(await cacheManager.isExpired('cache_time_test'), isTrue);
      expect(await cacheManager.getJson('cache_time_test'), isNull);
      expect(await cacheManager.getJson('cache_time_test', ignoreExpiration: true), equals('test_val'));
    });

    // --- Student Domain Entity Tests ---
    test('saveStudentProfile and getStudentProfile work as expected', () async {
      const profile = StudentProfile(
        id: 'std-101',
        studentNumber: '441010',
        fullName: 'أواب النزيلي',
        email: 'awab@university.edu',
        departmentName: 'تقنية المعلومات',
        academicYearName: '2025-2026',
        phoneNumber: '777000111',
      );

      await cacheManager.saveStudentProfile(profile, studentId: 'std-101');
      final loaded = await cacheManager.getStudentProfile(studentId: 'std-101');

      expect(loaded, isNotNull);
      expect(loaded!.id, equals('std-101'));
      expect(loaded.studentNumber, equals('441010'));
      expect(loaded.fullName, equals('أواب النزيلي'));
      expect(loaded.email, equals('awab@university.edu'));
      expect(loaded.phoneNumber, equals('777000111'));
    });

    test('saveStudentCourses and getStudentCourses work as expected', () async {
      const courses = [
        StudentCourse(
          id: 'c-1',
          courseCode: 'IT301',
          title: 'برمجة الهواتف الذكية',
          departmentName: 'تقنية المعلومات',
          creditHours: 3,
          sectionId: 'sec-1',
          sectionNumber: '01',
          sectionType: 'PRACTICAL',
          teacherName: 'د. يحيى',
          totalSessions: 14,
          attendedSessions: 12,
        ),
        StudentCourse(
          id: 'c-2',
          courseCode: 'IT302',
          title: 'هندسة الشبكات المتقدمة',
          departmentName: 'تقنية المعلومات',
          creditHours: 3,
          sectionId: 'sec-2',
          sectionNumber: '02',
          sectionType: 'THEORETICAL',
          teacherName: 'د. خالد',
          totalSessions: 14,
          attendedSessions: 14,
        ),
      ];

      await cacheManager.saveStudentCourses(courses, studentId: 'std-101');
      final loaded = await cacheManager.getStudentCourses(studentId: 'std-101');

      expect(loaded, isNotNull);
      expect(loaded!.length, equals(2));
      expect(loaded.first.courseCode, equals('IT301'));
      expect(loaded.last.title, equals('هندسة الشبكات المتقدمة'));
      expect(loaded.first.isPractical, isTrue);
    });

    test('saveAttendanceHistory and saveAttendanceStats work as expected', () async {
      final records = [
        StudentAttendanceRecord(
          id: 'rec-1',
          sessionId: 'ses-1',
          courseCode: 'IT301',
          courseTitle: 'برمجة الهواتف الذكية',
          sectionNumber: '01',
          sessionDate: DateTime(2026, 8, 20, 10, 0),
          attendanceState: 'PRESENT',
          attendanceMethod: 'QR',
          markedAt: DateTime(2026, 8, 20, 10, 5),
        ),
      ];

      const stats = AttendanceStats(
        totalSessions: 20,
        totalPresent: 18,
        totalAbsent: 1,
        totalLate: 1,
        totalExcused: 0,
      );

      await cacheManager.saveAttendanceHistory(records, studentId: 'std-101');
      await cacheManager.saveAttendanceStats(stats, studentId: 'std-101');

      final loadedRecords = await cacheManager.getAttendanceHistory(studentId: 'std-101');
      final loadedStats = await cacheManager.getAttendanceStats(studentId: 'std-101');

      expect(loadedRecords, isNotNull);
      expect(loadedRecords!.length, equals(1));
      expect(loadedRecords.first.attendanceMethod, equals('QR'));

      expect(loadedStats, isNotNull);
      expect(loadedStats!.attendancePercentage, isNotNull);
      expect(loadedStats.totalPresent, equals(18));
    });

    // --- Delegate Domain Entity Tests ---
    test('saveDelegatedSections and saveRecentSessions work as expected', () async {
      const sections = [
        DelegateSection(
          id: 'sec-del-1',
          courseId: 'c-10',
          courseCode: 'CS401',
          courseName: 'أمن المعلومات والسيبراني',
          sectionNumber: '01',
          sectionType: DelegateSectionType.practical,
          teacherId: 't-1',
          teacherName: 'د. علي',
          totalStudents: 35,
        ),
      ];

      final sessions = [
        DelegateSession(
          id: 'ses-1',
          sectionId: 'sec-del-1',
          courseCode: 'CS401',
          courseName: 'أمن المعلومات والسيبراني',
          sectionNumber: '01',
          sectionType: DelegateSectionType.practical,
          teacherName: 'د. علي',
          delegateId: 'del-1',
          delegateName: 'أحمد المندوب',
          sessionState: DelegateSessionState.synced,
          openedAt: DateTime.now().subtract(const Duration(hours: 2)),
          closedAt: DateTime.now().subtract(const Duration(hours: 1)),
          totalExpectedStudents: 35,
          attendedCount: 33,
        ),
      ];

      await cacheManager.saveDelegatedSections(sections);
      await cacheManager.saveRecentSessions(sessions);

      final loadedSections = await cacheManager.getDelegatedSections();
      final loadedSessions = await cacheManager.getRecentSessions();

      expect(loadedSections, isNotNull);
      expect(loadedSections!.length, equals(1));
      expect(loadedSections.first.courseCode, equals('CS401'));

      expect(loadedSessions, isNotNull);
      expect(loadedSessions!.length, equals(1));
      expect(loadedSessions.first.attendedCount, equals(33));
    });

    // --- Teacher Domain Entity Tests ---
    test('saveLabGroups, saveLabSessions, and saveTheoryCourses work as expected', () async {
      const groups = [
        LabGroup(
          id: 'grp-1',
          courseId: 'c-1',
          courseCode: 'IT301',
          courseName: 'معمل برمجة الهواتف',
          sectionNumber: '01',
          groupName: 'المجموعة A',
          roomName: 'معمل الحاسوب 3',
          totalStudents: 25,
          scheduleTime: '08:00 - 10:00',
        ),
      ];

      final sessions = [
        LabSession(
          id: 'lab-ses-1',
          groupId: 'grp-1',
          groupName: 'المجموعة A',
          courseCode: 'IT301',
          courseName: 'معمل برمجة الهواتف',
          sectionNumber: '01',
          sessionDate: DateTime(2026, 8, 20, 8, 0),
          roomName: 'معمل الحاسوب 3',
          totalStudents: 25,
          attendedCount: 22,
        ),
      ];

      const theoryCourses = [
        TheoryCourse(
          id: 'tc-1',
          courseCode: 'IT302',
          courseName: 'نظم التشغيل المتقدمة',
          departmentName: 'تقنية المعلومات',
          sections: ['01', '02'],
          totalStudents: 60,
          averageAttendanceRate: 88.0,
          atRiskStudentsCount: 4,
          deprivedStudentsCount: 1,
        ),
      ];

      await cacheManager.saveLabGroups(groups);
      await cacheManager.saveLabSessions(sessions, groupId: 'grp-1');
      await cacheManager.saveTheoryCourses(theoryCourses);

      final loadedGroups = await cacheManager.getLabGroups();
      final loadedSessions = await cacheManager.getLabSessions(groupId: 'grp-1');
      final loadedTheory = await cacheManager.getTheoryCourses();

      expect(loadedGroups, isNotNull);
      expect(loadedGroups!.first.groupName, equals('المجموعة A'));

      expect(loadedSessions, isNotNull);
      expect(loadedSessions!.first.attendedCount, equals(22));

      expect(loadedTheory, isNotNull);
      expect(loadedTheory!.first.courseCode, equals('IT302'));
    });

    // --- Smart Execution Policy Tests ---
    test('executeWithPolicy networkFirst fetches online and updates cache', () async {
      fakeConnectivity.isOnline = true;
      String? savedCache;

      final result = await cacheManager.executeWithPolicy<String>(
        cacheKey: 'test_policy_key',
        networkFetch: () async => 'remote_data_online',
        saveToCache: (data) async => savedCache = data,
        getFromCache: () async => savedCache,
        policy: CachePolicy.networkFirst,
      );

      expect(result, equals('remote_data_online'));
      expect(savedCache, equals('remote_data_online'));
    });

    test('executeWithPolicy networkFirst falls back to cache when offline', () async {
      fakeConnectivity.isOnline = false;
      const cachedData = 'local_saved_data';

      final result = await cacheManager.executeWithPolicy<String>(
        cacheKey: 'test_policy_key_offline',
        networkFetch: () async => throw Exception('Network Unreachable'),
        saveToCache: (_) async {},
        getFromCache: () async => cachedData,
        policy: CachePolicy.networkFirst,
      );

      expect(result, equals('local_saved_data'));
    });

    test('executeWithPolicy cacheFirst returns cached data without calling networkFetch', () async {
      bool networkCalled = false;

      final result = await cacheManager.executeWithPolicy<String>(
        cacheKey: 'test_cache_first',
        networkFetch: () async {
          networkCalled = true;
          return 'network_data';
        },
        saveToCache: (_) async {},
        getFromCache: () async => 'cached_data_fast',
        policy: CachePolicy.cacheFirst,
      );

      expect(result, equals('cached_data_fast'));
      expect(networkCalled, isFalse);
    });

    test('executeWithPolicy cacheOnly strictly reads local cache', () async {
      final result = await cacheManager.executeWithPolicy<String>(
        cacheKey: 'test_cache_only',
        networkFetch: () async => throw Exception('Must not be called'),
        saveToCache: (_) async {},
        getFromCache: () async => 'local_only_data',
        policy: CachePolicy.cacheOnly,
      );

      expect(result, equals('local_only_data'));
    });
  });
}
