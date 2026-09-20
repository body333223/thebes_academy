import 'package:flutter/material.dart';
import '../../../../core/storage/local_cache_service.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/student_entity.dart';
import '../../domain/entities/academic_entities.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/usecases/student_usecases.dart';

class StudentController extends ChangeNotifier {
  final LocalCacheService localCacheService;
  final GetStudentProfileUseCase getStudentProfileUseCase;
  final GetWeeklyScheduleUseCase getWeeklyScheduleUseCase;
  final GetExamScheduleUseCase getExamScheduleUseCase;
  final GetStudentGradesUseCase getStudentGradesUseCase;
  final GetStudentFinancialsUseCase getStudentFinancialsUseCase;
  final PayInstallmentUseCase payInstallmentUseCase;
  final GetServiceRequestsUseCase getServiceRequestsUseCase;
  final SubmitServiceRequestUseCase submitServiceRequestUseCase;
  final GetAnnouncementsUseCase getAnnouncementsUseCase;
  final ScanDoctorQrUseCase scanDoctorQrUseCase;
  final GetAttendanceStatsUseCase getAttendanceStatsUseCase;
  final GetAttendanceHistoryUseCase getAttendanceHistoryUseCase;

  StudentController({
    required this.localCacheService,
    required this.getStudentProfileUseCase,
    required this.getWeeklyScheduleUseCase,
    required this.getExamScheduleUseCase,
    required this.getStudentGradesUseCase,
    required this.getStudentFinancialsUseCase,
    required this.payInstallmentUseCase,
    required this.getServiceRequestsUseCase,
    required this.submitServiceRequestUseCase,
    required this.getAnnouncementsUseCase,
    required this.scanDoctorQrUseCase,
    required this.getAttendanceStatsUseCase,
    required this.getAttendanceHistoryUseCase,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isOnline = true;
  bool get isOnline => _isOnline;

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  DateTime? _lastSyncTime;
  DateTime? get lastSyncTime => _lastSyncTime;

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

  // Role switcher
  UserRole _role = UserRole.student;
  UserRole get role => _role;
  bool get isStudent => _role == UserRole.student;

  void switchRole(UserRole newRole) {
    _role = newRole;
    notifyListeners();
  }

  // Schedule
  List<CourseScheduleEntity> _schedule = [];
  List<CourseScheduleEntity> get schedule => _schedule;

  int _selectedDayIndex = 0;
  int get selectedDayIndex => _selectedDayIndex;

  void setSelectedDayIndex(int index) {
    _selectedDayIndex = index;
    notifyListeners();
  }

  List<CourseScheduleEntity> get dayClasses {
    if (_schedule.isEmpty) return [];
    return _schedule.where((c) => c.dayIndex == _selectedDayIndex).toList();
  }

  // Next upcoming lecture
  CourseScheduleEntity? get nextLecture {
    if (_schedule.isEmpty) return null;
    return _schedule.firstWhere(
      (c) => c.isUpcoming,
      orElse: () => _schedule.first,
    );
  }

  // Exams
  List<ExamEntity> _exams = [];
  List<ExamEntity> get exams => _exams;

  // Grades
  List<GradeEntity> _grades = [];
  List<GradeEntity> get grades => _grades;

  // Financials
  List<PaymentInstallmentEntity> _installments = [];
  List<PaymentInstallmentEntity> get installments => _installments;

  double get totalTuition => _installments.fold(0, (sum, i) => sum + i.amount);
  double get paidTuition =>
      _installments.where((i) => i.status == PaymentStatus.paid).fold(0, (sum, i) => sum + i.amount);
  double get remainingTuition => totalTuition - paidTuition;

  // Requests
  List<ServiceRequestEntity> _requests = [];
  List<ServiceRequestEntity> get requests => _requests;

  // Announcements
  List<AnnouncementEntity> _announcements = [];
  List<AnnouncementEntity> get announcements => _announcements;

  // Student Attendance via Doctor QR
  List<CourseAttendanceStatEntity> _attendanceStats = [];
  List<CourseAttendanceStatEntity> get attendanceStats => _attendanceStats;

  List<AttendanceRecordEntity> _attendanceHistory = [];
  List<AttendanceRecordEntity> get attendanceHistory => _attendanceHistory;

  AttendanceRecordEntity? _lastScannedRecord;
  AttendanceRecordEntity? get lastScannedRecord => _lastScannedRecord;

  String? _scanErrorMessage;
  String? get scanErrorMessage => _scanErrorMessage;

  bool _isScanning = false;
  bool get isScanning => _isScanning;

  // Notifications
  List<NotificationEntity> _notifications = [];
  List<NotificationEntity> get notifications => _notifications;
  int get unreadNotificationsCount => _notifications.where((n) => !n.isRead).length;

  void markNotificationAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      localCacheService.cacheNotificationsJson(_notifications.map((e) => e.toJson()).toList());
      notifyListeners();
    }
  }

