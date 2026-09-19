enum UserRole { student, faculty }

class StudentEntity {
  final String id;
  final String academicId;
  final String nationalId;
  final String seatNumber;
  final String nameAr;
  final String nameEn;
  final String instituteAr;
  final String instituteEn;
  final String departmentAr;
  final String departmentEn;
  final int academicYear;
  final double gpa;
  final int completedHours;
  final int totalRequiredHours;
  final double attendanceRate;
  final String academicAdvisorAr;
  final String academicAdvisorEn;
  final String photoUrl;
  final String email;
  final String phone;

  const StudentEntity({
    required this.id,
    required this.academicId,
    required this.nationalId,
    required this.seatNumber,
    required this.nameAr,
    required this.nameEn,
    required this.instituteAr,
    required this.instituteEn,
    required this.departmentAr,
    required this.departmentEn,
    required this.academicYear,
    required this.gpa,
    required this.completedHours,
    required this.totalRequiredHours,
    required this.attendanceRate,
    required this.academicAdvisorAr,
    required this.academicAdvisorEn,
    required this.photoUrl,
    required this.email,
    required this.phone,
  });

  String getLocalizedName(bool isArabic) => isArabic ? nameAr : nameEn;
  String getLocalizedInstitute(bool isArabic) => isArabic ? instituteAr : instituteEn;
  String getLocalizedDepartment(bool isArabic) => isArabic ? departmentAr : departmentEn;
  String getLocalizedAdvisor(bool isArabic) => isArabic ? academicAdvisorAr : academicAdvisorEn;
}
