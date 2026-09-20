import '../../domain/entities/academic_entities.dart';
import '../models/student_model.dart';

abstract class StudentRemoteDataSource {
  Future<StudentModel> getStudentProfile();
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
  Future<List<CourseAttendanceStatEntity>> getAttendanceStats();
  Future<List<AttendanceRecordEntity>> getAttendanceHistory();
  Future<AttendanceRecordEntity> scanDoctorQr(String qrToken);
}

class StudentRemoteDataSourceImpl implements StudentRemoteDataSource {
  // In-memory data store simulating remote backend API with latency
  final StudentModel _student = const StudentModel(
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

  List<PaymentInstallmentEntity> _installments = [
    const PaymentInstallmentEntity(
      id: 'inst-1',
      titleAr: 'القسط الأول (المصروفات الإدارية والقيد)',
      titleEn: '1st Installment (Admin & Reg Fees)',
      amount: 10000.0,
      dueDate: '01 أكتوبر 2026',
      status: PaymentStatus.paid,
      receiptNumber: 'REC-THB-883921',
      paidDate: '28 سبتمبر 2026',
    ),
    const PaymentInstallmentEntity(
      id: 'inst-2',
      titleAr: 'القسط الثاني (الفصل الدراسي الأول)',
      titleEn: '2nd Installment (First Term)',
      amount: 10000.0,
      dueDate: '15 نوفمبر 2026',
      status: PaymentStatus.paid,
      receiptNumber: 'REC-THB-910245',
      paidDate: '12 نوفمبر 2026',
    ),
    const PaymentInstallmentEntity(
      id: 'inst-3',
      titleAr: 'القسط الثالث (الفصل الدراسي الثاني)',
      titleEn: '3rd Installment (Second Term)',
      amount: 8500.0,
      dueDate: '10 فبراير 2027',
      status: PaymentStatus.pending,
    ),
  ];

  final List<ServiceRequestEntity> _requests = [
    const ServiceRequestEntity(
      id: 'req-01',
      titleAr: 'إفادة قيد رسمية موجهة للسفارة',
      titleEn: 'Official Enrollment Letter',
      requestDate: '10 سبتمبر 2026',
      status: RequestStatus.completed,
      referenceNumber: 'SRV-82914',
      fee: 150.0,
    ),
    const ServiceRequestEntity(
      id: 'req-02',
      titleAr: 'بيان درجات باللغة الإنجليزية',
      titleEn: 'Official Transcript in English',
      requestDate: '14 سبتمبر 2026',
      status: RequestStatus.underReview,
      referenceNumber: 'SRV-94012',
      fee: 250.0,
    ),
  ];

  @override
  Future<StudentModel> getStudentProfile() async {
    return _student;
  }

  @override
  Future<List<CourseScheduleEntity>> getWeeklySchedule() async {
    return [
      const CourseScheduleEntity(
        id: 'cs301-sat',
        code: 'CS 301',
        titleAr: 'تطوير تطبيقات الهواتف الذكية (Mobile Dev)',
        titleEn: 'Mobile Application Development',
        creditHours: 3,
        instructorAr: 'د. خالد عبد الحميد',
        instructorEn: 'Dr. Khaled Abdelhamid',
        dayAr: 'السبت',
        dayEn: 'Saturday',
        dayIndex: 0,
        startTime: '09:00 ص',
        endTime: '11:00 ص',
        hallAr: 'مدرج 302 - مبنى الهندسة',
        hallEn: 'Auditorium 302 - Eng Bldg',
        type: LectureType.lecture,
        isUpcoming: true,
      ),
      const CourseScheduleEntity(
        id: 'cs301-sec-sat',
        code: 'CS 301 L',
        titleAr: 'معمل تطبيقات الهواتف الذكية (Flutter Lab)',
        titleEn: 'Mobile Dev Lab (Flutter)',
        creditHours: 1,
        instructorAr: 'م. سارة إبراهيم',
        instructorEn: 'Eng. Sara Ibrahim',
        dayAr: 'السبت',
        dayEn: 'Saturday',
        dayIndex: 0,
        startTime: '11:30 ص',
        endTime: '01:30 م',
        hallAr: 'معمل حاسبات 4 - مبنى الإدارة',
        hallEn: 'Computer Lab 4 - Admin Bldg',
        type: LectureType.lab,
      ),
      const CourseScheduleEntity(
        id: 'cs304-sun',
        code: 'CS 304',
        titleAr: 'الذكاء الاصطناعي وتعلم الآلة',
        titleEn: 'Artificial Intelligence & ML',
        creditHours: 3,
        instructorAr: 'أ.د. هشام مصطفى',
        instructorEn: 'Prof. Hesham Moustafa',
        dayAr: 'الأحد',
        dayEn: 'Sunday',
        dayIndex: 1,
        startTime: '10:00 ص',
        endTime: '12:00 م',
        hallAr: 'مدرج فاروق الباز - القاعة الكبرى',
        hallEn: 'Farouk El-Baz Grand Hall',
        type: LectureType.lecture,
      ),
      const CourseScheduleEntity(
        id: 'is302-mon',
        code: 'IS 302',
        titleAr: 'هندسة البرمجيات والمنظومات الذكية',
        titleEn: 'Software Engineering & Agile',
        creditHours: 3,
        instructorAr: 'د. منى زهران',
        instructorEn: 'Dr. Mona Zahran',
        dayAr: 'الإثنين',
        dayEn: 'Monday',
        dayIndex: 2,
        startTime: '09:30 ص',
        endTime: '11:30 ص',
        hallAr: 'مدرج 201 - مبنى أ',
        hallEn: 'Auditorium 201 - Bldg A',
        type: LectureType.lecture,
      ),
      const CourseScheduleEntity(
        id: 'cs308-tue',
        code: 'CS 308',
        titleAr: 'أمن المعلومات والأمن السيبراني',
        titleEn: 'Information & Cyber Security',
        creditHours: 3,
        instructorAr: 'د. حسام عزمي',
        instructorEn: 'Dr. Hossam Azmy',
        dayAr: 'الثلاثاء',
        dayEn: 'Tuesday',
        dayIndex: 3,
        startTime: '11:00 ص',
        endTime: '01:00 م',
        hallAr: 'مدرج الدكتور إبراهيم الفقي',
        hallEn: 'Dr. El-Feky Auditorium',
        type: LectureType.lecture,
      ),
    ];
  }

  @override
  Future<List<ExamEntity>> getExamSchedule() async {
    return [
      const ExamEntity(
        courseCode: 'CS 301',
        courseNameAr: 'تطوير تطبيقات الهواتف الذكية',
        courseNameEn: 'Mobile Application Development',
        date: '15 يناير 2027',
        time: '09:00 ص - 12:00 م',
        hall: 'لجنة رقم (12) - مبنى الهندسة صالة 1',
        seatNo: '4128',
      ),
      const ExamEntity(
        courseCode: 'CS 304',
        courseNameAr: 'الذكاء الاصطناعي وتعلم الآلة',
        courseNameEn: 'Artificial Intelligence & ML',
        date: '19 يناير 2027',
        time: '09:00 ص - 12:00 م',
        hall: 'لجنة رقم (12) - مبنى الهندسة صالة 1',
        seatNo: '4128',
      ),
      const ExamEntity(
        courseCode: 'IS 302',
        courseNameAr: 'هندسة البرمجيات والمنظومات',
        courseNameEn: 'Software Engineering',
        date: '23 يناير 2027',
        time: '09:00 ص - 12:00 م',
        hall: 'لجنة رقم (14) - القاعة الكبرى',
        seatNo: '4128',
      ),
    ];
  }

  @override
  Future<List<GradeEntity>> getStudentGrades() async {
    return [
      const GradeEntity(
        courseCode: 'CS 201',
        courseNameAr: 'تراكيب البيانات والخوارزميات',
        courseNameEn: 'Data Structures & Algorithms',
        creditHours: 3,
        courseworkScore: 19.0,
        midtermScore: 19.5,
        practicalScore: 10.0,
        finalExamScore: 47.0,
        totalScore: 95.5,
        gradeLetter: 'A+',
        points: 4.0,
        semesterAr: 'الفصل الدراسي السابق (ربيع 2026)',
        semesterEn: 'Previous Semester (Spring 2026)',
      ),
      const GradeEntity(
        courseCode: 'IS 202',
        courseNameAr: 'قواعد البيانات المتقدمة SQL & NoSQL',
        courseNameEn: 'Advanced Databases SQL/NoSQL',
        creditHours: 3,
        courseworkScore: 18.5,
        midtermScore: 18.0,
        practicalScore: 9.5,
        finalExamScore: 45.0,
        totalScore: 91.0,
        gradeLetter: 'A',
        points: 3.85,
        semesterAr: 'الفصل الدراسي السابق (ربيع 2026)',
        semesterEn: 'Previous Semester (Spring 2026)',
      ),
      const GradeEntity(
        courseCode: 'CS 205',
        courseNameAr: 'شبكات الحاسب وبروتوكولات الإنترنت',
        courseNameEn: 'Computer Networks & Protocols',
        creditHours: 3,
        courseworkScore: 17.0,
        midtermScore: 17.5,
        practicalScore: 9.0,
        finalExamScore: 42.0,
        totalScore: 85.5,
        gradeLetter: 'B+',
        points: 3.4,
        semesterAr: 'الفصل الدراسي السابق (ربيع 2026)',
        semesterEn: 'Previous Semester (Spring 2026)',
      ),
    ];
  }

  @override
  Future<List<PaymentInstallmentEntity>> getInstallments() async {
    return _installments;
  }

  @override
  Future<void> payInstallment(String installmentId) async {
    _installments = _installments.map((item) {
      if (item.id == installmentId) {
        return PaymentInstallmentEntity(
          id: item.id,
          titleAr: item.titleAr,
          titleEn: item.titleEn,
          amount: item.amount,
          dueDate: item.dueDate,
          status: PaymentStatus.paid,
          receiptNumber: 'REC-THB-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
          paidDate: 'الآن (سداد إلكتروني فوري)',
        );
      }
      return item;
    }).toList();
  }

  @override
  Future<List<ServiceRequestEntity>> getServiceRequests() async {
    return _requests;
  }

  @override
  Future<ServiceRequestEntity> submitServiceRequest({
    required String titleAr,
    required String titleEn,
    required double fee,
  }) async {
    final newReq = ServiceRequestEntity(
      id: 'req-${DateTime.now().millisecondsSinceEpoch}',
      titleAr: titleAr,
      titleEn: titleEn,
      requestDate: 'اليوم',
      status: RequestStatus.underReview,
      referenceNumber: 'SRV-${(DateTime.now().millisecondsSinceEpoch % 100000).toString().padLeft(5, '0')}',
      fee: fee,
    );
    _requests.insert(0, newReq);
    return newReq;
  }

  @override
  Future<List<AnnouncementEntity>> getAnnouncements() async {
    return [
      const AnnouncementEntity(
        id: 'ann-1',
        titleAr: 'فتح باب تسجيل المقررات للفصل الدراسي الجديد إلكترونياً',
        titleEn: 'Online Course Registration Opened for New Term',
        contentAr: 'تعلن إدارة شؤون الطلاب بأكاديمية طيبة عن إتاحة تسجيل المقررات عبر التطبيق والمنظومة الإلكترونية لجميع الفرق.',
        contentEn: 'Thebes Student Affairs announces the opening of online course registration through the mobile app and portal.',
        categoryAr: 'شؤون الطلاب',
        categoryEn: 'Student Affairs',
        date: '18 سبتمبر 2026',
        isImportant: true,
      ),
      const AnnouncementEntity(
        id: 'ann-2',
        titleAr: 'انطلاق معرض مشاريع تخرج هندسة وتكنولوجيا المعلومات',
        titleEn: 'Launch of Annual Engineering & Tech Graduation Projects Expo',
        contentAr: 'يسر مجلس إدارة الأكاديمية دعوة أبنائنا الطلاب لحضور افتتاح معرض مشاريع التخرج.',
        contentEn: 'Thebes Board of Directors invites students to attend the Graduation Projects Expo.',
        categoryAr: 'فعاليات ومؤتمرات',
        categoryEn: 'Events',
        date: '15 سبتمبر 2026',
        isImportant: false,
      ),
    ];
  }

  final List<CourseAttendanceStatEntity> _attendanceStats = [
    const CourseAttendanceStatEntity(
      courseCode: 'CS301',
      courseTitleAr: 'الذكاء الاصطناعي وتعلم الآلة',
      courseTitleEn: 'Artificial Intelligence & ML',
      totalLectures: 14,
      attendedLectures: 13,
      absentLectures: 1,
      attendancePercentage: 92.8,
      warningsCount: 0,
    ),
    const CourseAttendanceStatEntity(
      courseCode: 'CS302',
      courseTitleAr: 'إدارة قواعد البيانات المتقدمة',
      courseTitleEn: 'Advanced Database Management',
      totalLectures: 14,
      attendedLectures: 14,
      absentLectures: 0,
      attendancePercentage: 100.0,
      warningsCount: 0,
    ),
    const CourseAttendanceStatEntity(
      courseCode: 'CS304',
      courseTitleAr: 'أمن وسرية المعلومات والشبكات',
      courseTitleEn: 'Information & Network Security',
      totalLectures: 14,
      attendedLectures: 12,
      absentLectures: 2,
      attendancePercentage: 85.7,
      warningsCount: 0,
    ),
    const CourseAttendanceStatEntity(
      courseCode: 'CS305',
      courseTitleAr: 'تطوير تطبيقات الهواتف الذكية',
      courseTitleEn: 'Mobile App Development',
      totalLectures: 14,
      attendedLectures: 14,
      absentLectures: 0,
      attendancePercentage: 100.0,
      warningsCount: 0,
    ),
    const CourseAttendanceStatEntity(
      courseCode: 'HUM201',
      courseTitleAr: 'التفكير النقدي ومهارات الاتصال',
      courseTitleEn: 'Critical Thinking & Communication',
      totalLectures: 12,
      attendedLectures: 10,
      absentLectures: 2,
      attendancePercentage: 83.3,
      warningsCount: 1,
    ),
  ];

  final List<AttendanceRecordEntity> _attendanceHistory = [
    AttendanceRecordEntity(
      id: 'att-1',
      courseCode: 'CS301',
      courseTitleAr: 'الذكاء الاصطناعي وتعلم الآلة',
      courseTitleEn: 'Artificial Intelligence & ML',
      doctorNameAr: 'أ.د. عادل سليمان',
      doctorNameEn: 'Prof. Dr. Adel Soliman',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      hall: 'مدرج 402 - مبنى الهندسة',
      sessionQrToken: 'THEBES-CS301-2026',
      isVerified: true,
    ),
    AttendanceRecordEntity(
      id: 'att-2',
      courseCode: 'CS305',
      courseTitleAr: 'تطوير تطبيقات الهواتف الذكية',
      courseTitleEn: 'Mobile App Development',
      doctorNameAr: 'د. سامح كمال الدين',
      doctorNameEn: 'Dr. Sameh Kamal',
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 2)),
      hall: 'معمل الحاسب 3 - الدور الثاني',
      sessionQrToken: 'THEBES-CS305-2026',
      isVerified: true,
    ),
  ];

  @override
  Future<List<CourseAttendanceStatEntity>> getAttendanceStats() async {
    return _attendanceStats;
  }

  @override
  Future<List<AttendanceRecordEntity>> getAttendanceHistory() async {
    return _attendanceHistory;
  }

  @override
  Future<AttendanceRecordEntity> scanDoctorQr(String qrToken) async {
    final raw = qrToken.trim().replaceAll(' ', '').toUpperCase();
    if (raw.length < 3) {
      throw Exception('يرجى إدخال رمز حضور صحيح مكون من 4 إلى 6 أرقام أو مسح باركود الـ QR.');
    }

    // Default course: CS301
    String code = 'CS301';
    String titleAr = 'الذكاء الاصطناعي وتعلم الآلة';
    String titleEn = 'Artificial Intelligence & ML';
    String docAr = 'أ.د. عادل سليمان';
    String docEn = 'Prof. Dr. Adel Soliman';
    String hall = 'مدرج 402 - مبنى الهندسة';

    if (raw.contains('CS302') || raw.contains('DB') || raw.startsWith('204')) {
      code = 'CS302';
      titleAr = 'إدارة قواعد البيانات المتقدمة';
      titleEn = 'Advanced Database Management';
      docAr = 'د. نادية حسن مصطفى';
      docEn = 'Dr. Nadia Hassan';
      hall = 'مدرج 204 - مبنى العلوم';
    } else if (raw.contains('CS305') || raw.contains('MOBILE') || raw.startsWith('305')) {
      code = 'CS305';
      titleAr = 'تطوير تطبيقات الهواتف الذكية';
      titleEn = 'Mobile App Development';
      docAr = 'د. سامح كمال الدين';
      docEn = 'Dr. Sameh Kamal';
      hall = 'معمل الحاسب 3';
    } else if (raw.contains('CS304') || raw.contains('SEC') || raw.startsWith('101')) {
      code = 'CS304';
      titleAr = 'أمن وسرية المعلومات والشبكات';
      titleEn = 'Information & Network Security';
      docAr = 'د. طارق عبد الوهاب';
      docEn = 'Dr. Tarek Abdelwahab';
      hall = 'مدرج 101 - مبنى الإدارة';
    } else if (raw.contains('IS302') || raw.contains('SE')) {
      code = 'IS302';
      titleAr = 'هندسة البرمجيات والمنظومات';
      titleEn = 'Software Engineering';
      docAr = 'د. إيمان عبد العزيز';
      docEn = 'Dr. Eman Abdelaziz';
      hall = 'مدرج 301 - مبنى النظم';
    }

    final newRecord = AttendanceRecordEntity(
      id: 'att-${DateTime.now().millisecondsSinceEpoch}',
      courseCode: code,
      courseTitleAr: titleAr,
      courseTitleEn: titleEn,
      doctorNameAr: docAr,
      doctorNameEn: docEn,
      timestamp: DateTime.now(),
      hall: hall,
      sessionQrToken: raw,
      isVerified: true,
    );

    _attendanceHistory.insert(0, newRecord);
    return newRecord;
  }
}

