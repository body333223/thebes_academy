import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:thebes_academy/core/theme/thebes_colors.dart';
import 'package:thebes_academy/core/localization/locale_provider.dart';
import 'package:thebes_academy/core/responsive/responsive_helper.dart';
import 'package:thebes_academy/core/widgets/user_avatar_widget.dart';
import 'package:thebes_academy/features/student/presentation/controllers/student_controller.dart';
import 'notifications_screen.dart';
import 'digital_id_screen.dart';
import 'qr_attendance_screen.dart';
import 'schedule_screen.dart';
import 'grades_screen.dart';
import 'services_screen.dart';
import 'exam_schedule_screen.dart';
import 'campus_guide_screen.dart';
import 'package:thebes_academy/features/settings/presentation/screens/settings_screen.dart';
import 'package:thebes_academy/features/faculty/presentation/screens/faculty_dashboard.dart';

class HomeDashboardScreen extends StatelessWidget {
  final Function(int)? onNavigateTab;

  const HomeDashboardScreen({super.key, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final isArabic = locale.isArabic;
    final isDark = locale.isDarkMode;
    final controller = context.watch<StudentController>();
    final student = controller.student;
    final nextLecture = controller.nextLecture;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1140),
            child: SingleChildScrollView(
              padding: context.responsiveScreenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Top Luxury Header
                  _buildHeader(context, locale, controller, student, isArabic, isDark),
                  const SizedBox(height: 14),

                  // Offline & Sync Status Banner
                  _buildOfflineSyncBanner(context, controller, isArabic, isDark),

                  // Absence Risk Banner (If any course has warnings)
                  if (controller.totalAbsenceWarnings > 0) ...[
                    _buildAbsenceAlertBanner(context, controller, isArabic, isDark),
                    const SizedBox(height: 14),
                  ],

                  const SizedBox(height: 6),

                  // 2. Next Lecture & QR Attendance Live Hero Banner
                  _buildLiveLectureHero(context, nextLecture, isArabic, isDark),
                  const SizedBox(height: 22),

                  // 3. Academic Vitals 4-Stat Row
                  _buildAcademicStatsGrid(context, controller, student, isArabic, isDark),
                  const SizedBox(height: 24),

                  // 4. Quick Action Floating Dock
                  _buildQuickActionDock(context, isArabic, isDark),
                  const SizedBox(height: 26),

                  // 5. Digital ID Smart Card Preview
                  _buildDigitalIdPreview(context, student, isArabic, isDark),
                  const SizedBox(height: 26),

                  // 6. Latest Campus Announcements
                  _buildAnnouncementsSection(context, controller, isArabic, isDark),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    LocaleProvider locale,
    StudentController controller,
    dynamic student,
    bool isArabic,
    bool isDark,
  ) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DigitalIdScreen()),
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ThebesColors.gold, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: ThebesColors.gold.withAlpha(60),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: UserAvatarWidget(
                  size: context.responsiveValue(mobile: 50.0, tablet: 58.0),
                  initials: isArabic ? 'أ.ش' : 'A.S',
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 13,
                  height: 13,
                  decoration: BoxDecoration(
                    color: controller.isOnline ? ThebesColors.emerald : Colors.grey,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 6,
                runSpacing: 2,
                children: [
                  Text(
                    isArabic ? 'أهلاً بك، ${student.nameAr.split(" ")[0]}' : 'Welcome, ${student.nameEn.split(" ")[0]}',
                    style: GoogleFonts.cairo(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : ThebesColors.primary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: ThebesColors.gold.withAlpha(30),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: ThebesColors.gold.withAlpha(90)),
                    ),
                    child: Text(
                      isArabic ? 'طالب منتظم' : 'Active',
                      style: GoogleFonts.cairo(
                        color: ThebesColors.gold,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                '${student.getLocalizedDepartment(isArabic)} • ${isArabic ? "الفرقة ${student.academicYear}" : "Year ${student.academicYear}"}',
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: isDark ? Colors.white60 : ThebesColors.lightTextSecondary,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        // Notifications Button with Unread Badge
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NotificationsScreen()),
          ),
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF13233A) : const Color(0xFFE9F0F8),
                  shape: BoxShape.circle,
                  border: Border.all(color: ThebesColors.gold.withAlpha(60)),
                ),
                child: const Icon(Icons.notifications_outlined, color: ThebesColors.gold, size: 20),
              ),
              if (controller.unreadNotificationsCount > 0)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: ThebesColors.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '${controller.unreadNotificationsCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
        // Doctor / Faculty Dashboard Switch Button
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FacultyDashboard()),
          ),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF13233A) : const Color(0xFFE9F0F8),
              shape: BoxShape.circle,
              border: Border.all(color: ThebesColors.gold.withAlpha(60)),
            ),
            child: const Icon(Icons.school_rounded, color: ThebesColors.gold, size: 20),
          ),
          tooltip: isArabic ? 'لوحة التحكم الأكاديمي' : 'Faculty Dashboard',
        ),
        // Settings / Profile Button
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SettingsScreen()),
          ),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF13233A) : const Color(0xFFE9F0F8),
              shape: BoxShape.circle,
              border: Border.all(color: ThebesColors.gold.withAlpha(60)),
            ),
            child: const Icon(Icons.settings_outlined, color: ThebesColors.gold, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildOfflineSyncBanner(
    BuildContext context,
    StudentController controller,
    bool isArabic,
    bool isDark,
  ) {
    if (controller.isOnline && !controller.isSyncing) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: !controller.isOnline
            ? (isDark ? const Color(0xFF332015) : const Color(0xFFFFF3E0))
            : (isDark ? const Color(0xFF102538) : const Color(0xFFE3F2FD)),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: !controller.isOnline ? ThebesColors.warning : ThebesColors.accentBlue,
        ),
      ),
      child: Row(
        children: [
          Icon(
            !controller.isOnline ? Icons.cloud_off_rounded : Icons.sync_rounded,
            size: 20,
            color: !controller.isOnline ? ThebesColors.warning : ThebesColors.accentBlue,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              !controller.isOnline
                  ? (isArabic
                      ? 'أنت تعمل بدون اتصال • البيانات محفوظة محلياً'
                      : 'Offline Mode • Data cached locally')
                  : (isArabic ? 'جاري مزامنة أحدث البيانات الجامعية...' : 'Syncing latest university data...'),
              style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
          if (!controller.isSyncing)
            GestureDetector(
              onTap: () => controller.syncNow(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: ThebesColors.gold,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isArabic ? 'تحديث الآن' : 'Sync Now',
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: ThebesColors.primaryNavy,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAbsenceAlertBanner(
    BuildContext context,
    StudentController controller,
    bool isArabic,
    bool isDark,
  ) {
    final warningCount = controller.totalAbsenceWarnings;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF3A181A) : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ThebesColors.error.withAlpha(140)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: ThebesColors.error, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'إنذار أكاديمي للغياب' : 'Academic Absence Warning',
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: ThebesColors.error,
                  ),
                ),
                Text(
                  isArabic
                      ? 'لديك $warningCount مقررات اقتربت من حد الحرمان (25%). تفقد سجل الحضور.'
                      : 'You have $warningCount courses near the 25% deprivation limit. Check attendance.',
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => onNavigateTab != null ? onNavigateTab!(2) : null,
            child: Text(
              isArabic ? 'عرض' : 'View',
              style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: ThebesColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveLectureHero(
    BuildContext context,
    dynamic nextLecture,
    bool isArabic,
    bool isDark,
  ) {
    if (nextLecture == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        gradient: ThebesColors.royalCardGradient,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ThebesColors.gold.withAlpha(100), width: 1.3),
        boxShadow: [
          BoxShadow(
            color: ThebesColors.primary.withAlpha(90),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.withAlpha(40),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.redAccent.withAlpha(120)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        isArabic ? 'المحاضرة الحالية' : 'Live Lecture',
                        style: GoogleFonts.cairo(
                          color: Colors.redAccent,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.access_time_filled_rounded, color: ThebesColors.gold, size: 15),
                  const SizedBox(width: 5),
                  Text(
                    '${nextLecture.startTime} - ${nextLecture.endTime}',
                    style: GoogleFonts.cairo(
                      color: ThebesColors.gold,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            nextLecture.getLocalizedTitle(isArabic),
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.person_pin_rounded, size: 16, color: Colors.white.withAlpha(180)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  nextLecture.getLocalizedInstructor(isArabic),
                  style: GoogleFonts.cairo(
                    color: Colors.white.withAlpha(200),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.meeting_room_rounded, size: 16, color: ThebesColors.gold),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  nextLecture.getLocalizedHall(isArabic),
                  style: GoogleFonts.cairo(
                    color: ThebesColors.gold,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Direct Action Button to Scan QR Code
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: ThebesColors.gold,
                foregroundColor: ThebesColors.primaryDark,
                elevation: 4,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                if (onNavigateTab != null) {
                  onNavigateTab!(2); // Navigate to QR Attendance tab
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QrAttendanceScreen()),
                  );
                }
              },
              icon: const Icon(Icons.qr_code_scanner_rounded, size: 20),
              label: Text(
                isArabic ? 'سجل حضورك الآن (كود PIN أو باركود QR)' : 'Register Attendance (PIN or QR)',
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicStatsGrid(
    BuildContext context,
    StudentController controller,
    dynamic student,
    bool isArabic,
    bool isDark,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 580;
        final itemWidth = isWide ? (constraints.maxWidth - 36) / 4 : (constraints.maxWidth - 12) / 2;

        final stats = [
          {
            'title': isArabic ? 'المعدل التراكمي' : 'Cumulative GPA',
            'value': student.gpa.toStringAsFixed(2),
            'sub': isArabic ? 'ممتاز مع مرتبة الشرف' : 'Excellent Honors',
            'icon': Icons.star_rounded,
            'color': ThebesColors.gold,
          },
          {
            'title': isArabic ? 'نسبة الحضور' : 'Attendance Rate',
            'value': '${student.attendanceRate}%',
            'sub': isArabic ? 'سجل مثالي' : 'Good Standing',
            'icon': Icons.verified_rounded,
            'color': ThebesColors.emerald,
          },
          {
            'title': isArabic ? 'الساعات المنجزة' : 'Completed Hours',
            'value': '${student.completedHours} / ${student.totalRequiredHours}',
            'sub': isArabic ? 'ساعة معتمدة' : 'Credit Hours',
            'icon': Icons.school_rounded,
            'color': ThebesColors.cyanAccent,
          },
          {
            'title': isArabic ? 'المصروفات' : 'Tuition Fees',
            'value': controller.remainingTuition == 0
                ? (isArabic ? 'مسددة بالكامل' : 'Fully Paid')
                : '${controller.remainingTuition.toInt()} ج.م',
            'sub': controller.remainingTuition == 0
                ? (isArabic ? 'لا توجد مستحقات' : 'Zero balance')
                : (isArabic ? 'متبقي القسط الثاني' : 'Pending 2nd'),
            'icon': Icons.account_balance_wallet_rounded,
            'color': controller.remainingTuition == 0 ? ThebesColors.emerald : ThebesColors.warning,
          },
        ];

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: stats.map((s) {
            return Container(
              width: itemWidth,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? ThebesColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark ? ThebesColors.darkCardBorder : ThebesColors.lightCardBorder,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(isDark ? 30 : 10),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: (s['color'] as Color).withAlpha(25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(s['icon'] as IconData, color: s['color'] as Color, size: 20),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    s['value'] as String,
                    style: GoogleFonts.cairo(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : ThebesColors.primary,
                    ),
                  ),
                  Text(
                    s['title'] as String,
                    style: GoogleFonts.cairo(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    s['sub'] as String,
                    style: GoogleFonts.cairo(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: s['color'] as Color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildQuickActionDock(BuildContext context, bool isArabic, bool isDark) {
    final actions = [
      {
        'title': isArabic ? 'حضور QR / كود' : 'QR / PIN',
        'icon': Icons.qr_code_scanner_rounded,
        'color': ThebesColors.gold,
        'action': () {
          if (onNavigateTab != null) {
            onNavigateTab!(2);
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const QrAttendanceScreen()));
          }
        },
      },
      {
        'title': isArabic ? 'لوحة الدكتور' : 'Faculty',
        'icon': Icons.school_rounded,
        'color': ThebesColors.emerald,
        'action': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FacultyDashboard())),
      },
      {
        'title': isArabic ? 'كارنيه الكلية' : 'Digital ID',
        'icon': Icons.badge_rounded,
        'color': ThebesColors.cyanAccent,
        'action': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DigitalIdScreen())),
      },
      {
        'title': isArabic ? 'جدول المحاضرات' : 'Schedule',
        'icon': Icons.calendar_month_rounded,
        'color': const Color(0xFF8B5CF6),
        'action': () {
          if (onNavigateTab != null) {
            onNavigateTab!(1);
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ScheduleScreen()));
          }
        },
      },
      {
        'title': isArabic ? 'المعدل والنتائج' : 'Grades & GPA',
        'icon': Icons.assessment_rounded,
        'color': ThebesColors.emerald,
        'action': () {
          if (onNavigateTab != null) {
            onNavigateTab!(3);
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const GradesScreen()));
          }
        },
      },
      {
        'title': isArabic ? 'سداد المصروفات' : 'E-Payment',
        'icon': Icons.payment_rounded,
        'color': const Color(0xFFEC4899),
        'action': () {
          if (onNavigateTab != null) {
            onNavigateTab!(4);
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ServicesScreen()));
          }
        },
      },
      {
        'title': isArabic ? 'جدول الامتحانات' : 'Exams',
        'icon': Icons.assignment_rounded,
        'color': ThebesColors.gold,
        'action': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExamScheduleScreen())),
      },
      {
        'title': isArabic ? 'دليل المقرات' : 'Campus Guide',
        'icon': Icons.location_on_rounded,
        'color': ThebesColors.cyanAccent,
        'action': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CampusGuideScreen())),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'الخدمات السريعة' : 'Quick Services',
          style: GoogleFonts.cairo(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 94,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: actions.length,
            separatorBuilder: (_, index) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final a = actions[i];
              return InkWell(
                onTap: a['action'] as VoidCallback,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 86,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? ThebesColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? ThebesColors.darkCardBorder : ThebesColors.lightCardBorder,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: (a['color'] as Color).withAlpha(25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(a['icon'] as IconData, color: a['color'] as Color, size: 22),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        a['title'] as String,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDigitalIdPreview(
    BuildContext context,
    dynamic student,
    bool isArabic,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DigitalIdScreen()),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0F2647), Color(0xFF193B6E), Color(0xFF10284D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: ThebesColors.gold.withAlpha(90)),
          boxShadow: [
            BoxShadow(
              color: ThebesColors.primary.withAlpha(70),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: ThebesColors.gold.withAlpha(30),
                shape: BoxShape.circle,
                border: Border.all(color: ThebesColors.gold, width: 1.5),
              ),
              child: const Icon(Icons.badge_rounded, color: ThebesColors.gold, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic ? 'بطاقة الطالب الرقمية الموحدة (Smart Card)' : 'Digital Student Smart Card',
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    isArabic
                        ? 'كود الطالب: ${student.academicId} • رقم الجلوس: ${student.seatNumber}'
                        : 'ID: ${student.academicId} • Seat: ${student.seatNumber}',
                    style: GoogleFonts.cairo(
                      color: ThebesColors.gold,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isArabic ? Icons.arrow_back_ios_new_rounded : Icons.arrow_forward_ios_rounded,
              color: Colors.white70,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementsSection(
    BuildContext context,
    StudentController controller,
    bool isArabic,
    bool isDark,
  ) {
    final announcements = controller.announcements;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                isArabic ? 'إعلانات وأخبار الأكاديمية' : 'Academy Announcements',
                style: GoogleFonts.cairo(fontSize: 17, fontWeight: FontWeight.w800),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              isArabic ? 'عرض الأرشيف' : 'Archive',
              style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: ThebesColors.gold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...announcements.map((ann) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? ThebesColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: ann.isImportant
                    ? ThebesColors.gold.withAlpha(120)
                    : (isDark ? ThebesColors.darkCardBorder : ThebesColors.lightCardBorder),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: ann.isImportant
                        ? ThebesColors.gold.withAlpha(30)
                        : ThebesColors.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    ann.isImportant ? Icons.campaign_rounded : Icons.article_rounded,
                    color: ann.isImportant ? ThebesColors.gold : ThebesColors.info,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: ThebesColors.primary.withAlpha(15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                ann.getLocalizedCategory(isArabic),
                                style: GoogleFonts.cairo(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: ThebesColors.gold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            ann.date,
                            style: GoogleFonts.cairo(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        ann.getLocalizedTitle(isArabic),
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ann.getLocalizedContent(isArabic),
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
