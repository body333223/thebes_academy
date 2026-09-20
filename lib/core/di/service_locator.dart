import 'package:get_it/get_it.dart';
import '../../core/storage/local_cache_service.dart';
import '../../features/student/data/datasources/student_remote_datasource.dart';
import '../../features/student/data/repositories/student_repository_impl.dart';
import '../../features/student/domain/repositories/student_repository.dart';
import '../../features/student/domain/usecases/student_usecases.dart';
import '../../features/student/presentation/controllers/student_controller.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // 0. Storage
  sl.registerLazySingleton<LocalCacheService>(() => LocalCacheService());

  // 1. Data Sources
  sl.registerLazySingleton<StudentRemoteDataSource>(() => StudentRemoteDataSourceImpl());

  // 2. Repositories
  sl.registerLazySingleton<StudentRepository>(
    () => StudentRepositoryImpl(remoteDataSource: sl()),
  );

  // 3. Use Cases
  sl.registerLazySingleton(() => GetStudentProfileUseCase(sl()));
  sl.registerLazySingleton(() => GetWeeklyScheduleUseCase(sl()));
  sl.registerLazySingleton(() => GetExamScheduleUseCase(sl()));
  sl.registerLazySingleton(() => GetStudentGradesUseCase(sl()));
  sl.registerLazySingleton(() => GetStudentFinancialsUseCase(sl()));
  sl.registerLazySingleton(() => PayInstallmentUseCase(sl()));
  sl.registerLazySingleton(() => GetServiceRequestsUseCase(sl()));
  sl.registerLazySingleton(() => SubmitServiceRequestUseCase(sl()));
  sl.registerLazySingleton(() => GetAnnouncementsUseCase(sl()));
  sl.registerLazySingleton(() => ScanDoctorQrUseCase(sl()));
  sl.registerLazySingleton(() => GetAttendanceStatsUseCase(sl()));
  sl.registerLazySingleton(() => GetAttendanceHistoryUseCase(sl()));

  // 4. Controllers
  sl.registerFactory(
    () => StudentController(
      localCacheService: sl(),
      getStudentProfileUseCase: sl(),
      getWeeklyScheduleUseCase: sl(),
      getExamScheduleUseCase: sl(),
      getStudentGradesUseCase: sl(),
      getStudentFinancialsUseCase: sl(),
      payInstallmentUseCase: sl(),
      getServiceRequestsUseCase: sl(),
      submitServiceRequestUseCase: sl(),
      getAnnouncementsUseCase: sl(),
      scanDoctorQrUseCase: sl(),
      getAttendanceStatsUseCase: sl(),
      getAttendanceHistoryUseCase: sl(),
    ),
  );
}
