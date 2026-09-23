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

/// Apple / iOS Human Interface Guidelines Inspired Student Dashboard
/// Designed with generous whitespace, pristine cards, and refined typography.
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
      backgroundColor: isDark ? ThebesColors.darkBackground : const Color(0xFFF6F8FA),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1140),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: context.responsiveScreenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Apple-Style Header Bar
                  _buildHeader(context, locale, controller, student, isArabic, isDark),
                  const SizedBox(height: 16),

                  // Offline status notice if offline
                  if (!controller.isOnline) ...[
                    _buildOfflineNotice(context, controller, isArabic, isDark),
                    const SizedBox(height: 12),
                  ],

                  // 2. Absence Alert Pill (Apple-Style Urgent Banner)
                  if (controller.totalAbsenceWarnings > 0) ...[
                    _buildAbsenceAlertPill(context, controller, isArabic, isDark),
                    const SizedBox(height: 16),
                  ],

                  // 3. Featured Live Lecture Card (Apple Wallet / Music Player Style)
                  if (nextLecture != null) ...[
                    _buildLiveLectureCard(context, nextLecture, isArabic, isDark),
                    const SizedBox(height: 22),
                  ],

                  // 4. Academic Vitals Grid (Apple Health Style 4-Card Grid)
                  _buildAcademicVitals(context, controller, student, isArabic, isDark),
                  const SizedBox(height: 24),

                  // 5. Quick Services (Delightful Squircle Dock)
                  _buildQuickServicesDock(context, isArabic, isDark),
                  const SizedBox(height: 24),

                  // 6. Digital Student Pass (Apple Wallet Style Pass)
                  _buildDigitalStudentPass(context, student, isArabic, isDark),
                  const SizedBox(height: 24),

                  // 7. Campus Announcements (Apple News Style)
                  _buildAnnouncementsSection(context, controller, isArabic, isDark),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // 1. Header Bar
  // =========================================================================
  Widget _buildHeader(
    BuildContext context,
    LocaleProvider locale,
    StudentController controller,
    dynamic student,
    bool isArabic,
    bool isDark,
  ) {
    final nameColor = isDark ? Colors.white : ThebesColors.navy;
    final subtitleColor = isDark ? ThebesColors.slateLight : ThebesColors.slate;

    return Row(
      children: [
        // Profile Avatar with subtle Apple squircle/ring
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DigitalIdScreen()),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ThebesColors.orange, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: ThebesColors.orange.withAlpha(30),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: UserAvatarWidget(
                  size: context.responsiveValue(mobile: 48.0, tablet: 56.0),
                  initials: isArabic ? 'ر.م' : 'R.A',
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 13,
                  height: 13,
                  decoration: BoxDecoration(
                    color: controller.isOnline ? ThebesColors.mint : Colors.grey,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),

        // Greeting and Department
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      isArabic ? 'أهلاً، ${student.nameAr.split(" ")[0]}' : 'Hi, ${student.nameEn.split(" ")[0]}',
                      style: GoogleFonts.cairo(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: nameColor,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: ThebesColors.mint.withAlpha(25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isArabic ? 'منتظم' : 'Active',
                      style: GoogleFonts.cairo(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: ThebesColors.mint,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '${student.getLocalizedDepartment(isArabic)} • ${isArabic ? "الفرقة ${student.academicYear}" : "Year ${student.academicYear}"}',
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: subtitleColor,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // Notifications Button
        _buildCircularIconButton(
          context: context,
          icon: Icons.notifications_outlined,
          badgeCount: controller.unreadNotificationsCount,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NotificationsScreen()),
          ),
          isDark: isDark,
        ),
        const SizedBox(width: 8),

        // Settings / Options
        _buildCircularIconButton(
          context: context,
          icon: Icons.settings_outlined,
          onTap: () {
            if (onNavigateTab != null) {
              onNavigateTab!(4);
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            }
          },
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildCircularIconButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onTap,
    int badgeCount = 0,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDark ? ThebesColors.darkCard : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? ThebesColors.darkCardBorder : const Color(0xFFE5E7EB),
                width: 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x06000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, size: 20, color: isDark ? Colors.white70 : ThebesColors.navy),
          ),
          if (badgeCount > 0)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: ThebesColors.orange,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$badgeCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // =========================================================================
  // Offline Notice
  // =========================================================================
  Widget _buildOfflineNotice(
    BuildContext context,
    StudentController controller,
    bool isArabic,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_off_rounded, color: Color(0xFFD97706), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isArabic ? 'العمل بدون اتصال • البيانات محفوظة محلياً' : 'Offline Mode • Data cached locally',
              style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF92400E),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => controller.syncNow(),
            child: Text(
              isArabic ? 'تحديث' : 'Sync',
              style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: ThebesColors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // 2. Absence Alert Pill
  // =========================================================================
  Widget _buildAbsenceAlertPill(
    BuildContext context,
    StudentController controller,
    bool isArabic,
    bool isDark,
  ) {
    final warningCount = controller.totalAbsenceWarnings;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C1014) : ThebesColors.catAlertBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ThebesColors.catAlertText.withAlpha(90), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06EF4444),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ThebesColors.catAlertText.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.warning_amber_rounded, color: ThebesColors.catAlertText, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'إنذار نسبة الغياب الأكاديمي' : 'Attendance Risk Alert',
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: ThebesColors.catAlertText,
                  ),
                ),
                Text(
                  isArabic
                      ? 'يوجد $warningCount مقرر تجاوز أو قارب حد الـ 25% من الغياب.'
                      : '$warningCount course(s) near or exceeding the 25% absence limit.',
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    color: ThebesColors.catAlertText.withAlpha(220),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => onNavigateTab != null ? onNavigateTab!(2) : null,
            style: TextButton.styleFrom(
              foregroundColor: ThebesColors.catAlertText,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            ),
            child: Text(
              isArabic ? 'سجل الحضور' : 'Review',
              style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // 3. Featured Live Lecture Card (Apple Music / Wallet Style)
  // =========================================================================
  Widget _buildLiveLectureCard(
    BuildContext context,
    dynamic nextLecture,
    bool isArabic,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: ThebesColors.primaryHeaderGradient,
        borderRadius: BorderRadius.circular(22), // Apple large radius
        boxShadow: [
          BoxShadow(
            color: ThebesColors.navy.withAlpha(45),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Live indicator badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: ThebesColors.orange.withAlpha(40),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: ThebesColors.orange.withAlpha(120)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: ThebesColors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isArabic ? 'المحاضرة الحالية' : 'Live Now',
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Time badge
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.access_time_rounded, size: 14, color: Color(0xFFE8EEFF)),
                    const SizedBox(width: 5),
                    Text(
                      '${nextLecture.startTime} - ${nextLecture.endTime}',
                      style: GoogleFonts.cairo(
                        color: const Color(0xFFE8EEFF),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Course title
          Text(
            nextLecture.getLocalizedTitle(isArabic),
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),

          // Instructor & Room Wrap
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_pin_rounded, size: 16, color: Colors.white.withAlpha(180)),
                  const SizedBox(width: 6),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 160),
                    child: Text(
                      nextLecture.getLocalizedInstructor(isArabic),
                      style: GoogleFonts.cairo(
                        color: Colors.white.withAlpha(200),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.meeting_room_rounded, size: 14, color: ThebesColors.orangeLight),
                    const SizedBox(width: 4),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 140),
                      child: Text(
                        nextLecture.getLocalizedHall(isArabic),
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // One-tap Action Button
          Container(
            height: 48,
            decoration: BoxDecoration(
              gradient: ThebesColors.orangeCtaGradient,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: ThebesColors.orange.withAlpha(90),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  if (onNavigateTab != null) {
                    onNavigateTab!(2);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const QrAttendanceScreen()),
                    );
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.qr_code_scanner_rounded, size: 20, color: Colors.white),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        isArabic ? 'تسجيل الحضور الفوري (QR / كود)' : 'Instant Check-In (QR / PIN)',
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // 4. Academic Vitals Grid (Apple Health Style 4 Cards)
  // =========================================================================
  Widget _buildAcademicVitals(
    BuildContext context,
    StudentController controller,
    dynamic student,
    bool isArabic,
    bool isDark,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 580;
        final cardWidth = isWide ? (constraints.maxWidth - 36) / 4 : (constraints.maxWidth - 12) / 2;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            // 1. GPA Card
            _buildVitalCard(
              width: cardWidth,
              isDark: isDark,
              icon: Icons.auto_awesome_rounded,
              iconBg: ThebesColors.orangePale,
              iconColor: ThebesColors.orange,
              topLabel: isArabic ? 'المعدل التراكمي' : 'Cumulative GPA',
              mainValue: student.gpa.toStringAsFixed(2),
              subValue: '/ 4.00',
              statusBadge: isArabic ? 'مرتبة الشرف' : "Dean's List",
              statusColor: ThebesColors.orange,
            ),

            // 2. Attendance Card
            _buildVitalCard(
              width: cardWidth,
              isDark: isDark,
              icon: Icons.fact_check_rounded,
              iconBg: ThebesColors.catHealthBg,
              iconColor: ThebesColors.catHealthText,
              topLabel: isArabic ? 'نسبة الحضور' : 'Attendance Rate',
              mainValue: '${student.attendanceRate}%',
              subValue: '',
              statusBadge: isArabic ? 'منتظم' : 'Optimal',
              statusColor: ThebesColors.mint,
            ),

            // 3. Completed Hours Card
            _buildVitalCard(
              width: cardWidth,
              isDark: isDark,
              icon: Icons.school_rounded,
              iconBg: ThebesColors.sky,
              iconColor: ThebesColors.navy,
              topLabel: isArabic ? 'الساعات المنجزة' : 'Earned Credits',
              mainValue: '${student.completedHours}',
              subValue: '/ ${student.totalRequiredHours} hr',
              statusBadge: '${((student.completedHours / student.totalRequiredHours) * 100).toInt()}%',
              statusColor: ThebesColors.navy,
            ),

            // 4. Tuition Status Card
            _buildVitalCard(
              width: cardWidth,
              isDark: isDark,
              icon: Icons.account_balance_wallet_rounded,
              iconBg: controller.remainingTuition == 0 ? ThebesColors.catHealthBg : ThebesColors.orangePale,
              iconColor: controller.remainingTuition == 0 ? ThebesColors.catHealthText : ThebesColors.orange,
              topLabel: isArabic ? 'المصروفات' : 'Tuition Fees',
              mainValue: controller.remainingTuition == 0
                  ? (isArabic ? 'مسددة' : 'Paid')
                  : '${controller.remainingTuition.toInt()}',
              subValue: controller.remainingTuition == 0 ? '' : ' ج.م',
              statusBadge: controller.remainingTuition == 0
                  ? (isArabic ? 'خالصة' : 'Clear')
                  : (isArabic ? 'قسط ثان' : 'Due'),
              statusColor: controller.remainingTuition == 0 ? ThebesColors.mint : ThebesColors.orange,
            ),
          ],
        );
      },
    );
  }

  Widget _buildVitalCard({
    required double width,
    required bool isDark,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String topLabel,
    required String mainValue,
    required String subValue,
    required String statusBadge,
    required Color statusColor,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? ThebesColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(18), // Apple squircle
        border: Border.all(
          color: isDark ? ThebesColors.darkCardBorder : const Color(0xFFEAECF0),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06101828),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusBadge,
                    style: GoogleFonts.cairo(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            topLabel,
            style: GoogleFonts.cairo(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isDark ? ThebesColors.slateLight : ThebesColors.slate,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  mainValue,
                  style: GoogleFonts.cairo(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : ThebesColors.navy,
                    letterSpacing: -0.5,
                  ),
                ),
                if (subValue.isNotEmpty)
                  Text(
                    subValue,
                    style: GoogleFonts.cairo(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      color: ThebesColors.slate,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // 5. Quick Services Dock (Apple Squircle Grid)
  // =========================================================================
  Widget _buildQuickServicesDock(BuildContext context, bool isArabic, bool isDark) {
    final actions = [
      {
        'title': isArabic ? 'حضور QR' : 'QR Attendance',
        'icon': Icons.qr_code_scanner_rounded,
        'bg': ThebesColors.orangePale,
        'accent': ThebesColors.orange,
        'action': () {
          if (onNavigateTab != null) {
            onNavigateTab!(2);
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const QrAttendanceScreen()));
          }
        },
      },
      {
        'title': isArabic ? 'جدول المحاضرات' : 'Schedule',
        'icon': Icons.calendar_month_rounded,
        'bg': ThebesColors.sky,
        'accent': ThebesColors.navy,
        'action': () {
          if (onNavigateTab != null) {
            onNavigateTab!(1);
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ScheduleScreen()));
          }
        },
      },
      {
        'title': isArabic ? 'سداد المصروفات' : 'E-Payment',
        'icon': Icons.payment_rounded,
        'bg': ThebesColors.catHealthBg,
        'accent': ThebesColors.catHealthText,
        'action': () {
          if (onNavigateTab != null) {
            onNavigateTab!(3);
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ServicesScreen()));
          }
        },
      },
      {
        'title': isArabic ? 'كارنيه الكلية' : 'Digital ID',
        'icon': Icons.badge_rounded,
        'bg': ThebesColors.catMathBg,
        'accent': ThebesColors.catMathText,
        'action': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DigitalIdScreen())),
      },
      {
        'title': isArabic ? 'الدرجات والنتائج' : 'Grades & GPA',
        'icon': Icons.assessment_rounded,
        'bg': ThebesColors.catBusinessBg,
        'accent': ThebesColors.catBusinessText,
        'action': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GradesScreen())),
      },
      {
        'title': isArabic ? 'جدول الامتحانات' : 'Exams',
        'icon': Icons.assignment_rounded,
        'bg': ThebesColors.sky,
        'accent': ThebesColors.navy,
        'action': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExamScheduleScreen())),
      },
      {
        'title': isArabic ? 'لوحة الدكتور' : 'Faculty',
        'icon': Icons.school_rounded,
        'bg': ThebesColors.catLanguagesBg,
        'accent': ThebesColors.catLanguagesText,
        'action': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FacultyDashboard())),
      },
      {
        'title': isArabic ? 'دليل المقرات' : 'Campus Guide',
        'icon': Icons.location_on_rounded,
        'bg': ThebesColors.catLanguagesBg,
        'accent': ThebesColors.catLanguagesText,
        'action': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CampusGuideScreen())),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                isArabic ? 'الخدمات السريعة' : 'Quick Services',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : ThebesColors.navy,
                  letterSpacing: -0.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              isArabic ? 'عرض الكل' : 'See all',
              style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: ThebesColors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 98,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: actions.length,
            separatorBuilder: (_, index) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final a = actions[i];
              final tileBg = a['bg'] as Color? ?? ThebesColors.sky;
              final accentColor = a['accent'] as Color? ?? ThebesColors.navy;

              return InkWell(
                onTap: a['action'] as VoidCallback,
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  width: 90,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? ThebesColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark ? ThebesColors.darkCardBorder : const Color(0xFFEAECF0),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x04101828),
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: tileBg,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Icon(
                          a['icon'] as IconData,
                          color: accentColor,
                          size: 21,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        a['title'] as String,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : ThebesColors.slateDark,
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

  // =========================================================================
  // 6. Digital Student Pass (Apple Wallet Style)
  // =========================================================================
  Widget _buildDigitalStudentPass(
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
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: ThebesColors.primaryHeaderGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: ThebesColors.navy.withAlpha(40),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(20),
                shape: BoxShape.circle,
                border: Border.all(color: ThebesColors.orangeLight, width: 1.5),
              ),
              child: const Icon(Icons.badge_rounded, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic ? 'بطاقة الطالب الرقمية المعتمدة' : 'Digital Student Card (Pass)',
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isArabic
                        ? 'كود القيد: ${student.academicId} • رقم الجلوس: ${student.seatNumber}'
                        : 'ID: ${student.academicId} • Seat: ${student.seatNumber}',
                    style: GoogleFonts.cairo(
                      color: ThebesColors.orangeLight,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white70,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // 7. Latest Campus Announcements (Apple News Style)
  // =========================================================================
  Widget _buildAnnouncementsSection(
    BuildContext context,
    StudentController controller,
    bool isArabic,
    bool isDark,
  ) {
    final announcements = controller.announcements;
    if (announcements.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'أحدث الإعلانات والتنبيهات' : 'Campus Announcements',
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : ThebesColors.navy,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: announcements.take(3).length,
          separatorBuilder: (_, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final item = announcements[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? ThebesColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? ThebesColors.darkCardBorder : const Color(0xFFEAECF0),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x04101828),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: ThebesColors.sky,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.campaign_outlined, size: 20, color: ThebesColors.navy),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.getLocalizedTitle(isArabic),
                          style: GoogleFonts.cairo(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : ThebesColors.navy,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.getLocalizedContent(isArabic),
                          style: GoogleFonts.cairo(
                            fontSize: 11.5,
                            color: isDark ? ThebesColors.slateLight : ThebesColors.slate,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.date,
                          style: GoogleFonts.cairo(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: ThebesColors.slateLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
