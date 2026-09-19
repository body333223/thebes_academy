import '../../../../core/usecase/usecase.dart';
import '../entities/student_entity.dart';
import '../entities/academic_entities.dart';
import '../repositories/student_repository.dart';

class GetStudentProfileUseCase implements UseCase<StudentEntity, NoParams> {
  final StudentRepository repository;
  GetStudentProfileUseCase(this.repository);

  @override
  Future<StudentEntity> call(NoParams params) {
    return repository.getStudentProfile();
  }
}

class GetWeeklyScheduleUseCase implements UseCase<List<CourseScheduleEntity>, NoParams> {
  final StudentRepository repository;
  GetWeeklyScheduleUseCase(this.repository);

  @override
  Future<List<CourseScheduleEntity>> call(NoParams params) {
    return repository.getWeeklySchedule();
  }
}

class GetExamScheduleUseCase implements UseCase<List<ExamEntity>, NoParams> {
  final StudentRepository repository;
  GetExamScheduleUseCase(this.repository);

  @override
  Future<List<ExamEntity>> call(NoParams params) {
    return repository.getExamSchedule();
  }
}

class GetStudentGradesUseCase implements UseCase<List<GradeEntity>, NoParams> {
  final StudentRepository repository;
  GetStudentGradesUseCase(this.repository);

  @override
  Future<List<GradeEntity>> call(NoParams params) {
    return repository.getStudentGrades();
  }
}

class GetStudentFinancialsUseCase implements UseCase<List<PaymentInstallmentEntity>, NoParams> {
  final StudentRepository repository;
  GetStudentFinancialsUseCase(this.repository);

  @override
  Future<List<PaymentInstallmentEntity>> call(NoParams params) {
    return repository.getInstallments();
  }
}

class PayInstallmentParams {
  final String installmentId;
  const PayInstallmentParams(this.installmentId);
}

class PayInstallmentUseCase implements UseCase<void, PayInstallmentParams> {
  final StudentRepository repository;
  PayInstallmentUseCase(this.repository);

  @override
  Future<void> call(PayInstallmentParams params) {
    return repository.payInstallment(params.installmentId);
  }
}

class GetServiceRequestsUseCase implements UseCase<List<ServiceRequestEntity>, NoParams> {
  final StudentRepository repository;
  GetServiceRequestsUseCase(this.repository);

  @override
  Future<List<ServiceRequestEntity>> call(NoParams params) {
    return repository.getServiceRequests();
  }
}

class SubmitServiceRequestParams {
  final String titleAr;
  final String titleEn;
  final double fee;

  const SubmitServiceRequestParams({
    required this.titleAr,
    required this.titleEn,
    required this.fee,
  });
}

class SubmitServiceRequestUseCase implements UseCase<ServiceRequestEntity, SubmitServiceRequestParams> {
  final StudentRepository repository;
  SubmitServiceRequestUseCase(this.repository);

  @override
  Future<ServiceRequestEntity> call(SubmitServiceRequestParams params) {
    return repository.submitServiceRequest(
      titleAr: params.titleAr,
      titleEn: params.titleEn,
      fee: params.fee,
    );
  }
}

class GetAnnouncementsUseCase implements UseCase<List<AnnouncementEntity>, NoParams> {
  final StudentRepository repository;
  GetAnnouncementsUseCase(this.repository);

  @override
  Future<List<AnnouncementEntity>> call(NoParams params) {
    return repository.getAnnouncements();
  }
}
