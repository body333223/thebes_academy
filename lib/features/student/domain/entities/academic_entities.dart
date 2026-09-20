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

class AttendanceRecordEntity {
  final String id;
  final String courseCode;
  final String courseTitleAr;
  final String courseTitleEn;
  final String doctorNameAr;
  final String doctorNameEn;
  final DateTime timestamp;
  final String hall;
  final String sessionQrToken;
  final bool isVerified;

  const AttendanceRecordEntity({
    required this.id,
    required this.courseCode,
    required this.courseTitleAr,
    required this.courseTitleEn,
    required this.doctorNameAr,
    required this.doctorNameEn,
    required this.timestamp,
    required this.hall,
    required this.sessionQrToken,
    this.isVerified = true,
  });

  String getLocalizedCourseTitle(bool isArabic) => isArabic ? courseTitleAr : courseTitleEn;
  String getLocalizedDoctorName(bool isArabic) => isArabic ? doctorNameAr : doctorNameEn;
}

class CourseAttendanceStatEntity {
  final String courseCode;
  final String courseTitleAr;
  final String courseTitleEn;
  final int totalLectures;
  final int attendedLectures;
  final int absentLectures;
  final double attendancePercentage;
  final int warningsCount; // 0, 1, 2, or 3 (Deprivation)

  const CourseAttendanceStatEntity({
    required this.courseCode,
    required this.courseTitleAr,
    required this.courseTitleEn,
    required this.totalLectures,
    required this.attendedLectures,
    required this.absentLectures,
    required this.attendancePercentage,
    this.warningsCount = 0,
  });

  String getLocalizedTitle(bool isArabic) => isArabic ? courseTitleAr : courseTitleEn;

  int get maxAllowedAbsence => (totalLectures * 0.25).floor();
  int get remainingAbsencesAllowed {
    final rem = maxAllowedAbsence - absentLectures;
    return rem < 0 ? 0 : rem;
  }
  bool get isDeprived => absentLectures >= maxAllowedAbsence && maxAllowedAbsence > 0;
  bool get isAtRisk => !isDeprived && remainingAbsencesAllowed <= 1 && maxAllowedAbsence > 0;

  String getRiskBadgeText(bool isArabic) {
    if (isDeprived) {
      return isArabic ? 'محروم من الامتحان (تجاوز 25%)' : 'Deprived (Exceeded 25%)';
    }
    if (isAtRisk) {
      return isArabic ? 'إنذار أكاديمي: باقي غياب واحد' : 'Warning: 1 Absence Left';
    }
    return isArabic ? 'حالة الحضور آمنة' : 'Safe Standing';
  }
}

enum SummerCourseCategory { retake, improvement, advance }

class SummerCourseEntity {
  final String code;
  final String titleAr;
  final String titleEn;
  final int creditHours;
  final double pricePerHour;
  final double labFee;
  final String prerequisite;
  final bool isPrerequisiteMet;
  final SummerCourseCategory category;
  final String instructorAr;
  final String instructorEn;
  final String scheduleAr;
  final String scheduleEn;
  final String hall;

  const SummerCourseEntity({
    required this.code,
    required this.titleAr,
    required this.titleEn,
    required this.creditHours,
    this.pricePerHour = 450.0,
    this.labFee = 350.0,
    required this.prerequisite,
    this.isPrerequisiteMet = true,
    required this.category,
    required this.instructorAr,
    required this.instructorEn,
    required this.scheduleAr,
    required this.scheduleEn,
    required this.hall,
  });

  double get tuitionTotal => (creditHours * pricePerHour) + labFee;

  String getLocalizedTitle(bool isArabic) => isArabic ? titleAr : titleEn;
  String getLocalizedInstructor(bool isArabic) => isArabic ? instructorAr : instructorEn;
  String getLocalizedSchedule(bool isArabic) => isArabic ? scheduleAr : scheduleEn;

  String getCategoryLabel(bool isArabic) {
    switch (category) {
      case SummerCourseCategory.retake:
        return isArabic ? 'مقرر تخلف ورسوب' : 'Retake / Arrear';
      case SummerCourseCategory.improvement:
        return isArabic ? 'تحسين معدل (GPA)' : 'GPA Improvement';
      case SummerCourseCategory.advance:
        return isArabic ? 'تسجيل مسبق' : 'Fast-Track';
    }
  }
}

class SummerRegistrationSummary {
  final List<SummerCourseEntity> selectedCourses;
  final int maxCreditHoursAllowed;
  final double administrativeFee;
  final bool isSubmitted;
  final bool isPaid;
  final String? receiptNumber;
  final String? registrationDate;

  const SummerRegistrationSummary({
    required this.selectedCourses,
    this.maxCreditHoursAllowed = 9,
    this.administrativeFee = 250.0,
    this.isSubmitted = false,
    this.isPaid = false,
    this.receiptNumber,
    this.registrationDate,
  });

  int get totalCreditHours => selectedCourses.fold(0, (sum, c) => sum + c.creditHours);
  double get totalHoursTuition => selectedCourses.fold(0.0, (sum, c) => sum + (c.creditHours * c.pricePerHour));
  double get totalLabFees => selectedCourses.fold(0.0, (sum, c) => sum + c.labFee);
  double get grandTotalFees => selectedCourses.isEmpty ? 0.0 : totalHoursTuition + totalLabFees + administrativeFee;

  bool get canAddMore => totalCreditHours < maxCreditHoursAllowed;
  int get remainingHours => maxCreditHoursAllowed - totalCreditHours;
}
