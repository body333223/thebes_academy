import '../../domain/entities/student_entity.dart';

class StudentModel extends StudentEntity {
  const StudentModel({
    required super.id,
    required super.academicId,
    required super.nationalId,
    required super.seatNumber,
    required super.nameAr,
    required super.nameEn,
    required super.instituteAr,
    required super.instituteEn,
    required super.departmentAr,
    required super.departmentEn,
    required super.academicYear,
    required super.gpa,
    required super.completedHours,
    required super.totalRequiredHours,
    required super.attendanceRate,
    required super.academicAdvisorAr,
    required super.academicAdvisorEn,
    required super.photoUrl,
    required super.email,
    required super.phone,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as String,
      academicId: json['academicId'] as String,
      nationalId: json['nationalId'] as String,
      seatNumber: json['seatNumber'] as String,
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
      instituteAr: json['instituteAr'] as String,
      instituteEn: json['instituteEn'] as String,
      departmentAr: json['departmentAr'] as String,
      departmentEn: json['departmentEn'] as String,
      academicYear: json['academicYear'] as int,
      gpa: (json['gpa'] as num).toDouble(),
      completedHours: json['completedHours'] as int,
      totalRequiredHours: json['totalRequiredHours'] as int,
      attendanceRate: (json['attendanceRate'] as num).toDouble(),
      academicAdvisorAr: json['academicAdvisorAr'] as String,
      academicAdvisorEn: json['academicAdvisorEn'] as String,
      photoUrl: json['photoUrl'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'academicId': academicId,
      'nationalId': nationalId,
      'seatNumber': seatNumber,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'instituteAr': instituteAr,
      'instituteEn': instituteEn,
      'departmentAr': departmentAr,
      'departmentEn': departmentEn,
      'academicYear': academicYear,
      'gpa': gpa,
      'completedHours': completedHours,
      'totalRequiredHours': totalRequiredHours,
      'attendanceRate': attendanceRate,
      'academicAdvisorAr': academicAdvisorAr,
      'academicAdvisorEn': academicAdvisorEn,
      'photoUrl': photoUrl,
      'email': email,
      'phone': phone,
    };
  }
}
