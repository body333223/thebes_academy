import 'package:flutter_test/flutter_test.dart';
import 'package:thebes_academy/core/storage/local_cache_service.dart';
import 'package:thebes_academy/features/student/domain/entities/academic_entities.dart';
import 'package:thebes_academy/core/di/service_locator.dart';
import 'package:thebes_academy/features/student/presentation/controllers/student_controller.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    if (!sl.isRegistered<StudentController>()) {
      await initServiceLocator();
    }
  });

  group('Thebes Academy New Features Unit Tests', () {
    test('LocalCacheService memory and JSON serialization works', () async {
      final cache = LocalCacheService();
      await cache.saveString('test_key', 'test_val');
      final val = await cache.getString('test_key');
      expect(val, equals('test_val'));

      final now = DateTime.now();
      await cache.updateLastSync(now);
      final lastSync = await cache.getLastSync();
      expect(lastSync, isNotNull);
    });

    test('CourseAttendanceStatEntity absence risk calculations', () {
      // 12 lectures total, 25% max allowed absence = 3 lectures
      const statSafe = CourseAttendanceStatEntity(
        courseCode: 'CS101',
        courseTitleAr: 'مقدمة في البرمجة',
        courseTitleEn: 'Intro to Programming',
        totalLectures: 12,
        attendedLectures: 11,
        absentLectures: 1,
        attendancePercentage: 91.6,
      );
      expect(statSafe.maxAllowedAbsence, equals(3));
      expect(statSafe.remainingAbsencesAllowed, equals(2));
      expect(statSafe.isAtRisk, isFalse);
      expect(statSafe.isDeprived, isFalse);

      // At Risk: 2 absences out of 3 allowed (1 remaining)
      const statRisk = CourseAttendanceStatEntity(
        courseCode: 'CS201',
        courseTitleAr: 'هياكل البيانات',
        courseTitleEn: 'Data Structures',
        totalLectures: 12,
        attendedLectures: 10,
        absentLectures: 2,
        attendancePercentage: 83.3,
      );
      expect(statRisk.remainingAbsencesAllowed, equals(1));
      expect(statRisk.isAtRisk, isTrue);
      expect(statRisk.isDeprived, isFalse);

      // Deprived: 3 or more absences
      const statDeprived = CourseAttendanceStatEntity(
        courseCode: 'CS301',
        courseTitleAr: 'نظم التشغيل',
        courseTitleEn: 'Operating Systems',
        totalLectures: 12,
        attendedLectures: 9,
        absentLectures: 3,
        attendancePercentage: 75.0,
      );
      expect(statDeprived.remainingAbsencesAllowed, equals(0));
      expect(statDeprived.isDeprived, isTrue);
    });

    test('StudentController GPA Simulator calculation', () async {
      final controller = sl<StudentController>();
      await controller.loadInitialData();

      // Student has completed 92 hours with 3.68 GPA
      // If student gets straight A+ (4.0) in 3 courses (9 hours)
      final simulatedHigh = controller.calculateSimulatedGpa({
        'CS301': 'A+',
        'IS302': 'A+',
        'IT303': 'A+',
      });
      expect(simulatedHigh, greaterThan(controller.student.gpa));

      // If student gets F (0.0) in courses
      final simulatedLow = controller.calculateSimulatedGpa({
        'CS301': 'F',
        'IS302': 'F',
        'IT303': 'F',
      });
      expect(simulatedLow, lessThan(controller.student.gpa));
    });

    test('Notifications system unread count and read marking', () async {
      final controller = sl<StudentController>();
      await controller.loadInitialData();

      expect(controller.notifications, isNotEmpty);
      final initialUnread = controller.unreadNotificationsCount;
      expect(initialUnread, greaterThan(0));

      final firstUnread = controller.notifications.firstWhere((n) => !n.isRead);
      controller.markNotificationAsRead(firstUnread.id);
      expect(controller.unreadNotificationsCount, equals(initialUnread - 1));

      controller.markAllNotificationsAsRead();
      expect(controller.unreadNotificationsCount, equals(0));
    });
  });
}
