import 'package:flutter/material.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/student_entity.dart';
import '../../domain/entities/academic_entities.dart';
import '../../domain/usecases/student_usecases.dart';

class StudentController extends ChangeNotifier {
  final GetStudentProfileUseCase getStudentProfileUseCase;
  final GetWeeklyScheduleUseCase getWeeklyScheduleUseCase;
  final GetExamScheduleUseCase getExamScheduleUseCase;
  final GetStudentGradesUseCase getStudentGradesUseCase;
  final GetStudentFinancialsUseCase getStudentFinancialsUseCase;
  final PayInstallmentUseCase payInstallmentUseCase;
  final GetServiceRequestsUseCase getServiceRequestsUseCase;
  final SubmitServiceRequestUseCase submitServiceRequestUseCase;
  final GetAnnouncementsUseCase getAnnouncementsUseCase;

  StudentController({
    required this.getStudentProfileUseCase,
    required this.getWeeklyScheduleUseCase,
    required this.getExamScheduleUseCase,
    required this.getStudentGradesUseCase,
    required this.getStudentFinancialsUseCase,
    required this.payInstallmentUseCase,
    required this.getServiceRequestsUseCase,
    required this.submitServiceRequestUseCase,
    required this.getAnnouncementsUseCase,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserRole _role = UserRole.student;
  UserRole get role => _role;
  bool get isStudent => _role == UserRole.student;
  bool get isFaculty => _role == UserRole.faculty;

  void switchRole(UserRole newRole) {
    _role = newRole;
    notifyListeners();
  }

  // Student Profile
  StudentEntity? _student;
  StudentEntity get student =>
      _student ??
      const StudentEntity(
        id: 'THB-2022-0451',
        academicId: '20220451',
        nationalId: '30205140102938',
        seatNumber: '4128',
        nameAr: 'أحمد محمود الشريف',
        nameEn: 'Ahmed Mahmoud El-Sherif',
        instituteAr: 'المعهد العالي لتكنولوجيا الإدارة والمعلومات',
        instituteEn: 'Higher Institute of Management & Info Tech',
        departmentAr: 'علوم الحاسب ونظم المعلومات',
        departmentEn: 'Computer Science & Info Systems',
        academicYear: 3,
        gpa: 3.68,
        completedHours: 92,
        totalRequiredHours: 136,
        attendanceRate: 94.5,
        academicAdvisorAr: 'أ.د. عادل سليمان عبد الرحيم',
        academicAdvisorEn: 'Prof. Dr. Adel Soliman',
        photoUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=400&q=80',
        email: 'ahmed.elsherif@thebes.edu.eg',
        phone: '+20 101 234 5678',
      );

  // Schedule
  int _selectedDayIndex = 0;
  int get selectedDayIndex => _selectedDayIndex;
  void setSelectedDayIndex(int idx) {
    _selectedDayIndex = idx;
    notifyListeners();
  }

  List<CourseScheduleEntity> _schedule = [];
  List<CourseScheduleEntity> get schedule => _schedule;
  List<CourseScheduleEntity> get dayClasses =>
      _schedule.where((item) => item.dayIndex == _selectedDayIndex).toList();

  CourseScheduleEntity get nextLecture => _schedule.isNotEmpty
      ? _schedule.first
      : const CourseScheduleEntity(
          id: 'cs301',
          code: 'CS 301',
          titleAr: 'تطوير تطبيقات الهواتف الذكية (Mobile Dev)',
          titleEn: 'Mobile App Development',
          creditHours: 3,
          instructorAr: 'د. خالد عبد الحميد',
          instructorEn: 'Dr. Khaled Abdelhamid',
          dayAr: 'السبت',
          dayEn: 'Saturday',
          dayIndex: 0,
          startTime: '09:00 ص',
          endTime: '11:00 ص',
          hallAr: 'مدرج 302',
          hallEn: 'Auditorium 302',
          type: LectureType.lecture,
          isUpcoming: true,
        );

  // Exams
  List<ExamEntity> _exams = [];
  List<ExamEntity> get exams => _exams;

  // Grades
  List<GradeEntity> _grades = [];
  List<GradeEntity> get grades => _grades;

  // Financials
  List<PaymentInstallmentEntity> _installments = [];
  List<PaymentInstallmentEntity> get installments => _installments;
  double get totalTuition => 28500.0;
  double get paidTuition => 20000.0;
  double get remainingTuition => 8500.0;

  // Requests
  List<ServiceRequestEntity> _requests = [];
  List<ServiceRequestEntity> get requests => _requests;

  // Announcements
  List<AnnouncementEntity> _announcements = [];
  List<AnnouncementEntity> get announcements => _announcements;

  // Faculty Live Attendance simulation
  bool _isAttendanceActive = false;
  bool get isAttendanceActive => _isAttendanceActive;
  int _presentStudentsCount = 42;
  int get presentStudentsCount => _presentStudentsCount;

  void toggleAttendanceSession() {
    _isAttendanceActive = !_isAttendanceActive;
    if (_isAttendanceActive) {
      _presentStudentsCount += 3;
    }
    notifyListeners();
  }

  // Load all initial data via UseCases
  Future<void> loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _student = await getStudentProfileUseCase(const NoParams());
      _schedule = await getWeeklyScheduleUseCase(const NoParams());
      _exams = await getExamScheduleUseCase(const NoParams());
      _grades = await getStudentGradesUseCase(const NoParams());
      _installments = await getStudentFinancialsUseCase(const NoParams());
      _requests = await getServiceRequestsUseCase(const NoParams());
      _announcements = await getAnnouncementsUseCase(const NoParams());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> payInstallment(String id) async {
    await payInstallmentUseCase(PayInstallmentParams(id));
    _installments = await getStudentFinancialsUseCase(const NoParams());
    notifyListeners();
  }

  Future<void> submitRequest(String titleAr, String titleEn, double fee) async {
    final req = await submitServiceRequestUseCase(
      SubmitServiceRequestParams(titleAr: titleAr, titleEn: titleEn, fee: fee),
    );
    _requests.insert(0, req);
    notifyListeners();
  }
}
