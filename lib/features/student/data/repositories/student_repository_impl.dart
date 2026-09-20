import '../../domain/entities/student_entity.dart';
import '../../domain/entities/academic_entities.dart';
import '../../domain/repositories/student_repository.dart';
import '../datasources/student_remote_datasource.dart';

class StudentRepositoryImpl implements StudentRepository {
  final StudentRemoteDataSource remoteDataSource;

  StudentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<StudentEntity> getStudentProfile() => remoteDataSource.getStudentProfile();

  @override
  Future<List<CourseScheduleEntity>> getWeeklySchedule() => remoteDataSource.getWeeklySchedule();

  @override
  Future<List<ExamEntity>> getExamSchedule() => remoteDataSource.getExamSchedule();

  @override
  Future<List<GradeEntity>> getStudentGrades() => remoteDataSource.getStudentGrades();

  @override
  Future<List<PaymentInstallmentEntity>> getInstallments() => remoteDataSource.getInstallments();

  @override
  Future<void> payInstallment(String installmentId) => remoteDataSource.payInstallment(installmentId);

  @override
  Future<List<ServiceRequestEntity>> getServiceRequests() => remoteDataSource.getServiceRequests();

  @override
  Future<ServiceRequestEntity> submitServiceRequest({
    required String titleAr,
    required String titleEn,
    required double fee,
  }) =>
      remoteDataSource.submitServiceRequest(
        titleAr: titleAr,
        titleEn: titleEn,
        fee: fee,
      );

  @override
  Future<List<AnnouncementEntity>> getAnnouncements() => remoteDataSource.getAnnouncements();

  @override
  Future<List<CourseAttendanceStatEntity>> getAttendanceStats() => remoteDataSource.getAttendanceStats();

  @override
  Future<List<AttendanceRecordEntity>> getAttendanceHistory() => remoteDataSource.getAttendanceHistory();

  @override
  Future<AttendanceRecordEntity> scanDoctorQr(String qrToken) => remoteDataSource.scanDoctorQr(qrToken);
}

