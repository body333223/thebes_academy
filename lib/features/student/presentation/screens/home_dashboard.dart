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
import 'profile_screen.dart';
import 'package:thebes_academy/features/settings/presentation/screens/settings_screen.dart';
import 'package:thebes_academy/features/student/domain/entities/academic_entities.dart';

/// Apple / iOS Human Interface Guidelines Inspired Student Dashboard
/// Designed with generous whitespace, pristine cards, and refined typography.
class HomeDashboardScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;

  const HomeDashboardScreen({super.key, this.onNavigateTab});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  bool _isAbsenceAlertDismissed = false;
  int _selectedLectureIndex = 0;

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final isArabic = locale.isArabic;
    final isDark = locale.isDarkMode;
    final controller = context.watch<StudentController>();
    final student = controller.student;
    final consecutiveLectures = controller.todayConsecutiveLectures;

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

                  // 2. Absence Alert Pill (Apple-Style Dismissible Banner)
                  if (!_isAbsenceAlertDismissed && controller.totalAbsenceWarnings > 0) ...[
                    _buildAbsenceAlertPill(context, controller, isArabic, isDark),
                    const SizedBox(height: 16),
                  ],

                  // 3. Digital Student Pass (Chic Executive Card) - Placed above lectures banner
                  _buildDigitalStudentPass(context, student, isArabic, isDark),
                  const SizedBox(height: 18),

                  // 4. Featured Consecutive Lectures Card (Apple Wallet / Music Player Style)
                  if (consecutiveLectures.isNotEmpty) ...[
                    _buildConsecutiveLecturesCard(context, consecutiveLectures, isArabic, isDark),
                    const SizedBox(height: 22),
                  ],

                  // 5. Academic Vitals Grid (Apple Health Style 4-Card Grid)
                  _buildAcademicVitals(context, controller, student, isArabic, isDark),
                  const SizedBox(height: 24),

                  // 6. Quick Services (Delightful Squircle Dock)
                  _buildQuickServicesDock(context, isArabic, isDark),
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
        // Profile Avatar with subtle Apple squircle/ring -> Opens Full Student Profile
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfileScreen()),
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
                  size: context.responsiveValue(mobile: 46.0, tablet: 54.0),
                  initials: isArabic ? 'ر.م' : 'R.A',
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 12,
                  height: 12,
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
        const SizedBox(width: 12),

        // Greeting and Department (Tappable to Profile)
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        isArabic ? 'أهلاً، ${student.nameAr.split(" ")[0]}' : 'Hi, ${student.nameEn.split(" ")[0]}',
                        style: GoogleFonts.almarai(
                          fontSize: 16.5,
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
                        style: GoogleFonts.almarai(
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
                  style: GoogleFonts.almarai(
                    fontSize: 11.5,
                    color: subtitleColor,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Modern Segmented Pill Controls Dock (Language & Dark Mode)
        _buildModernControlsDock(context, locale, isDark),
        const SizedBox(width: 8),

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
      ],
    );
  }

  // Modern segmented pill dock for quick Language & Theme switching
  Widget _buildModernControlsDock(BuildContext context, LocaleProvider locale, bool isDark) {
    return Container(
      height: 38,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isDark ? ThebesColors.elevatedDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? ThebesColors.hairlineDark : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha(40) : const Color(0x08000000),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Language Capsule Button
          InkWell(
            onTap: () => locale.toggleLocale(),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withAlpha(12) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                locale.isArabic ? 'EN' : 'عربي',
                style: GoogleFonts.almarai(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: isDark ? ThebesColors.orangeLight : ThebesColors.navy,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: 1,
            height: 14,
            color: isDark ? ThebesColors.hairlineDark : const Color(0xFFE2E8F0),
          ),
          // Dark Mode Toggle Button with dynamic icon
          InkWell(
            onTap: () => locale.toggleTheme(),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: isDark ? ThebesColors.orange.withAlpha(25) : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                size: 16,
                color: isDark ? const Color(0xFFFFB74D) : ThebesColors.navy,
              ),
            ),
          ),
        ],
      ),
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
              style: GoogleFonts.almarai(
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
              style: GoogleFonts.almarai(
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
  // 2. Absence Alert Pill (Apple-Style Subtle & Dismissible)
  // =========================================================================
  Widget _buildAbsenceAlertPill(
    BuildContext context,
    StudentController controller,
    bool isArabic,
    bool isDark,
  ) {
    final warningCount = controller.totalAbsenceWarnings;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C1417) : const Color(0xFFFFF5F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF882029) : const Color(0xFFFECDD3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withAlpha(isDark ? 30 : 12),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: ThebesColors.orange.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: ThebesColors.orange,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isArabic ? 'إنذار نسبة الغياب الأكاديمي' : 'Attendance Notice',
                  style: GoogleFonts.almarai(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFFFFB4BA) : const Color(0xFF9F1239),
                  ),
                ),
                Text(
                  isArabic
                      ? 'يوجد $warningCount مقرر تجاوز أو قارب حد الـ 25% من الغياب.'
                      : '$warningCount course(s) near 25% absence limit.',
                  style: GoogleFonts.almarai(
                    fontSize: 11,
                    color: isDark ? const Color(0xFFFCA5A5) : const Color(0xFFBE123C),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          // Review button
          InkWell(
            onTap: () {
              if (widget.onNavigateTab != null) {
                widget.onNavigateTab!(2);
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const QrAttendanceScreen()));
              }
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withAlpha(15) : const Color(0xFFFFE4E6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                isArabic ? 'مراجعة' : 'Review',
                style: GoogleFonts.almarai(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF9F1239),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          // Dismiss (X) button
          GestureDetector(
            onTap: () {
              setState(() {
                _isAbsenceAlertDismissed = true;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withAlpha(20) : Colors.black.withAlpha(10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close_rounded,
                size: 16,
                color: isDark ? Colors.white70 : const Color(0xFF9F1239),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // 3. Featured Consecutive Lectures Card with 1-Minute Gate
  // =========================================================================
  bool _isLectureAttendanceUnlocked(CourseScheduleEntity lecture) {
    try {
      final clean = lecture.startTime.trim();
      final isPM = clean.contains('م') || clean.toUpperCase().contains('PM');
      final isAM = clean.contains('ص') || clean.toUpperCase().contains('AM');
      final match = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(clean);
      if (match != null) {
        int hour = int.parse(match.group(1)!);
        final minute = int.parse(match.group(2)!);
        if (isPM && hour < 12) hour += 12;
        if (isAM && hour == 12) hour = 0;
        final now = DateTime.now();
        final lectureStart = DateTime(now.year, now.month, now.day, hour, minute);
        // Unlocks strictly after 1 minute has elapsed from lecture start time:
        final unlockTime = lectureStart.add(const Duration(minutes: 1));
        return now.isAfter(unlockTime);
      }
    } catch (_) {}
    return !lecture.isUpcoming;
  }

  String _getAttendanceUnlockTimeString(CourseScheduleEntity lecture, bool isArabic) {
    try {
      final clean = lecture.startTime.trim();
      final isPM = clean.contains('م') || clean.toUpperCase().contains('PM');
      final match = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(clean);
      if (match != null) {
        int hour = int.parse(match.group(1)!);
        int minute = int.parse(match.group(2)!);
        minute += 1;
        if (minute >= 60) {
          hour += 1;
          minute = 0;
        }
        final suffix = isPM ? (isArabic ? 'م' : 'PM') : (isArabic ? 'ص' : 'AM');
        final hStr = hour.toString().padLeft(2, '0');
        final mStr = minute.toString().padLeft(2, '0');
        return '$hStr:$mStr $suffix';
      }
    } catch (_) {}
    return isArabic ? 'بعد دقيقة من البدء' : '1 min after start';
  }

  Widget _buildConsecutiveLecturesCard(
    BuildContext context,
    List<CourseScheduleEntity> lectures,
    bool isArabic,
    bool isDark,
  ) {
    if (lectures.isEmpty) return const SizedBox.shrink();
    if (_selectedLectureIndex >= lectures.length) {
      _selectedLectureIndex = 0;
    }
    final currentLecture = lectures[_selectedLectureIndex];
    final totalLectures = lectures.length;
    final isUnlocked = _isLectureAttendanceUnlocked(currentLecture);
    final unlockTimeString = _getAttendanceUnlockTimeString(currentLecture, isArabic);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: ThebesColors.primaryHeaderGradient,
        borderRadius: BorderRadius.circular(22),
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
          // Header Row: Status Badge & Pagination / Switcher & Time Badge
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Live or Consecutive Badge
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: (_selectedLectureIndex == 0 ? ThebesColors.orange : ThebesColors.cobalt).withAlpha(45),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: (_selectedLectureIndex == 0 ? ThebesColors.orange : ThebesColors.cobalt).withAlpha(140),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: _selectedLectureIndex == 0 ? ThebesColors.orange : Colors.cyanAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _selectedLectureIndex == 0
                                ? (isArabic ? 'المحاضرة الحالية' : 'Live Now')
                                : (isArabic ? 'المحاضرة المتتالية' : 'Next Lecture'),
                            style: GoogleFonts.almarai(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (totalLectures > 1) ...[
                      const SizedBox(width: 8),
                      // Consecutive Lecture Counter / Switcher
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(20),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_selectedLectureIndex > 0)
                              GestureDetector(
                                onTap: () => setState(() => _selectedLectureIndex--),
                                child: const Icon(Icons.chevron_left_rounded, color: Colors.white, size: 16),
                              ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                '${_selectedLectureIndex + 1}/$totalLectures',
                                style: GoogleFonts.almarai(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            if (_selectedLectureIndex < totalLectures - 1)
                              GestureDetector(
                                onTap: () => setState(() => _selectedLectureIndex++),
                                child: const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 16),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(width: 12),

                // Time badge
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.access_time_rounded, size: 14, color: Color(0xFFE8EEFF)),
                    const SizedBox(width: 5),
                    Text(
                      '${currentLecture.startTime} - ${currentLecture.endTime}',
                      style: GoogleFonts.almarai(
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
            currentLecture.getLocalizedTitle(isArabic),
            style: GoogleFonts.almarai(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),

          // Instructor & Room & Type Wrap
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
                      currentLecture.getLocalizedInstructor(isArabic),
                      style: GoogleFonts.almarai(
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
                        currentLecture.getLocalizedHall(isArabic),
                        style: GoogleFonts.almarai(
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  currentLecture.type == LectureType.lab
                      ? (isArabic ? 'سكشن عملي' : 'Lab')
                      : (isArabic ? 'محاضرة نظري' : 'Lecture'),
                  style: GoogleFonts.almarai(
                    color: Colors.white.withAlpha(220),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Attendance Button with 1-Minute Gate:
          // Unlocks after 1 minute has elapsed from lecture start time!
          if (isUnlocked)
            _buildUnlockedAttendanceButton(context, currentLecture, isArabic)
          else
            _buildLockedAttendanceButton(context, currentLecture, unlockTimeString, isArabic),
        ],
      ),
    );
  }

  Widget _buildUnlockedAttendanceButton(
    BuildContext context,
    CourseScheduleEntity lecture,
    bool isArabic,
  ) {
    return Container(
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
            if (widget.onNavigateTab != null) {
              widget.onNavigateTab!(2);
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
                  isArabic ? 'تسجيل الحضور الفوري (متاح الآن)' : 'Instant Check-In (Available Now)',
                  style: GoogleFonts.almarai(
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
    );
  }

  Widget _buildLockedAttendanceButton(
    BuildContext context,
    CourseScheduleEntity lecture,
    String unlockTimeString,
    bool isArabic,
  ) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(20),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withAlpha(40), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.lock_clock_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isArabic
                            ? 'تسجيل الحضور مغلق الآن • يفتح تلقائياً بعد مرور أول دقيقة من موعد المحاضرة ($unlockTimeString).'
                            : 'Attendance locked • Opens 1 min after lecture start ($unlockTimeString).',
                        style: GoogleFonts.almarai(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                backgroundColor: ThebesColors.navy,
                duration: const Duration(seconds: 4),
                action: SnackBarAction(
                  label: isArabic ? 'فتح تجريبي' : 'Dev Unlock',
                  textColor: ThebesColors.orange,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const QrAttendanceScreen()),
                    );
                  },
                ),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_clock_rounded, size: 18, color: Color(0xFFFFD166)),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  isArabic
                      ? 'يفتح تسجيل الحضور: $unlockTimeString (بعد دقيقة من البدء)'
                      : 'Attendance opens: $unlockTimeString (1m after start)',
                  style: GoogleFonts.almarai(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.white.withAlpha(230),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
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
                    style: GoogleFonts.almarai(
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
            style: GoogleFonts.almarai(
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
                  style: GoogleFonts.almarai(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : ThebesColors.navy,
                    letterSpacing: -0.5,
                  ),
                ),
                if (subValue.isNotEmpty)
                  Text(
                    subValue,
                    style: GoogleFonts.almarai(
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
          if (widget.onNavigateTab != null) {
            widget.onNavigateTab!(2);
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
          if (widget.onNavigateTab != null) {
            widget.onNavigateTab!(1);
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
          if (widget.onNavigateTab != null) {
            widget.onNavigateTab!(3);
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
        'title': isArabic ? 'طلبات الطلاب' : 'Requests',
        'icon': Icons.description_rounded,
        'bg': const Color(0xFFEDE9FE),
        'accent': const Color(0xFF7C3AED),
        'action': () {
          if (widget.onNavigateTab != null) {
            widget.onNavigateTab!(3);
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ServicesScreen()));
          }
        },
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
                style: GoogleFonts.almarai(
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
            // Functional "عرض الكل / See all" button
            InkWell(
              onTap: () => _showAllServicesSheet(context, isArabic, isDark),
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isArabic ? 'عرض الكل' : 'See all',
                      style: GoogleFonts.almarai(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: ThebesColors.orange,
                      ),
                    ),
                    const SizedBox(width: 3),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 11, color: ThebesColors.orange),
                  ],
                ),
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
                        style: GoogleFonts.almarai(
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
  // All Services Modal Sheet (Opened via "عرض الكل")
  // =========================================================================
  void _showAllServicesSheet(BuildContext context, bool isArabic, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final allServices = [
          {
            'title': isArabic ? 'حضور المحاضرات (QR & PIN)' : 'Smart Attendance',
            'desc': isArabic ? 'تسجيل الحضور بالكاميرا أو كود الجلسة' : 'Log attendance via QR or PIN',
            'icon': Icons.qr_code_scanner_rounded,
            'color': ThebesColors.orange,
            'bg': ThebesColors.orangePale,
            'action': () {
              Navigator.pop(ctx);
              if (widget.onNavigateTab != null) {
                widget.onNavigateTab!(2);
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const QrAttendanceScreen()));
              }
            },
          },
          {
            'title': isArabic ? 'جدول المحاضرات والسكاشن' : 'Weekly Schedule',
            'desc': isArabic ? 'مواعيد المحاضرات والقاعات والمعامل' : 'Lecture timings, halls & labs',
            'icon': Icons.calendar_month_rounded,
            'color': ThebesColors.navy,
            'bg': ThebesColors.sky,
            'action': () {
              Navigator.pop(ctx);
              if (widget.onNavigateTab != null) {
                widget.onNavigateTab!(1);
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ScheduleScreen()));
              }
            },
          },
          {
            'title': isArabic ? 'سداد المصروفات والرسوم' : 'E-Payment & Fees',
            'desc': isArabic ? 'أقساط الرسوم الدراسية والدفع الإلكتروني' : 'Tuition fees & online payment',
            'icon': Icons.payment_rounded,
            'color': ThebesColors.catHealthText,
            'bg': ThebesColors.catHealthBg,
            'action': () {
              Navigator.pop(ctx);
              if (widget.onNavigateTab != null) {
                widget.onNavigateTab!(3);
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ServicesScreen()));
              }
            },
          },
          {
            'title': isArabic ? 'كارنيه الكلية الرقمي' : 'Digital Student ID',
            'desc': isArabic ? 'بطاقة إلكترونية معتمدة بالباركود' : 'Verified ID card with barcode',
            'icon': Icons.badge_rounded,
            'color': ThebesColors.catMathText,
            'bg': ThebesColors.catMathBg,
            'action': () {
              Navigator.pop(ctx);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const DigitalIdScreen()));
            },
          },
          {
            'title': isArabic ? 'الدرجات والسجل التراكمي' : 'Grades & GPA',
            'desc': isArabic ? 'نتائج المقررات ومعدل الـ GPA الفصلي' : 'Semester grades & GPA transcript',
            'icon': Icons.assessment_rounded,
            'color': ThebesColors.catBusinessText,
            'bg': ThebesColors.catBusinessBg,
            'action': () {
              Navigator.pop(ctx);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const GradesScreen()));
            },
          },
          {
            'title': isArabic ? 'جدول الامتحانات واللجان' : 'Exams & Seating',
            'desc': isArabic ? 'مواعيد الاختبارات ورقم الجلوس والقاعة' : 'Exam schedule, seat & hall',
            'icon': Icons.assignment_rounded,
            'color': const Color(0xFF0284C7),
            'bg': const Color(0xFFE0F2FE),
            'action': () {
              Navigator.pop(ctx);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ExamScheduleScreen()));
            },
          },
          {
            'title': isArabic ? 'دليل المقرات والمدرجات' : 'Campus Guide',
            'desc': isArabic ? 'خريطة المباني والمعامل والمدرجات' : 'Campus buildings, labs & halls',
            'icon': Icons.location_on_rounded,
            'color': ThebesColors.catLanguagesText,
            'bg': ThebesColors.catLanguagesBg,
            'action': () {
              Navigator.pop(ctx);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CampusGuideScreen()));
            },
          },
          {
            'title': isArabic ? 'الطلبات والخدمات الطلابية' : 'Student E-Requests',
            'desc': isArabic ? 'إثبات قيد، بيان درجات، التماسات' : 'Enrollment proof, transcripts & appeals',
            'icon': Icons.description_rounded,
            'color': const Color(0xFF7C3AED),
            'bg': const Color(0xFFEDE9FE),
            'action': () {
              Navigator.pop(ctx);
              if (widget.onNavigateTab != null) {
                widget.onNavigateTab!(3);
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ServicesScreen()));
              }
            },
          },
          {
            'title': isArabic ? 'الإعلانات والأنشطة الأكاديمية' : 'Announcements',
            'desc': isArabic ? 'تنبيهات شؤون الطلاب والأنشطة' : 'Student affairs news & events',
            'icon': Icons.campaign_rounded,
            'color': const Color(0xFF059669),
            'bg': const Color(0xFFD1FAE5),
            'action': () {
              Navigator.pop(ctx);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
            },
          },
          {
            'title': isArabic ? 'إعدادات الحساب والمظهر' : 'Settings & Preferences',
            'desc': isArabic ? 'اللغة، المظهر الداكن، الأمان' : 'Language, dark mode & security',
            'icon': Icons.settings_rounded,
            'color': ThebesColors.slateDark,
            'bg': const Color(0xFFF1F5F9),
            'action': () {
              Navigator.pop(ctx);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          },
        ];

        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.86,
          ),
          decoration: BoxDecoration(
            color: isDark ? ThebesColors.darkCard : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 30,
                offset: Offset(0, -6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              // Drag Handle
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 14),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isArabic ? 'كافة الخدمات الطلابية' : 'All Student Services',
                            style: GoogleFonts.almarai(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : ThebesColors.navy,
                            ),
                          ),
                          Text(
                            isArabic
                                ? 'دليل متكامل لكافة بوابات وأدوات أكاديمية طيبة'
                                : 'Complete directory of Thebes Academy tools',
                            style: GoogleFonts.almarai(
                              fontSize: 11.5,
                              color: isDark ? ThebesColors.slateLight : ThebesColors.slate,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      color: isDark ? Colors.white70 : ThebesColors.slate,
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              const Divider(height: 18),

              // Services List
              Flexible(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                  itemCount: allServices.length,
                  separatorBuilder: (_, index) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final s = allServices[i];
                    final color = s['color'] as Color;
                    final bg = s['bg'] as Color;
                    final action = s['action'] as VoidCallback;

                    return Material(
                      color: isDark ? ThebesColors.darkCardBorder.withAlpha(50) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        onTap: action,
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: bg,
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: Icon(s['icon'] as IconData, color: color, size: 22),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      s['title'] as String,
                                      style: GoogleFonts.almarai(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? Colors.white : ThebesColors.navy,
                                      ),
                                    ),
                                    Text(
                                      s['desc'] as String,
                                      style: GoogleFonts.almarai(
                                        fontSize: 11,
                                        color: isDark ? ThebesColors.slateLight : ThebesColors.slate,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                isArabic ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
                                color: isDark ? Colors.white38 : ThebesColors.slateLight,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================================================================
  // 3. Digital Student Pass (Chic Executive Titanium Card)
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
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: isDark ? ThebesColors.titaniumCardGradient : ThebesColors.primaryHeaderGradient,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isDark ? ThebesColors.hairlineDark : const Color(0xFF2E4682),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withAlpha(90) : ThebesColors.navy.withAlpha(50),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar: Academy Title & Contactless NFC Chip
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: ThebesColors.orange.withAlpha(35),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.school_rounded, color: ThebesColors.orangeLight, size: 13),
                      ),
                      const SizedBox(width: 7),
                      Flexible(
                        child: Text(
                          isArabic ? 'أكاديمية طيبة المتكاملة للعلوم' : 'THEBES ACADEMY',
                          style: GoogleFonts.almarai(
                            color: Colors.white70,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: ThebesColors.mint.withAlpha(30),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: ThebesColors.mint.withAlpha(60), width: 0.8),
                      ),
                      child: Text(
                        isArabic ? 'معتمدة' : 'Verified',
                        style: GoogleFonts.almarai(
                          color: ThebesColors.mint,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.contactless_rounded, color: Colors.white54, size: 17),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Middle: Avatar + Student Name + Department
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: ThebesColors.orange, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: ThebesColors.orange.withAlpha(40),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: UserAvatarWidget(
                    size: 46,
                    initials: isArabic ? 'ر.م' : 'R.A',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic ? student.nameAr : student.nameEn,
                        style: GoogleFonts.almarai(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${student.getLocalizedDepartment(isArabic)} • ${isArabic ? "الفرقة ${student.academicYear}" : "Year ${student.academicYear}"}',
                        style: GoogleFonts.almarai(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Bottom Badges: Academic ID & Seat Number & View Full Profile CTA
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(isDark ? 40 : 25),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white.withAlpha(isDark ? 15 : 25),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: Row(
                        children: [
                          Text(
                            isArabic ? 'كود القيد: ' : 'ID: ',
                            style: GoogleFonts.almarai(
                              color: Colors.white60,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${student.academicId}',
                            style: GoogleFonts.almarai(
                              color: ThebesColors.orangeLight,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            isArabic ? 'الجلوس: ' : 'Seat: ',
                            style: GoogleFonts.almarai(
                              color: Colors.white60,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${student.seatNumber}',
                            style: GoogleFonts.almarai(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isArabic ? 'الملف والبطاقة' : 'Full Profile',
                        style: GoogleFonts.almarai(
                          color: ThebesColors.orangeLight,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Icon(
                        isArabic ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
                        color: ThebesColors.orangeLight,
                        size: 15,
                      ),
                    ],
                  ),
                ],
              ),
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
          style: GoogleFonts.almarai(
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
                          style: GoogleFonts.almarai(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : ThebesColors.navy,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.getLocalizedContent(isArabic),
                          style: GoogleFonts.almarai(
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
                          style: GoogleFonts.almarai(
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
