import 'package:flutter_test/flutter_test.dart';
import 'package:thebes_academy/core/di/service_locator.dart';
import 'package:thebes_academy/features/student/domain/entities/academic_entities.dart';
import 'package:thebes_academy/features/student/presentation/controllers/student_controller.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    if (!sl.isRegistered<StudentController>()) {
      await initServiceLocator();
    }
  });

  group('Summer Course Domain & Registration Tests', () {
    test('SummerCourseEntity calculates total single course fee accurately', () {
      const courseWithLab = SummerCourseEntity(
        code: 'CS201',
        titleAr: 'هياكل البيانات والخوارزميات',
        titleEn: 'Data Structures & Algorithms',
        creditHours: 3,
        pricePerHour: 450.0,
        labFee: 350.0,
        category: SummerCourseCategory.retake,
        prerequisite: 'CS101',
        isPrerequisiteMet: true,
        instructorAr: 'د. وليد',
        instructorEn: 'Dr. Waleed',
        scheduleAr: 'الأحد 10 ص',
        scheduleEn: 'Sun 10 AM',
        hall: 'مدرج 2',
      );

      expect(courseWithLab.creditHours, equals(3));
      expect(courseWithLab.tuitionTotal, equals((3 * 450.0) + 350.0)); // 1350 + 350 = 1700
      expect(courseWithLab.getCategoryLabel(true), equals('مقرر تخلف ورسوب'));
    });

    test('SummerRegistrationSummary calculates multiple courses, lab fees, and admin fee', () {
      final courses = [
        const SummerCourseEntity(
          code: 'CS201',
          titleAr: 'هياكل البيانات',
          titleEn: 'Data Structures',
          creditHours: 3,
          pricePerHour: 450.0,
          labFee: 350.0,
          category: SummerCourseCategory.retake,
          prerequisite: 'CS101',
          isPrerequisiteMet: true,
          instructorAr: 'د. وليد',
          instructorEn: 'Dr. Waleed',
          scheduleAr: 'الأحد 10 ص',
          scheduleEn: 'Sun 10 AM',
          hall: 'مدرج 2',
        ),
        const SummerCourseEntity(
          code: 'MATH102',
          titleAr: 'تفاضل وتكامل 2',
          titleEn: 'Calculus II',
          creditHours: 3,
          pricePerHour: 450.0,
          labFee: 0.0,
          category: SummerCourseCategory.improvement,
          prerequisite: 'MATH101',
          isPrerequisiteMet: true,
          instructorAr: 'د. سارة',
          instructorEn: 'Dr. Sara',
          scheduleAr: 'الإثنين 12 م',
          scheduleEn: 'Mon 12 PM',
          hall: 'مدرج 4',
        ),
      ];

      final summary = SummerRegistrationSummary(selectedCourses: courses);

      expect(summary.totalCreditHours, equals(6));
      expect(summary.totalHoursTuition, equals(6 * 450.0)); // 2700
      expect(summary.totalLabFees, equals(350.0));
      expect(summary.administrativeFee, equals(250.0));
      expect(summary.grandTotalFees, equals(2700.0 + 350.0 + 250.0)); // 3300.0
      expect(summary.remainingHours, equals(3)); // 9 - 6 = 3
      expect(summary.canAddMore, isTrue);
    });

    test('StudentController toggles course selection and respects 9-hour limit', () {
      final controller = sl<StudentController>();

      // Ensure fresh state
      controller.clearSummerCourses();
      expect(controller.summerSummary.selectedCourses.length, equals(0));

      final c1 = controller.availableSummerCourses.firstWhere((c) => c.code == 'CS201');
      final c2 = controller.availableSummerCourses.firstWhere((c) => c.code == 'MATH102');
      final c3 = controller.availableSummerCourses.firstWhere((c) => c.code == 'CS305');
      final c4 = controller.availableSummerCourses.firstWhere((c) => c.code == 'MIS202');

      // Add course 1 (3 hrs)
      final res1 = controller.toggleSummerCourse(c1);
      expect(res1, isTrue);
      expect(controller.isCourseSelectedInSummer('CS201'), isTrue);
      expect(controller.summerSummary.totalCreditHours, equals(3));

      // Add course 2 (3 hrs)
      final res2 = controller.toggleSummerCourse(c2);
      expect(res2, isTrue);
      expect(controller.summerSummary.totalCreditHours, equals(6));

      // Add course 3 (3 hrs) -> reaches max 9 hrs
      final res3 = controller.toggleSummerCourse(c3);
      expect(res3, isTrue);
      expect(controller.summerSummary.totalCreditHours, equals(9));
      expect(controller.summerSummary.canAddMore, isFalse);

      // Attempting to add course 4 (exceeding 9 hrs) must be rejected
      final res4 = controller.toggleSummerCourse(c4);
      expect(res4, isFalse); // Rejected due to 9 hrs limit
      expect(controller.summerSummary.totalCreditHours, equals(9));

      // Removing a course drops hours back down
      final resRemove = controller.toggleSummerCourse(c1);
      expect(resRemove, isTrue);
      expect(controller.isCourseSelectedInSummer('CS201'), isFalse);
      expect(controller.summerSummary.totalCreditHours, equals(6));
    });

    test('StudentController processes summer payment and issues receipt', () {
      final controller = sl<StudentController>();
      controller.clearSummerCourses();

      final c1 = controller.availableSummerCourses.firstWhere((c) => c.code == 'CS201');
      controller.toggleSummerCourse(c1);

      expect(controller.summerSummary.isSubmitted, isFalse);
      expect(controller.summerSummary.isPaid, isFalse);

      controller.submitAndPaySummerRegistration(paymentMethod: 'Fawry');
      expect(controller.summerSummary.isSubmitted, isTrue);
      expect(controller.summerSummary.isPaid, isTrue);
      expect(controller.summerSummary.receiptNumber, startsWith('THB-SUMMER-'));
    });

    test('Academic Advisor governance controls registration window and approved courses', () {
      final controller = sl<StudentController>();

      // Initially closed or can be closed by advisor
      controller.setRegistrationWindowOpen(false);
      expect(controller.isRegistrationWindowOpen, isFalse);
      expect(controller.advisingSession.isRegistrationOpen, isFalse);
      expect(controller.advisingSession.advisorNameAr, isNotEmpty);
      expect(controller.advisingSession.officeLocationAr, isNotEmpty);

      // Advisor opens registration window
      controller.setRegistrationWindowOpen(true);
      expect(controller.isRegistrationWindowOpen, isTrue);
      expect(controller.advisingSession.isRegistrationOpen, isTrue);

      // Verify default approved courses
      expect(controller.isCourseApprovedByAdvisor('CS201'), isTrue);
      expect(controller.isCourseApprovedByAdvisor('MATH102'), isTrue);

      // Advisor toggles off an approved course
      controller.toggleAdvisorApprovedCourse('CS201');
      expect(controller.isCourseApprovedByAdvisor('CS201'), isFalse);
      expect(controller.advisorApprovedCourses.any((c) => c.code == 'CS201'), isFalse);

      // Advisor re-approves the course
      controller.toggleAdvisorApprovedCourse('CS201');
      expect(controller.isCourseApprovedByAdvisor('CS201'), isTrue);
      expect(controller.advisorApprovedCourses.any((c) => c.code == 'CS201'), isTrue);

      // Advisor updates guidance notes
      controller.updateAdvisorNotes(
        notesAr: 'يرجى مراجعة المرشد لاعتماد الساعات الإضافية.',
        notesEn: 'Please meet your advisor for extra hours approval.',
      );
      expect(controller.advisorNotesAr, equals('يرجى مراجعة المرشد لاعتماد الساعات الإضافية.'));
      expect(controller.advisingSession.advisorNotesAr, equals('يرجى مراجعة المرشد لاعتماد الساعات الإضافية.'));
    });
  });
}
