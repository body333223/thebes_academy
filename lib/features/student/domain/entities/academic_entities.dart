enum LectureType { lecture, section, lab }

class CourseScheduleEntity {
  final String id;
  final String code;
  final String titleAr;
  final String titleEn;
  final int creditHours;
  final String instructorAr;
  final String instructorEn;
  final String dayAr;
  final String dayEn;
  final int dayIndex;
  final String startTime;
  final String endTime;
  final String hallAr;
  final String hallEn;
  final LectureType type;
  final bool isUpcoming;

  const CourseScheduleEntity({
    required this.id,
    required this.code,
    required this.titleAr,
    required this.titleEn,
    required this.creditHours,
    required this.instructorAr,
    required this.instructorEn,
    required this.dayAr,
    required this.dayEn,
    required this.dayIndex,
    required this.startTime,
    required this.endTime,
    required this.hallAr,
    required this.hallEn,
    required this.type,
    this.isUpcoming = false,
  });

  String getLocalizedTitle(bool isArabic) => isArabic ? titleAr : titleEn;
  String getLocalizedInstructor(bool isArabic) => isArabic ? instructorAr : instructorEn;
  String getLocalizedDay(bool isArabic) => isArabic ? dayAr : dayEn;
  String getLocalizedHall(bool isArabic) => isArabic ? hallAr : hallEn;
}

class ExamEntity {
  final String courseCode;
  final String courseNameAr;
  final String courseNameEn;
  final String date;
  final String time;
  final String hall;
  final String seatNo;

  const ExamEntity({
    required this.courseCode,
    required this.courseNameAr,
    required this.courseNameEn,
    required this.date,
    required this.time,
    required this.hall,
    required this.seatNo,
  });

  String getLocalizedCourse(bool isArabic) => isArabic ? courseNameAr : courseNameEn;
}

class GradeEntity {
  final String courseCode;
  final String courseNameAr;
  final String courseNameEn;
  final int creditHours;
  final double courseworkScore;
  final double midtermScore;
  final double practicalScore;
  final double finalExamScore;
  final double totalScore;
  final String gradeLetter;
  final double points;
  final String semesterAr;
  final String semesterEn;

  const GradeEntity({
    required this.courseCode,
    required this.courseNameAr,
    required this.courseNameEn,
    required this.creditHours,
    required this.courseworkScore,
    required this.midtermScore,
    required this.practicalScore,
    required this.finalExamScore,
    required this.totalScore,
    required this.gradeLetter,
    required this.points,
    required this.semesterAr,
    required this.semesterEn,
  });

  String getLocalizedCourse(bool isArabic) => isArabic ? courseNameAr : courseNameEn;
  String getLocalizedSemester(bool isArabic) => isArabic ? semesterAr : semesterEn;
}

enum PaymentStatus { paid, pending, overdue }

class PaymentInstallmentEntity {
  final String id;
  final String titleAr;
  final String titleEn;
  final double amount;
  final String dueDate;
  final PaymentStatus status;
  final String? receiptNumber;
  final String? paidDate;

  const PaymentInstallmentEntity({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.amount,
    required this.dueDate,
    required this.status,
    this.receiptNumber,
    this.paidDate,
  });

  String getLocalizedTitle(bool isArabic) => isArabic ? titleAr : titleEn;
}

enum RequestStatus { completed, underReview, readyForPickup }

class ServiceRequestEntity {
  final String id;
  final String titleAr;
  final String titleEn;
  final String requestDate;
  final RequestStatus status;
  final String referenceNumber;
  final double fee;

  const ServiceRequestEntity({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.requestDate,
    required this.status,
    required this.referenceNumber,
    required this.fee,
  });

  String getLocalizedTitle(bool isArabic) => isArabic ? titleAr : titleEn;
}

class AnnouncementEntity {
  final String id;
  final String titleAr;
  final String titleEn;
  final String contentAr;
  final String contentEn;
  final String categoryAr;
  final String categoryEn;
  final String date;
  final bool isImportant;

  const AnnouncementEntity({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.contentAr,
    required this.contentEn,
    required this.categoryAr,
    required this.categoryEn,
    required this.date,
    this.isImportant = false,
  });

  String getLocalizedTitle(bool isArabic) => isArabic ? titleAr : titleEn;
  String getLocalizedContent(bool isArabic) => isArabic ? contentAr : contentEn;
  String getLocalizedCategory(bool isArabic) => isArabic ? categoryAr : categoryEn;
}
