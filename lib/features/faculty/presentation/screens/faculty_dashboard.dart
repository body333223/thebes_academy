import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:thebes_academy/core/localization/locale_provider.dart';
import 'package:thebes_academy/core/theme/thebes_colors.dart';
import 'package:thebes_academy/features/student/presentation/controllers/student_controller.dart';

class FacultyDashboard extends StatefulWidget {
  const FacultyDashboard({super.key});

  @override
  State<FacultyDashboard> createState() => _FacultyDashboardState();
}

class _FacultyDashboardState extends State<FacultyDashboard> {
  String _selectedCourse = 'CS301';
  int _sessionMinutesRemaining = 15;

  final List<Map<String, dynamic>> _courses = [
    {
      'code': 'CS301',
      'titleAr': 'الذكاء الاصطناعي وتعلم الآلة',
      'titleEn': 'Artificial Intelligence & ML',
      'hall': 'مدرج 402 - مبنى الهندسة',
      'students': 118,
      'attendanceRate': 89.2,
      'atRiskCount': 2,
    },
    {
      'code': 'CS302',
      'titleAr': 'إدارة قواعد البيانات المتقدمة',
      'titleEn': 'Advanced Database Management',
      'hall': 'مدرج 204 - مبنى العلوم',
      'students': 134,
      'attendanceRate': 85.5,
      'atRiskCount': 3,
    },
    {
      'code': 'CS305',
      'titleAr': 'تطوير تطبيقات الهواتف الذكية (Flutter)',
      'titleEn': 'Mobile App Development',
      'hall': 'معمل الحاسب 3 - الدور الثاني',
      'students': 102,
      'attendanceRate': 93.1,
      'atRiskCount': 1,
    },
    {
      'code': 'CS304',
      'titleAr': 'أمن وسرية المعلومات والشبكات',
      'titleEn': 'Information & Network Security',
      'hall': 'مدرج 101 - مبنى الإدارة',
      'students': 128,
      'attendanceRate': 84.8,
      'atRiskCount': 1,
    },
  ];

  // Dummy Grade Sheet Data for Demo
  final List<Map<String, dynamic>> _gradeSheet = [
    {'name': 'أحمد محمود الشريف', 'id': '20220451', 'attend': 9, 'mid': 18, 'work': 19},
    {'name': 'سارة كريم عبد الرحمن', 'id': '20220452', 'attend': 10, 'mid': 19, 'work': 20},
    {'name': 'محمد خالد الدسوقي', 'id': '20220453', 'attend': 7, 'mid': 14, 'work': 15},
    {'name': 'عمر يوسف إبراهيم', 'id': '20220454', 'attend': 6, 'mid': 12, 'work': 13},
    {'name': 'فاطمة حسن البنا', 'id': '20220455', 'attend': 10, 'mid': 20, 'work': 19},
  ];

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<LocaleProvider>().isArabic;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = context.watch<StudentController>();