  void markAllNotificationsAsRead() {
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    localCacheService.cacheNotificationsJson(_notifications.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    localCacheService.cacheNotificationsJson(_notifications.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  // Absence Warnings & Academic Risk
  int get totalAbsenceWarnings => _attendanceStats.where((s) => s.isAtRisk || s.isDeprived).length;
  List<CourseAttendanceStatEntity> get atRiskCourses =>
      _attendanceStats.where((s) => s.isAtRisk || s.isDeprived).toList();

  // GPA Simulator
  static const Map<String, double> letterToPoints = {
    'A+': 4.0,
    'A': 4.0,
    'A-': 3.7,
    'B+': 3.3,
    'B': 3.0,
    'B-': 2.7,
    'C+': 2.3,
    'C': 2.0,
    'C-': 1.7,
    'D+': 1.3,
    'D': 1.0,
    'F': 0.0,
  };

  double calculateSimulatedGpa(Map<String, String> expectedGrades) {
    final currentGpa = student.gpa;
    final currentHours = student.completedHours;
    double currentPoints = currentGpa * currentHours;

    int newHours = 0;
    double newPoints = 0.0;

    for (final entry in expectedGrades.entries) {
      final code = entry.key;
      final grade = entry.value;
      final course = _grades.firstWhere(
        (g) => g.courseCode == code,
        orElse: () => _grades.isNotEmpty
            ? _grades.first
            : const GradeEntity(
                courseCode: '',
                courseNameAr: '',
                courseNameEn: '',
                creditHours: 3,
                courseworkScore: 0,
                midtermScore: 0,
                practicalScore: 0,
                finalExamScore: 0,
                totalScore: 0,
                gradeLetter: 'A',
                points: 4.0,
                semesterAr: '',
                semesterEn: '',
              ),
      );

      final pts = letterToPoints[grade] ?? 3.0;
      final ch = course.creditHours > 0 ? course.creditHours : 3;
      newHours += ch;
      newPoints += pts * ch;
    }

    if (currentHours + newHours == 0) return currentGpa;
    final simulated = (currentPoints + newPoints) / (currentHours + newHours);
    return double.parse(simulated.toStringAsFixed(2));
  }

  // Load all initial data via UseCases & Local Cache
  Future<void> loadInitialData({bool forceRefresh = false}) async {
    _isLoading = true;
    notifyListeners();

    // 1. Try loading cached notifications & sync timestamp first
    _lastSyncTime = await localCacheService.getLastSync();
    final cachedNotifs = await localCacheService.getCachedNotificationsJson();
    if (cachedNotifs != null && cachedNotifs.isNotEmpty) {
      _notifications = cachedNotifs.map((e) => NotificationEntity.fromJson(e)).toList();
    } else {
      _notifications = _generateDefaultNotifications();
      await localCacheService.cacheNotificationsJson(_notifications.map((e) => e.toJson()).toList());
    }

    try {
      _student = await getStudentProfileUseCase(const NoParams());
      _schedule = await getWeeklyScheduleUseCase(const NoParams());
      _exams = await getExamScheduleUseCase(const NoParams());
      _grades = await getStudentGradesUseCase(const NoParams());
      _installments = await getStudentFinancialsUseCase(const NoParams());
      _requests = await getServiceRequestsUseCase(const NoParams());
      _announcements = await getAnnouncementsUseCase(const NoParams());
      _attendanceStats = await getAttendanceStatsUseCase(const NoParams());
      _attendanceHistory = await getAttendanceHistoryUseCase(const NoParams());

      _isOnline = true;
      _lastSyncTime = DateTime.now();
      await localCacheService.updateLastSync(_lastSyncTime!);
    } catch (_) {
      _isOnline = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> syncNow() async {
    _isSyncing = true;
    notifyListeners();
    try {
      await loadInitialData(forceRefresh: true);
      _isOnline = true;
    } catch (_) {
      _isOnline = false;
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  List<NotificationEntity> _generateDefaultNotifications() {
    final now = DateTime.now();
    return [
      NotificationEntity(
        id: 'notif_1',
        titleAr: 'تذكير بمحاضرة قادمة 📚',
        titleEn: 'Upcoming Lecture Reminder 📚',
        messageAr: 'نظم إدارة قواعد البيانات (CS301) تبدأ بعد 15 دقيقة في مدرج أ - مبنى المعادي.',
        messageEn: 'Database Systems (CS301) starts in 15 mins at Hall A - Maadi Campus.',
        timestamp: now.subtract(const Duration(minutes: 12)),
        type: NotificationType.lectureReminder,
        isRead: false,
      ),
      NotificationEntity(
        id: 'notif_2',
        titleAr: 'إنذار غياب أكاديمي ⚠️',
        titleEn: 'Absence Risk Warning ⚠️',
        messageAr: 'تنبيه: متبقي لك محاضرة غياب واحدة في مادة هياكل البيانات قبل تطبيق الحرمان (25%).',
        messageEn: 'Alert: 1 absence remaining in Data Structures before 25% course deprivation.',
        timestamp: now.subtract(const Duration(hours: 3)),
        type: NotificationType.absenceWarning,
        isRead: false,
      ),
      NotificationEntity(
        id: 'notif_3',
        titleAr: 'بوابات الدخول الرقمية 💳',
        titleEn: 'Digital Campus Gate Pass 💳',
        messageAr: 'تم تفعيل تصريح الدخول الأمني السريع عبر الكارنيه الإلكتروني للترم الدراسي الحالي.',
        messageEn: 'Digital ID contactless gate pass has been renewed for current semester.',
        timestamp: now.subtract(const Duration(days: 1)),
        type: NotificationType.universityNews,
        isRead: true,
      ),
      NotificationEntity(
        id: 'notif_4',
        titleAr: 'إعلان جداول امتحانات الميدتيرم 📅',
        titleEn: 'Midterm Schedules Published 📅',
        messageAr: 'تم اعتماد جدول امتحانات منتصف الفصل الدراسي بجميع الأقسام وتحديد أرقام الجلوس.',
        messageEn: 'Midterm exam schedules and seat allocations have been officially published.',
        timestamp: now.subtract(const Duration(days: 2)),
        type: NotificationType.universityNews,
        isRead: true,
      ),
    ];
  }

  // Scan Doctor QR Code
  Future<bool> scanDoctorQr(String qrToken) async {
    _isScanning = true;
    _scanErrorMessage = null;
    notifyListeners();

    try {
      final record = await scanDoctorQrUseCase(ScanDoctorQrParams(qrToken));
      _lastScannedRecord = record;
      _attendanceHistory = await getAttendanceHistoryUseCase(const NoParams());
      _attendanceStats = await getAttendanceStatsUseCase(const NoParams());
      _facultySessionAttendees++;
      _isScanning = false;
      notifyListeners();
      return true;
    } catch (e) {
      _scanErrorMessage = e.toString().replaceAll('Exception: ', '');
      _isScanning = false;
      notifyListeners();
      return false;
    }
  }

  // Doctor / Faculty Live Session State
  bool _isFacultySessionActive = true;
  bool get isFacultySessionActive => _isFacultySessionActive;

  String _activeFacultySessionCode = '839204';
  String get activeFacultySessionCode => _activeFacultySessionCode;

  String _activeFacultySessionCourse = 'CS301';
  String get activeFacultySessionCourse => _activeFacultySessionCourse;

  int _facultySessionAttendees = 42;
  int get facultySessionAttendees => _facultySessionAttendees;

  void toggleFacultySession({String? courseCode, String? pin}) {
    _isFacultySessionActive = !_isFacultySessionActive;
    if (courseCode != null) _activeFacultySessionCourse = courseCode;
    if (pin != null) _activeFacultySessionCode = pin;
    notifyListeners();
  }

  void refreshFacultySessionPin() {
    final randomDigits = (100000 + (DateTime.now().millisecondsSinceEpoch % 900000)).toString();
    _activeFacultySessionCode = randomDigits;
    notifyListeners();
  }

  void broadcastCourseAnnouncement({
    required String courseCode,
    required String titleAr,
    required String messageAr,
  }) {
    final notif = NotificationEntity(
      id: 'broadcast_${DateTime.now().millisecondsSinceEpoch}',
      titleAr: titleAr,
      titleEn: 'Academic Announcement: $courseCode',
      messageAr: messageAr,
      messageEn: messageAr,
      timestamp: DateTime.now(),
      type: NotificationType.universityNews,
      isRead: false,
    );
    _notifications.insert(0, notif);
    localCacheService.cacheNotificationsJson(_notifications.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  void clearScanError() {
    _scanErrorMessage = null;
    notifyListeners();
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
