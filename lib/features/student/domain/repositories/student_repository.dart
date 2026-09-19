import '../entities/student_entity.dart';
import '../entities/academic_entities.dart';

abstract class StudentRepository {
  Future<StudentEntity> getStudentProfile();
  Future<List<CourseScheduleEntity>> getWeeklySchedule();
  Future<List<ExamEntity>> getExamSchedule();
  Future<List<GradeEntity>> getStudentGrades();
  Future<List<PaymentInstallmentEntity>> getInstallments();
  Future<void> payInstallment(String installmentId);
  Future<List<ServiceRequestEntity>> getServiceRequests();
  Future<ServiceRequestEntity> submitServiceRequest({
    required String titleAr,
    required String titleEn,
    required double fee,
  });
  Future<List<AnnouncementEntity>> getAnnouncements();
}