    final currentCourse = _courses.firstWhere(
      (c) => c['code'] == _selectedCourse,
      orElse: () => _courses.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.school_rounded, color: ThebesColors.gold, size: 22),
            const SizedBox(width: 8),
            Text(
              isArabic ? 'لوحة التحكم الأكاديمي' : 'Faculty Portal',
              style: GoogleFonts.cairo(fontWeight: FontWeight.w800, fontSize: 18),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.logout_rounded, size: 17, color: ThebesColors.gold),
            label: Text(
              isArabic ? 'واجهة الطالب' : 'Student View',
              style: GoogleFonts.cairo(
                color: ThebesColors.gold,
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Doctor Profile & Academic Header Card
                _buildDoctorHeader(isArabic, isDark),
                const SizedBox(height: 20),

                // 2. Quick Stat Counters
                _buildQuickMetricsGrid(isArabic, isDark),
                const SizedBox(height: 24),

                // 3. Live Projector QR & 6-Digit PIN Attendance Session
                _buildLiveAttendanceProjectorHero(context, controller, currentCourse, isArabic, isDark),
                const SizedBox(height: 28),

                // 4. Teaching Courses Management & Grade Entry
                _buildCoursesManagementSection(context, controller, isArabic, isDark),
                const SizedBox(height: 28),

                // 5. Academic Advising & Course Approval Governance
                _buildAcademicAdvisingSection(context, controller, isArabic, isDark),
                const SizedBox(height: 28),

                // 6. Academic Absence Risk & Warnings
                _buildAbsenceRiskSection(context, isArabic, isDark),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorHeader(bool isArabic, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? ThebesColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? ThebesColors.darkCardBorder : ThebesColors.lightCardBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 50 : 15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              gradient: ThebesColors.primaryGradient,
              shape: BoxShape.circle,
              border: Border.all(color: ThebesColors.gold, width: 2),
            ),
            child: const Center(
              child: Icon(Icons.person_outline_rounded, color: ThebesColors.gold, size: 30),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        isArabic ? 'أ.د. عادل سليمان محمد' : 'Prof. Dr. Adel Soliman',
                        style: GoogleFonts.cairo(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : ThebesColors.primaryDark,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: ThebesColors.gold.withAlpha(35),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: ThebesColors.gold),
                      ),
                      child: Text(
                        isArabic ? 'أستاذ دكتور' : 'Professor',
                        style: GoogleFonts.cairo(
                          color: ThebesColors.gold,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  isArabic
                      ? 'رئيس قسم تكنولوجيا المعلومات • الفصل الدراسي الأول 2026/2027'
                      : 'Head of IT Department • Fall Semester 2026/2027',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: isDark ? Colors.white60 : Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickMetricsGrid(bool isArabic, bool isDark) {
    final metrics = [
      {
        'title': isArabic ? 'المقررات المسندة' : 'Assigned Courses',
        'value': '4',
        'icon': Icons.menu_book_rounded,
        'color': ThebesColors.cyanAccent,
      },
      {
        'title': isArabic ? 'إجمالي الطلاب' : 'Total Students',
        'value': '482',
        'icon': Icons.groups_rounded,
        'color': ThebesColors.gold,
      },
      {
        'title': isArabic ? 'متوسط الحضور' : 'Avg Attendance',
        'value': '88.6%',
        'icon': Icons.pie_chart_rounded,
        'color': ThebesColors.emerald,
      },
      {
        'title': isArabic ? 'إنذارات الحرمان' : 'At-Risk Alerts',
        'value': '7',
        'icon': Icons.warning_rounded,
        'color': ThebesColors.error,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.1,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, i) {
        final m = metrics[i];
        final col = m['color'] as Color;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? ThebesColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? ThebesColors.darkCardBorder : ThebesColors.lightCardBorder,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: col.withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(m['icon'] as IconData, color: col, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      m['value'] as String,
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : ThebesColors.primaryDark,
                      ),
                    ),
                    Text(
                      m['title'] as String,
                      style: GoogleFonts.cairo(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLiveAttendanceProjectorHero(
    BuildContext context,
    StudentController controller,
    Map<String, dynamic> currentCourse,
    bool isArabic,
    bool isDark,
  ) {
    final isActive = controller.isFacultySessionActive;
    final pin = controller.activeFacultySessionCode;
    final token = 'THEBES-${currentCourse['code']}-$pin';
    final attendees = controller.facultySessionAttendees;
    final totalStudents = currentCourse['students'] as int;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: ThebesColors.royalCardGradient,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: ThebesColors.gold.withAlpha(120), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: ThebesColors.primary.withAlpha(120),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar with Course Picker & Live Status
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: isActive ? ThebesColors.emerald : Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (isActive ? ThebesColors.emerald : Colors.red).withAlpha(180),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isActive
                        ? (isArabic ? 'جلسة الحضور المباشرة (نشطة الآن)' : 'Live Session Active')
                        : (isArabic ? 'جلسة الحضور متوقفة' : 'Session Inactive'),
                    style: GoogleFonts.cairo(
                      color: isActive ? ThebesColors.emerald : Colors.redAccent,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              // Dropdown course selector
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: ThebesColors.gold.withAlpha(90)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    dropdownColor: const Color(0xFF0F1E33),
                    value: _selectedCourse,
                    icon: const Icon(Icons.arrow_drop_down, color: ThebesColors.gold),
                    style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    items: _courses.map((c) {
                      return DropdownMenuItem<String>(
                        value: c['code'] as String,
                        child: Text('${c['code']} - ${isArabic ? c['titleAr'] : c['titleEn']}'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedCourse = val);
                        controller.toggleFacultySession(courseCode: val);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Course and Hall Title
          Text(
            isArabic ? currentCourse['titleAr'] : currentCourse['titleEn'],
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: ThebesColors.gold),
              const SizedBox(width: 6),
              Text(
                currentCourse['hall'] as String,
                style: GoogleFonts.cairo(
                  color: ThebesColors.gold,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Main Projector Display: Large Dynamic QR Code + 6-Digit PIN
          if (isActive) ...[
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(80),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: QrImageView(
                  data: token,
                  version: QrVersions.auto,
                  size: 190,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Prominent 6-Digit PIN Display Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(60),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: ThebesColors.gold, width: 1.5),
              ),
              child: Column(
                children: [
                  Text(
                    isArabic ? 'كود التحضير الرقمي السريع للطلاب (PIN)' : 'Fast Lecture Attendance PIN',
                    style: GoogleFonts.cairo(
                      color: ThebesColors.gold,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${pin.substring(0, 3)}  ${pin.substring(3)}',
                        style: GoogleFonts.spaceMono(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(width: 14),
                      IconButton(
                        onPressed: () {
                          controller.refreshFacultySessionPin();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isArabic ? 'تم تجديد كود الجلسة لمنع الغش' : 'Session PIN refreshed'),
                              backgroundColor: ThebesColors.emerald,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.refresh_rounded, color: ThebesColors.gold, size: 24),
                        tooltip: isArabic ? 'تحديث الرمز' : 'Rotate Code',
                      ),
                    ],
                  ),
                  Text(
                    isArabic
                        ? 'متاح للطلاب إدخال هذا الرمز مباشرة في حال تعذر مسح الـ QR'
                        : 'Students can type this PIN directly if they cannot scan the QR',
                    style: GoogleFonts.cairo(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Real-Time Live Attendee Counter & Time remaining
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$attendees / $totalStudents',
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          isArabic ? 'طالب حاضر الآن في القاعة' : 'Students Present Now',
                          style: GoogleFonts.cairo(color: ThebesColors.emerald, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$_sessionMinutesRemaining دقيقة',
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          isArabic ? 'متبقي لصلاحية الجلسة' : 'Minutes Remaining',
                          style: GoogleFonts.cairo(color: ThebesColors.gold, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Action Buttons: View Attendees & Extend
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showLiveAttendeesDialog(context, isArabic, isDark, attendees),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: ThebesColors.gold),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: const Icon(Icons.people_alt_rounded, color: ThebesColors.gold, size: 18),
                    label: Text(
                      isArabic ? 'كشف الحضور اللحظي' : 'Live Roster',
                      style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() => _sessionMinutesRemaining += 5);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isArabic ? 'تم تمديد الجلسة بمقدار 5 دقائق' : 'Extended by 5 minutes'),
                          backgroundColor: ThebesColors.primary,
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white60),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: const Icon(Icons.more_time_rounded, color: Colors.white, size: 18),
                    label: Text(
                      isArabic ? 'تمديد (+5 د)' : 'Extend (+5m)',
                      style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // End Session Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  controller.toggleFacultySession();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isArabic ? 'تم إغلاق الجلسة واعتماد كشف الحضور بنجاح' : 'Session closed & saved'),
                      backgroundColor: ThebesColors.primary,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThebesColors.error,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.stop_circle_rounded),
                label: Text(
                  isArabic ? 'إغلاق الجلسة واعتماد الكشف' : 'End Session & Save Roster',
                  style: GoogleFonts.cairo(fontWeight: FontWeight.w900, fontSize: 14.5),
                ),
              ),
            ),
          ] else ...[
            // Inactive State View: Big Start Session Button
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    Icon(Icons.qr_code_2_rounded, size: 70, color: ThebesColors.gold.withAlpha(180)),
                    const SizedBox(height: 12),
                    Text(
                      isArabic ? 'لا توجد جلسة حضور نشطة حالياً لهذا المقرر' : 'No active attendance session',
                      style: GoogleFonts.cairo(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => controller.toggleFacultySession(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThebesColors.gold,
                        foregroundColor: ThebesColors.primaryDark,
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      icon: const Icon(Icons.play_circle_filled_rounded),
                      label: Text(
                        isArabic ? 'بدء جلسة الحضور الذكية للمحاضرة' : 'Start QR & PIN Session',
                        style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showLiveAttendeesDialog(BuildContext context, bool isArabic, bool isDark, int count) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F1E33) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
          border: Border.all(color: ThebesColors.gold.withAlpha(90)),
        ),
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey.withAlpha(90), borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isArabic ? 'كشف الطلاب الحاضرين في القاعة' : 'Present Students Roster',
                  style: GoogleFonts.cairo(fontSize: 17, fontWeight: FontWeight.w900, color: ThebesColors.gold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: ThebesColors.emerald.withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: ThebesColors.emerald),
                  ),
                  child: Text(
                    '$count ${isArabic ? "طالب" : "Students"}',
                    style: GoogleFonts.cairo(color: ThebesColors.emerald, fontWeight: FontWeight.w800, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.separated(
                itemCount: _gradeSheet.length,
                separatorBuilder: (_, index) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final s = _gradeSheet[i];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: ThebesColors.primary.withAlpha(30),
                      child: const Icon(Icons.person_rounded, color: ThebesColors.gold, size: 20),
                    ),
                    title: Text(
                      s['name'] as String,
                      style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: Text(
                      '${s['id']} • تم التسجيل 09:14 AM عبر PIN',
                      style: GoogleFonts.cairo(fontSize: 11.5, color: Colors.grey),
                    ),
                    trailing: const Icon(Icons.check_circle_rounded, color: ThebesColors.emerald, size: 22),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThebesColors.gold,
                  foregroundColor: ThebesColors.primaryDark,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  isArabic ? 'إغلاق الكشف' : 'Close',
                  style: GoogleFonts.cairo(fontWeight: FontWeight.w800, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursesManagementSection(
    BuildContext context,
    StudentController controller,
    bool isArabic,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isArabic ? 'إدارة المقررات ورصد الدرجات' : 'Course Management & Grades',
              style: GoogleFonts.cairo(fontSize: 17, fontWeight: FontWeight.w900),
            ),
            Text(
              '${_courses.length} ${isArabic ? "مقررات" : "Courses"}',
              style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _courses.length,
          separatorBuilder: (_, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final c = _courses[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? ThebesColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark ? ThebesColors.darkCardBorder : ThebesColors.lightCardBorder,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: ThebesColors.gold.withAlpha(30),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: ThebesColors.gold.withAlpha(100)),
                        ),
                        child: Text(
                          c['code'] as String,
                          style: GoogleFonts.spaceMono(
                            color: ThebesColors.gold,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        '${c['students']} ${isArabic ? "طالب" : "Students"} • ${c['attendanceRate']}% حضور',
                        style: GoogleFonts.cairo(fontSize: 11.5, color: Colors.grey, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isArabic ? c['titleAr'] : c['titleEn'],
                    style: GoogleFonts.cairo(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : ThebesColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showGradeEntryModal(context, c, isArabic, isDark),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ThebesColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.edit_note_rounded, size: 18),
                          label: Text(
                            isArabic ? 'رصد وتعديل الدرجات' : 'Enter Grades',
                            style: GoogleFonts.cairo(fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showBroadcastDialog(context, controller, c, isArabic, isDark),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: ThebesColors.gold.withAlpha(120)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.campaign_rounded, color: ThebesColors.gold, size: 18),
                          label: Text(
                            isArabic ? 'نشر إشعار للدفعة' : 'Broadcast',
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: isDark ? Colors.white : ThebesColors.primaryDark,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void _showGradeEntryModal(
    BuildContext context,
    Map<String, dynamic> course,
    bool isArabic,
    bool isDark,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.82,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F1E33) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              border: Border.all(color: ThebesColors.gold.withAlpha(90)),
            ),
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(color: Colors.grey.withAlpha(80), borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isArabic
                                ? 'شيت رصد درجات: ${course['titleAr']}'
                                : 'Grade Sheet: ${course['code']}',
                            style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w900, color: ThebesColors.gold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            isArabic ? 'أعمال السنة (20) • الميدتيرم (20) • الحضور (10)' : 'Year Work (20) • Midterm (20) • Attendance (10)',
                            style: GoogleFonts.cairo(fontSize: 11.5, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: _gradeSheet.length,
                    separatorBuilder: (_, index) => const Divider(height: 16),
                    itemBuilder: (context, idx) {
                      final s = _gradeSheet[idx];
                      final total = (s['attend'] as int) + (s['mid'] as int) + (s['work'] as int);
                      return Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s['name'] as String,
                                  style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13.5),
                                ),
                                Text(
                                  s['id'] as String,
                                  style: GoogleFonts.spaceMono(fontSize: 11, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          // Midterm Button
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Text('ميد:', style: GoogleFonts.cairo(fontSize: 11, color: Colors.grey)),
                                const SizedBox(width: 4),
                                Text(
                                  '${s['mid']}/20',
                                  style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: ThebesColors.primary),
                                ),
                              ],
                            ),
                          ),
                          // Total
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: total >= 40 ? ThebesColors.emerald.withAlpha(25) : ThebesColors.gold.withAlpha(25),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$total / 50',
                              style: GoogleFonts.cairo(
                                fontWeight: FontWeight.w900,
                                fontSize: 12.5,
                                color: total >= 40 ? ThebesColors.emerald : ThebesColors.gold,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThebesColors.gold,
                      foregroundColor: ThebesColors.primaryDark,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isArabic ? 'تم حفظ واعتماد درجات المقرر وإرسالها للكنترول الأكاديمي' : 'Grades saved & submitted to control'),
                          backgroundColor: ThebesColors.emerald,
                        ),
                      );
                    },
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: Text(
                      isArabic ? 'حفظ واعتماد الدرجات رسمياً' : 'Save & Submit Grades',
                      style: GoogleFonts.cairo(fontWeight: FontWeight.w900, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showBroadcastDialog(
    BuildContext context,
    StudentController controller,
    Map<String, dynamic> course,
    bool isArabic,
    bool isDark,
  ) {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF0F1E33) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.campaign_rounded, color: ThebesColors.gold),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                isArabic ? 'نشر تنبيه لمقرر ${course['code']}' : 'Broadcast to ${course['code']}',
                style: GoogleFonts.cairo(fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: isArabic ? 'عنوان الإشعار (مثال: موعد تسليم التكليف)' : 'Notification Title',
                filled: true,
                fillColor: isDark ? Colors.white10 : Colors.black.withAlpha(10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: bodyController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: isArabic ? 'تفاصيل التنبيه الموجه للطلاب...' : 'Notification Details...',
                filled: true,
                fillColor: isDark ? Colors.white10 : Colors.black.withAlpha(10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isArabic ? 'إلغاء' : 'Cancel', style: GoogleFonts.cairo()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ThebesColors.gold,
              foregroundColor: ThebesColors.primaryDark,
            ),
            onPressed: () {
              if (titleController.text.trim().isNotEmpty) {
                controller.broadcastCourseAnnouncement(
                  courseCode: course['code'] as String,
                  titleAr: titleController.text.trim(),
                  messageAr: bodyController.text.trim(),
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isArabic ? 'تم بث الإشعار لجميع طلاب المقرر فورياً 🔔' : 'Announcement broadcasted'),
                    backgroundColor: ThebesColors.emerald,
                  ),
                );
              }
            },
            child: Text(isArabic ? 'إرسال ونشر' : 'Send Now', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildAbsenceRiskSection(BuildContext context, bool isArabic, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF261214) : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ThebesColors.error.withAlpha(120)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: ThebesColors.error, size: 22),
              const SizedBox(width: 8),
              Text(
                isArabic ? 'متابعة إنذارات الغياب ونسب الحرمان (25%)' : 'Absence Warnings & Deprivation (25%)',
                style: GoogleFonts.cairo(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: ThebesColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isArabic
                ? 'يوجد 7 طلاب في مقرراتك اقتربوا أو تجاوزوا نسبة الغياب المقررة (25%). يمكنك إرسال إنذارات أو تصدير التقرير للشؤون الأكاديمية.'
                : '7 students in your courses have exceeded or approached the 25% threshold.',
            style: GoogleFonts.cairo(
              fontSize: 12,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isArabic ? 'تم إرسال إنذارات أكاديمية رسمية للطلاب المعنيين' : 'Official warnings sent'),
                      backgroundColor: ThebesColors.primary,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThebesColors.error,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
                icon: const Icon(Icons.send_rounded, size: 16),
                label: Text(
                  isArabic ? 'إرسال إنذارات للجميع' : 'Send All Warnings',
                  style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Academic Advising & Summer Course Governance
  Widget _buildAcademicAdvisingSection(
    BuildContext context,
    StudentController controller,
    bool isArabic,
    bool isDark,
  ) {
    final advising = controller.advisingSession;
    final allCourses = controller.availableSummerCourses;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? ThebesColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: ThebesColors.gold.withAlpha(isDark ? 80 : 120),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 50 : 15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ThebesColors.gold.withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.assignment_ind_rounded, color: ThebesColors.gold, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic ? 'بوابة الإرشاد الأكاديمي والتحكم بالتسجيل' : 'Academic Advising & Course Approval',
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : ThebesColors.primary,
                        ),
                      ),
                      Text(
                        isArabic
                            ? 'إدارة صلاحيات تسجيل المقررات الصيفية للطالب'
                            : 'Manage student registration access & approved courses',
                        style: GoogleFonts.cairo(fontSize: 11.5, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: controller.isRegistrationWindowOpen
                      ? ThebesColors.emerald.withAlpha(30)
                      : Colors.orange.withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: controller.isRegistrationWindowOpen
                        ? ThebesColors.emerald.withAlpha(120)
                        : Colors.orange.withAlpha(120),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      controller.isRegistrationWindowOpen ? Icons.lock_open_rounded : Icons.lock_outline_rounded,
                      size: 14,
                      color: controller.isRegistrationWindowOpen ? ThebesColors.emerald : Colors.orange,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      controller.isRegistrationWindowOpen
                          ? (isArabic ? 'التسجيل مفعل' : 'Registration Open')
                          : (isArabic ? 'التسجيل مغلق' : 'Registration Closed'),
                      style: GoogleFonts.cairo(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: controller.isRegistrationWindowOpen ? ThebesColors.emerald : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Student Info Strip
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0C1726) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isDark ? ThebesColors.darkCardBorder : const Color(0xFFCBD5E1)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: ThebesColors.primary,
                  child: Text(
                    'أ.ش',
                    style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: ThebesColors.gold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic ? controller.student.nameAr : controller.student.nameEn,
                        style: GoogleFonts.cairo(fontWeight: FontWeight.w800, fontSize: 13.5),
                      ),
                      Text(
                        '${isArabic ? "كود الطالب:" : "ID:"} ${controller.student.academicId} | ${isArabic ? "المعدل التراكمي:" : "CGPA:"} ${controller.student.gpa} | ${isArabic ? "الساعات المنجزة:" : "Hours:"} ${controller.student.completedHours}h',
                        style: GoogleFonts.cairo(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: ThebesColors.gold.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isArabic ? 'طالب مُرشَد' : 'Advisee',
                    style: GoogleFonts.cairo(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: ThebesColors.gold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Master Window Activation Switch
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: controller.isRegistrationWindowOpen
                  ? ThebesColors.emerald.withAlpha(15)
                  : ThebesColors.gold.withAlpha(12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: controller.isRegistrationWindowOpen
                    ? ThebesColors.emerald.withAlpha(60)
                    : ThebesColors.gold.withAlpha(60),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  controller.isRegistrationWindowOpen
                      ? Icons.check_circle_outline_rounded
                      : Icons.info_outline_rounded,
                  color: controller.isRegistrationWindowOpen ? ThebesColors.emerald : ThebesColors.gold,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic
                            ? 'تفعيل نافذة تسجيل المقررات الصيفية للطالب'
                            : 'Enable Summer Registration Window',
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                          color: isDark ? Colors.white : ThebesColors.primary,
                        ),
                      ),
                      Text(
                        controller.isRegistrationWindowOpen
                            ? (isArabic
                                ? 'النافذة مفتوحة حالياً: يمكن للطالب تسجيل المقررات المعتمدة أدناه'
                                : 'Window is active: Student can enroll in approved courses below')
                            : (isArabic
                                ? 'النافذة مغلقة: يظهر للطالب إشعار بمراجعة المرشد الأكاديمي'
                                : 'Window is closed: Student sees advisor contact requirement notice'),
                        style: GoogleFonts.cairo(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: controller.isRegistrationWindowOpen,
                  activeTrackColor: ThebesColors.emerald,
                  onChanged: (val) {
                    controller.setRegistrationWindowOpen(val);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          val
                              ? (isArabic
                                  ? 'تم فتح نافذة التسجيل للطالب بنجاح'
                                  : 'Registration window opened for student')
                              : (isArabic
                                  ? 'تم إغلاق نافذة التسجيل للطالب'
                                  : 'Registration window closed for student'),
                        ),
                        backgroundColor: val ? ThebesColors.emerald : ThebesColors.primary,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Course Checklist Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic ? 'المقررات المصرح بها للطالب' : 'Advisor-Approved Courses',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : ThebesColors.primary,
                    ),
                  ),
                  Text(
                    isArabic
                        ? 'فقط المقررات المفعلة تظهر في صفحة التسجيل الخاصة بالطالب'
                        : 'Only active courses are available in student enrollment portal',
                    style: GoogleFonts.cairo(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
              Text(
                '${controller.advisorApprovedCourses.length}/${allCourses.length} ${isArabic ? "معتمد" : "Approved"}',
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: ThebesColors.gold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Course Checklist Cards
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: allCourses.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final course = allCourses[index];
              final isApproved = controller.isCourseApprovedByAdvisor(course.code);

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark
                      ? (isApproved ? const Color(0xFF132338) : const Color(0xFF0F1A28))
                      : (isApproved ? const Color(0xFFF8FAFC) : const Color(0xFFF1F5F9)),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isApproved
                        ? ThebesColors.gold.withAlpha(120)
                        : (isDark ? ThebesColors.darkCardBorder : const Color(0xFFE2E8F0)),
                    width: isApproved ? 1.2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: ThebesColors.primaryDark,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        course.code,
                        style: GoogleFonts.spaceMono(
                          color: ThebesColors.gold,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.getLocalizedTitle(isArabic),
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.w700,
                              fontSize: 12.5,
                              color: isDark ? Colors.white : ThebesColors.primary,
                            ),
                          ),
                          Text(
                            '${course.creditHours} ${isArabic ? "ساعات معتمدة" : "Credit Hours"} | ${course.pricePerHour.toInt()} ${isArabic ? "ج.م/ساعة" : "EGP/hr"}',
                            style: GoogleFonts.cairo(fontSize: 10.5, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        controller.toggleAdvisorApprovedCourse(course.code);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isApproved ? ThebesColors.gold : Colors.grey.withAlpha(30),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isApproved ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
                              size: 14,
                              color: isApproved ? ThebesColors.primaryDark : Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isApproved
                                  ? (isArabic ? 'معتمد للطالب' : 'Approved')
                                  : (isArabic ? 'غير مصرح' : 'Disallowed'),
                              style: GoogleFonts.cairo(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: isApproved ? ThebesColors.primaryDark : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Advisor Guidance Notes & Edit Button
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0D1B2E) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ThebesColors.gold.withAlpha(40)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.rate_review_outlined, color: ThebesColors.gold, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic ? 'توصيات المرشد الأكاديمي للطالب:' : 'Academic Advisor Notes to Student:',
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 11.5,
                          color: ThebesColors.gold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        advising.getLocalizedNotes(isArabic),
                        style: GoogleFonts.cairo(fontSize: 11.5, color: isDark ? Colors.white70 : Colors.black87),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_note_rounded, size: 20, color: ThebesColors.gold),
                  tooltip: isArabic ? 'تعديل التوصيات' : 'Edit notes',
                  onPressed: () => _showAdvisorNotesDialog(context, controller, isArabic, isDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAdvisorNotesDialog(
    BuildContext context,
    StudentController controller,
    bool isArabic,
    bool isDark,
  ) {
    final arController = TextEditingController(text: controller.advisorNotesAr);
    final enController = TextEditingController(text: controller.advisorNotesEn);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF0F1E33) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.edit_note_rounded, color: ThebesColors.gold),
            const SizedBox(width: 8),
            Text(
              isArabic ? 'تعديل توجيهات المرشد الأكاديمي' : 'Edit Advising Guidance',
              style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: arController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: isArabic ? 'التوجيهات (بالعربية)' : 'Notes (Arabic)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: enController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: isArabic ? 'التوجيهات (بالإنجليزية)' : 'Notes (English)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ThebesColors.gold,
              foregroundColor: ThebesColors.primaryDark,
            ),
            onPressed: () {
              controller.updateAdvisorNotes(
                notesAr: arController.text.trim(),
                notesEn: enController.text.trim(),
              );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isArabic ? 'تم تحديث توجيهات المرشد' : 'Advisor notes updated'),
                  backgroundColor: ThebesColors.primary,
                ),
              );
            },
            child: Text(isArabic ? 'حفظ' : 'Save'),
          ),
        ],
      ),
    );
  }
}
