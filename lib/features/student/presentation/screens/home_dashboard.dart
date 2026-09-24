import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
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

/// Professional, Award-Winning Student Academy Portal Dashboard
/// Built with Apple Human Interface & Modern Fintech Design Systems:
/// Clean visual hierarchy, curated luxury palette, zero visual clutter,
/// and direct 1-tap Gate QR & Student Pass right on the Home Screen.
class HomeDashboardScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;

  const HomeDashboardScreen({super.key, this.onNavigateTab});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  bool _isAbsenceAlertDismissed = false;
  int _cardModeIndex = 0; // 0 = Digital Student Pass, 1 = Gate Access QR
  int _selectedLectureIndex = 0;
  bool _isManualAttendanceUnlockedForTesting = false;

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final isArabic = locale.isArabic;
    final isDark = locale.isDarkMode;
    final controller = context.watch<StudentController>();
    final student = controller.student;
    final consecutiveLectures = controller.todayConsecutiveLectures;

    return Scaffold(
      backgroundColor: isDark ? ThebesColors.darkBackground : const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1040),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: context.responsiveScreenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Executive Top Header Bar
                  _buildHeader(context, locale, controller, student, isArabic, isDark),
                  const SizedBox(height: 18),

                  // Offline Notice (Only if disconnected)
                  if (!controller.isOnline) ...[
                    _buildOfflineNotice(context, controller, isArabic, isDark),
                    const SizedBox(height: 12),
                  ],

                  // 2. Absence Warning (Subtle, non-intrusive, dismissible)
                  if (!_isAbsenceAlertDismissed && controller.totalAbsenceWarnings > 0) ...[
                    _buildAbsenceAlertPill(context, controller, isArabic, isDark),
                    const SizedBox(height: 16),
                  ],

                  // 3. Hero Feature: Dual-Mode Campus Pass & Gate Access QR
                  _buildHeroStudentPassAndGateQr(context, student, isArabic, isDark),
                  const SizedBox(height: 22),

                  // 4. Today's Class / Lecture Action Card
                  if (consecutiveLectures.isNotEmpty) ...[
                    _buildTodayLectureCard(context, consecutiveLectures, isArabic, isDark),
                    const SizedBox(height: 22),
                  ],

                  // 5. Academic Vitals Strip (GPA, Credit Hours, Attendance)
                  _buildAcademicVitals(context, controller, student, isArabic, isDark),
                  const SizedBox(height: 22),

                  // 6. Curated Quick Services Grid (Clean 4-Pillar Dock)
                  _buildQuickServicesGrid(context, isArabic, isDark),
                  const SizedBox(height: 24),

                  // 7. Campus Announcements & Editorial News
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
  // 1. Executive Top Header
  // =========================================================================
  Widget _buildHeader(
    BuildContext context,
    LocaleProvider locale,
    StudentController controller,
    dynamic student,
    bool isArabic,
    bool isDark,
  ) {
    final now = DateTime.now();
    final isMorning = now.hour < 12;
    final greeting = isArabic
        ? (isMorning ? 'صباح الخير' : 'مساء الخير')
        : (isMorning ? 'Good morning' : 'Good evening');

    final nameColor = isDark ? Colors.white : ThebesColors.navy;
    final subtitleColor = isDark ? ThebesColors.slateLight : ThebesColors.slate;

    return Row(
      children: [
        // Profile Avatar with Status Ring -> Opens Full Profile
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
                      color: ThebesColors.orange.withAlpha(25),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: UserAvatarWidget(
                  size: context.responsiveValue(mobile: 46.0, tablet: 52.0),
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
                    border: Border.all(
                      color: isDark ? ThebesColors.darkBackground : Colors.white,
                      width: 2,
                    ),
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
                        '$greeting، ${student.nameAr.split(" ")[0]}',
                        style: GoogleFonts.almarai(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w800,
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
                        color: ThebesColors.mint.withAlpha(20),
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

        // Modern Glass Controls Dock (Language & Dark Mode)
        _buildControlsDock(context, locale, isDark),
        const SizedBox(width: 8),

        // Notifications Button
        _buildHeaderIconButton(
          context: context,
          icon: Icons.notifications_none_rounded,
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

  // Refined Segmented Pill Dock for Language & Theme Switching
  Widget _buildControlsDock(BuildContext context, LocaleProvider locale, bool isDark) {
    return Container(
      height: 38,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isDark ? ThebesColors.elevatedDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? ThebesColors.hairlineDark : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha(40) : const Color(0x06000000),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Language Switch Pill
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
          // Dark Mode Toggle Icon
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

  Widget _buildHeaderIconButton({
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
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isDark ? ThebesColors.elevatedDarkCard : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? ThebesColors.hairlineDark : const Color(0xFFE2E8F0),
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
            child: Icon(icon, size: 19, color: isDark ? Colors.white70 : ThebesColors.navy),
          ),
          if (badgeCount > 0)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 15,
                height: 15,
                decoration: const BoxDecoration(
                  color: ThebesColors.orange,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$badgeCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8.5,
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
  // 3. Hero Feature: Dual-Mode Campus Pass & Gate Access QR
  // =========================================================================
  Widget _buildHeroStudentPassAndGateQr(
    BuildContext context,
    dynamic student,
    bool isArabic,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? ThebesColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? ThebesColors.hairlineDark : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha(60) : const Color(0x0A0F172A),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          // Segmented Capsule Switcher: [ بطاقتي الجامعية ] vs [ كود البوابة السريع QR ]
          Container(
            height: 40,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: isDark ? ThebesColors.elevatedDarkCard : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _cardModeIndex = 0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: _cardModeIndex == 0
                            ? (isDark ? ThebesColors.darkCard : Colors.white)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: _cardModeIndex == 0
                            ? [
                                BoxShadow(
                                  color: Colors.black.withAlpha(isDark ? 50 : 15),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.badge_rounded,
                            size: 15,
                            color: _cardModeIndex == 0 ? ThebesColors.orange : ThebesColors.slate,
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              isArabic ? 'بطاقة الطالب' : 'Digital ID',
                              style: GoogleFonts.almarai(
                                fontSize: 11.5,
                                fontWeight: _cardModeIndex == 0 ? FontWeight.w800 : FontWeight.w600,
                                color: _cardModeIndex == 0
                                    ? (isDark ? Colors.white : ThebesColors.navy)
                                    : (isDark ? ThebesColors.slateLight : ThebesColors.slate),
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
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _cardModeIndex = 1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: _cardModeIndex == 1
                            ? (isDark ? ThebesColors.darkCard : Colors.white)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: _cardModeIndex == 1
                            ? [
                                BoxShadow(
                                  color: Colors.black.withAlpha(isDark ? 50 : 15),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.qr_code_2_rounded,
                            size: 16,
                            color: _cardModeIndex == 1 ? ThebesColors.orange : ThebesColors.slate,
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              isArabic ? 'كود البوابة QR' : 'Gate Access',
                              style: GoogleFonts.almarai(
                                fontSize: 11.5,
                                fontWeight: _cardModeIndex == 1 ? FontWeight.w800 : FontWeight.w600,
                                color: _cardModeIndex == 1
                                    ? (isDark ? Colors.white : ThebesColors.navy)
                                    : (isDark ? ThebesColors.slateLight : ThebesColors.slate),
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
          ),
          const SizedBox(height: 12),

          // Dynamic Content Switcher (Smooth Animated Switcher)
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 240),
            crossFadeState: _cardModeIndex == 0 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: _buildPhysicalCardView(context, student, isArabic, isDark),
            secondChild: _buildGateQrScannerView(context, student, isArabic, isDark),
          ),
        ],
      ),
    );
  }

  // --- Card View: Executive Physical ID Card ---
  Widget _buildPhysicalCardView(BuildContext context, dynamic student, bool isArabic, bool isDark) {
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
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? ThebesColors.hairlineDark : const Color(0xFF2C4378),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withAlpha(90) : ThebesColors.navy.withAlpha(45),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar: Academy Crest + Verified Badge + NFC
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: ThebesColors.orange.withAlpha(35),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: const Icon(Icons.school_rounded, color: ThebesColors.orangeLight, size: 14),
                      ),
                      const SizedBox(width: 8),
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
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: ThebesColors.mint,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isArabic ? 'نشط ومعتمد' : 'Verified',
                            style: GoogleFonts.almarai(
                              color: ThebesColors.mint,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.contactless_rounded, color: Colors.white60, size: 18),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Middle: Photo + Student Name + Academic Major
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
                          fontSize: 15.5,
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

            // Bottom Badges: Monospace Academic ID + Seat Number + Flip CTA
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(isDark ? 40 : 25),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withAlpha(isDark ? 15 : 25)),
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
                  // Direct Button to Flip to Gate QR
                  InkWell(
                    onTap: () => setState(() => _cardModeIndex = 1),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: ThebesColors.orange.withAlpha(40),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: ThebesColors.orangeLight.withAlpha(70)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.qr_code_2_rounded, color: ThebesColors.orangeLight, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            isArabic ? 'فتح QR البوابة' : 'Gate QR',
                            style: GoogleFonts.almarai(
                              color: ThebesColors.orangeLight,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- QR View: High-Contrast Live Smart Gate Access View ---
  Widget _buildGateQrScannerView(BuildContext context, dynamic student, bool isArabic, bool isDark) {
    final now = DateTime.now();
    final qrData = 'THEBES://GATE_ACCESS/${student.academicId}/TOKEN_${now.day}_${now.hour}_${now.minute}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? ThebesColors.elevatedDarkCard : const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? ThebesColors.hairlineDark : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          // Gate Status Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: ThebesColors.mint,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isArabic ? 'بوابات الأكاديمية الذكية • جاهز للعبور' : 'Smart Gate • Ready to Scan',
                    style: GoogleFonts.almarai(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: ThebesColors.mint,
                    ),
                  ),
                ],
              ),
              Text(
                '${student.academicId}',
                style: GoogleFonts.almarai(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isDark ? ThebesColors.slateLight : ThebesColors.slate,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Pristine High-Contrast White QR Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(isDark ? 40 : 15),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 160.0,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: Color(0xFF0F1E36),
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: Color(0xFF0F1E36),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'كود ديناميكي مشفر • ${student.nameAr.split(" ")[0]}',
                  style: GoogleFonts.almarai(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: ThebesColors.slate,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Instructions
          Text(
            isArabic
                ? 'مرر هذا الكود أمام قارئ البوابة الإلكترونية للدخول الفوري'
                : 'Hold this QR code in front of the gate scanner for instant access',
            textAlign: TextAlign.center,
            style: GoogleFonts.almarai(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: isDark ? ThebesColors.slateLight : ThebesColors.slateDark,
            ),
          ),
          const SizedBox(height: 12),

          // Action Buttons: Switch to Card | Open Fullscreen Gate Screen
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () => setState(() => _cardModeIndex = 0),
                icon: const Icon(Icons.credit_card_rounded, size: 16),
                label: Text(
                  isArabic ? 'عرض البطاقة' : 'Card View',
                  style: GoogleFonts.almarai(fontWeight: FontWeight.w700, fontSize: 12),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: isDark ? Colors.white70 : ThebesColors.navy,
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DigitalIdScreen()),
                ),
                icon: const Icon(Icons.fullscreen_rounded, size: 16),
                label: Text(
                  isArabic ? 'تكبير الكود' : 'Fullscreen',
                  style: GoogleFonts.almarai(fontWeight: FontWeight.w700, fontSize: 12),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: ThebesColors.orange,
                  side: const BorderSide(color: ThebesColors.orange),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // 4. Today's Class / Lecture Action Card
  // =========================================================================
  Widget _buildTodayLectureCard(
    BuildContext context,
    List<CourseScheduleEntity> consecutiveLectures,
    bool isArabic,
    bool isDark,
  ) {
    if (_selectedLectureIndex >= consecutiveLectures.length) {
      _selectedLectureIndex = 0;
    }
    final lecture = consecutiveLectures[_selectedLectureIndex];

    // 1-minute gate logic
    final isLocked = !_isManualAttendanceUnlockedForTesting &&
        !_hasPassedOneMinute(lecture.startTime);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? ThebesColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? ThebesColors.hairlineDark : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x060F172A),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header: Status Tag + Switcher
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
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
                    Expanded(
                      child: Text(
                        isArabic ? 'المحاضرة الحالية اليوم' : "Today's Active Lecture",
                        style: GoogleFonts.almarai(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: ThebesColors.orange,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (consecutiveLectures.length > 1)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDark ? ThebesColors.elevatedDarkCard : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    isArabic
                        ? '${_selectedLectureIndex + 1} من ${consecutiveLectures.length}'
                        : '${_selectedLectureIndex + 1} of ${consecutiveLectures.length}',
                    style: GoogleFonts.almarai(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? ThebesColors.slateLight : ThebesColors.slate,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Course Title & Code
          Text(
            lecture.getLocalizedTitle(isArabic),
            style: GoogleFonts.almarai(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : ThebesColors.navy,
              letterSpacing: -0.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),

          // Meta Row: Hall + Instructor + Time
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Row(
              children: [
                // Hall
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: ThebesColors.sky,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 13, color: ThebesColors.navy),
                      const SizedBox(width: 4),
                      Text(
                        lecture.getLocalizedHall(isArabic),
                        style: GoogleFonts.almarai(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: ThebesColors.navy,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Time
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 13, color: ThebesColors.slate),
                    const SizedBox(width: 4),
                    Text(
                      '${lecture.startTime} - ${lecture.endTime}',
                      style: GoogleFonts.almarai(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? ThebesColors.slateLight : ThebesColors.slateDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                // Instructor
                Row(
                  children: [
                    const Icon(Icons.school_outlined, size: 13, color: ThebesColors.slate),
                    const SizedBox(width: 4),
                    Text(
                      lecture.getLocalizedInstructor(isArabic),
                      style: GoogleFonts.almarai(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: isDark ? ThebesColors.slateLight : ThebesColors.slate,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Attendance Action Button (1-minute gate)
          isLocked
              ? _buildLockedAttendanceButton(context, lecture, isArabic, isDark)
              : _buildUnlockedAttendanceButton(context, lecture, isArabic, isDark),
        ],
      ),
    );
  }

  bool _hasPassedOneMinute(String startTime) {
    try {
      final now = DateTime.now();
      final parts = startTime.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1].split(' ')[0]);
      final lectureTime = DateTime(now.year, now.month, now.day, hour, minute);
      return now.isAfter(lectureTime.add(const Duration(minutes: 1)));
    } catch (_) {
      return true; // Fallback to unlocked if time cannot be parsed
    }
  }

  Widget _buildLockedAttendanceButton(
    BuildContext context,
    CourseScheduleEntity lecture,
    bool isArabic,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isArabic
                  ? 'يفتح تسجيل الحضور تلقائياً بعد دقيقة واحدة من بدء المحاضرة'
                  : 'Attendance registration unlocks 1 minute after lecture starts',
              style: GoogleFonts.almarai(fontSize: 12),
            ),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: isArabic ? 'فتح تجريبي' : 'Unlock Demo',
              onPressed: () {
                setState(() => _isManualAttendanceUnlockedForTesting = true);
              },
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? ThebesColors.elevatedDarkCard : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? ThebesColors.hairlineDark : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_clock_rounded,
              size: 16,
              color: isDark ? Colors.white54 : ThebesColors.slate,
            ),
            const SizedBox(width: 8),
            Text(
              isArabic
                  ? 'يفتح الحضور بعد الدقيقة الأولى من المحاضرة'
                  : 'Attendance unlocks 1 min after start',
              style: GoogleFonts.almarai(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white70 : ThebesColors.slateDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnlockedAttendanceButton(
    BuildContext context,
    CourseScheduleEntity lecture,
    bool isArabic,
    bool isDark,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          if (widget.onNavigateTab != null) {
            widget.onNavigateTab!(2);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const QrAttendanceScreen()),
            );
          }
        },
        icon: const Icon(Icons.qr_code_scanner_rounded, size: 18, color: Colors.white),
        label: Text(
          isArabic ? 'تسجيل الحضور الفوري (متاح الآن)' : 'Register Attendance (Open Now)',
          style: GoogleFonts.almarai(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: ThebesColors.orange,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          shadowColor: ThebesColors.orange.withAlpha(80),
        ),
      ),
    );
  }

  // =========================================================================
  // 5. Academic Vitals Strip (GPA, Credit Hours, Attendance)
  // =========================================================================
  Widget _buildAcademicVitals(
    BuildContext context,
    StudentController controller,
    dynamic student,
    bool isArabic,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? ThebesColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? ThebesColors.hairlineDark : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x040F172A),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // GPA Metric
          Expanded(
            child: _buildVitalMetricItem(
              label: isArabic ? 'المعدل التراكمي' : 'Cumulative GPA',
              value: '${student.gpa.toStringAsFixed(2)}',
              subtext: isArabic ? 'ممتاز مرتفع' : 'Excellent',
              color: ThebesColors.orange,
              isDark: isDark,
            ),
          ),
          Container(
            width: 1,
            height: 38,
            color: isDark ? ThebesColors.hairlineDark : const Color(0xFFE2E8F0),
          ),
          // Credit Hours Metric
          Expanded(
            child: _buildVitalMetricItem(
              label: isArabic ? 'الساعات المنجزة' : 'Earned Credits',
              value: '${student.completedHours}',
              subtext: isArabic ? 'من ${student.totalRequiredHours} ساعة' : 'of ${student.totalRequiredHours} hrs',
              color: ThebesColors.navy,
              isDark: isDark,
            ),
          ),
          Container(
            width: 1,
            height: 38,
            color: isDark ? ThebesColors.hairlineDark : const Color(0xFFE2E8F0),
          ),
          // Attendance Metric
          Expanded(
            child: _buildVitalMetricItem(
              label: isArabic ? 'نسبة الحضور' : 'Attendance',
              value: '${(student.attendanceRate * 100).toInt()}%',
              subtext: isArabic ? 'مستوى آمن' : 'Safe Standing',
              color: ThebesColors.mint,
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalMetricItem({
    required String label,
    required String value,
    required String subtext,
    required Color color,
    required bool isDark,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.almarai(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: isDark ? ThebesColors.slateLight : ThebesColors.slate,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: GoogleFonts.almarai(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : ThebesColors.navy,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          subtext,
          style: GoogleFonts.almarai(
            fontSize: 9.5,
            fontWeight: FontWeight.w600,
            color: color,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // =========================================================================
  // 6. Curated Quick Services Grid (Clean 4-Pillar Dock)
  // =========================================================================
  Widget _buildQuickServicesGrid(BuildContext context, bool isArabic, bool isDark) {
    final services = [
      {
        'title': isArabic ? 'حضور QR' : 'Smart Scan',
        'icon': Icons.qr_code_scanner_rounded,
        'action': () {
          if (widget.onNavigateTab != null) {
            widget.onNavigateTab!(2);
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const QrAttendanceScreen()));
          }
        },
      },
      {
        'title': isArabic ? 'جدول المحاضرات' : 'Timetable',
        'icon': Icons.calendar_today_rounded,
        'action': () {
          if (widget.onNavigateTab != null) {
            widget.onNavigateTab!(1);
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ScheduleScreen()));
          }
        },
      },
      {
        'title': isArabic ? 'الدرجات والنتائج' : 'Grades & GPA',
        'icon': Icons.assessment_outlined,
        'action': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GradesScreen())),
      },
      {
        'title': isArabic ? 'سداد المصروفات' : 'E-Payment',
        'icon': Icons.account_balance_wallet_outlined,
        'action': () {
          if (widget.onNavigateTab != null) {
            widget.onNavigateTab!(3);
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ServicesScreen()));
          }
        },
      },
    ];

    return Column(
      children: [
        // Section Header with "عرض الكل"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                isArabic ? 'الخدمات الأساسية' : 'Quick Actions',
                style: GoogleFonts.almarai(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : ThebesColors.navy,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => _showAllServicesSheet(context, isArabic, isDark),
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                child: Row(
                  children: [
                    Text(
                      isArabic ? 'كافة الخدمات (10)' : 'See all (10)',
                      style: GoogleFonts.almarai(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: ThebesColors.orange,
                      ),
                    ),
                    const SizedBox(width: 3),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 10, color: ThebesColors.orange),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 4-Card Responsive Grid
        Row(
          children: services.map((service) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  onTap: service['action'] as VoidCallback,
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
                    decoration: BoxDecoration(
                      color: isDark ? ThebesColors.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDark ? ThebesColors.hairlineDark : const Color(0xFFE2E8F0),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x040F172A),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isDark ? ThebesColors.elevatedDarkCard : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            service['icon'] as IconData,
                            size: 20,
                            color: isDark ? Colors.white : ThebesColors.navy,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          service['title'] as String,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.almarai(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white70 : ThebesColors.slateDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
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
            'title': isArabic ? 'كارنيه الكلية الرقمي وكود البوابة' : 'Digital ID & Gate Pass',
            'desc': isArabic ? 'عرض البطاقة الجامعية وكود البوابات الذكية' : 'Campus ID & turnstile scanner',
            'icon': Icons.badge_rounded,
            'action': () {
              Navigator.pop(ctx);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const DigitalIdScreen()));
            },
          },
          {
            'title': isArabic ? 'الدرجات والنتائج الأكاديمية' : 'Grades & Academic Standing',
            'desc': isArabic ? 'سجل الدرجات والمعدل التراكمي والساعات' : 'Semester grades & transcript',
            'icon': Icons.assessment_rounded,
            'action': () {
              Navigator.pop(ctx);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const GradesScreen()));
            },
          },
          {
            'title': isArabic ? 'جدول الامتحانات واللجان' : 'Exam Schedule & Halls',
            'desc': isArabic ? 'مواعيد الامتحانات وأرقام اللجان والجلوس' : 'Exam dates, halls & seat number',
            'icon': Icons.assignment_rounded,
            'action': () {
              Navigator.pop(ctx);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ExamScheduleScreen()));
            },
          },
          {
            'title': isArabic ? 'طلبات الطلاب والخدمات الإلكترونية' : 'Student Requests',
            'desc': isArabic ? 'إفادات القيد، الكارنيه، والشهادات' : 'Enrollment certificates & requests',
            'icon': Icons.description_rounded,
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
            'title': isArabic ? 'دليل مقرات الأكاديمية والمدرجات' : 'Campus Guide',
            'desc': isArabic ? 'مقرات المعادي وسقارة وأرقام التواصل' : 'Campuses, halls & directory',
            'icon': Icons.map_rounded,
            'action': () {
              Navigator.pop(ctx);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CampusGuideScreen()));
            },
          },
          {
            'title': isArabic ? 'الإعلانات والأنشطة الأكاديمية' : 'Announcements',
            'desc': isArabic ? 'تنبيهات شؤون الطلاب والأنشطة' : 'Student affairs news & events',
            'icon': Icons.campaign_rounded,
            'action': () {
              Navigator.pop(ctx);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
            },
          },
          {
            'title': isArabic ? 'إعدادات الحساب والمظهر' : 'Settings & Preferences',
            'desc': isArabic ? 'اللغة، المظهر الداكن، الأمان' : 'Language, dark mode & security',
            'icon': Icons.settings_rounded,
            'action': () {
              Navigator.pop(ctx);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          },
        ];

        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
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

              // Sheet Header
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
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : ThebesColors.navy,
                            ),
                          ),
                          Text(
                            isArabic
                                ? 'دليل متكامل لكافة بوابات وأدوات أكاديمية طيبة'
                                : 'Complete directory of Thebes Academy tools',
                            style: GoogleFonts.almarai(
                              fontSize: 11,
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
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final item = allServices[i];
                    return InkWell(
                      onTap: item['action'] as VoidCallback,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: isDark ? ThebesColors.elevatedDarkCard : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? ThebesColors.hairlineDark : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: isDark ? ThebesColors.darkCard : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                item['icon'] as IconData,
                                color: ThebesColors.navy,
                                size: 19,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'] as String,
                                    style: GoogleFonts.almarai(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? Colors.white : ThebesColors.navy,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item['desc'] as String,
                                    style: GoogleFonts.almarai(
                                      fontSize: 11,
                                      color: isDark ? ThebesColors.slateLight : ThebesColors.slate,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              isArabic ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
                              color: isDark ? Colors.white38 : ThebesColors.slateLight,
                              size: 18,
                            ),
                          ],
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
  // 7. Campus Announcements & Editorial News
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                isArabic ? 'تنبيهات وأخبار الأكاديمية' : 'Campus Announcements',
                style: GoogleFonts.almarai(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : ThebesColors.navy,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              ),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  isArabic ? 'المزيد' : 'More',
                  style: GoogleFonts.almarai(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: ThebesColors.orange,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...announcements.take(2).map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? ThebesColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? ThebesColors.hairlineDark : const Color(0xFFE2E8F0),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x040F172A),
                  blurRadius: 8,
                  offset: Offset(0, 2),
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
                  child: const Icon(Icons.campaign_outlined, color: ThebesColors.navy, size: 18),
                ),
                const SizedBox(width: 12),
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
                                color: ThebesColors.orangePale,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item.getLocalizedCategory(isArabic),
                                style: GoogleFonts.almarai(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w700,
                                  color: ThebesColors.orange,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            item.date,
                            style: GoogleFonts.almarai(
                              fontSize: 10.5,
                              color: ThebesColors.slate,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.getLocalizedTitle(isArabic),
                        style: GoogleFonts.almarai(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : ThebesColors.navy,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.getLocalizedContent(isArabic),
                        style: GoogleFonts.almarai(
                          fontSize: 11,
                          color: isDark ? ThebesColors.slateLight : ThebesColors.slate,
                          height: 1.35,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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

  // =========================================================================
  // Auxiliary: Absence Warning Pill (Dismissible)
  // =========================================================================
  Widget _buildAbsenceAlertPill(
    BuildContext context,
    StudentController controller,
    bool isArabic,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Color(0xFFFEE2E2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626), size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'تنبيه نسبة الغياب الأكاديمي' : 'Absence Warning',
                  style: GoogleFonts.almarai(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF991B1B),
                  ),
                ),
                Text(
                  isArabic
                      ? 'لديك مقرر اقترب من الحد الأقصى للغياب المسموح (25%)'
                      : 'You have a course approaching max absence limit',
                  style: GoogleFonts.almarai(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFB91C1C),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => setState(() => _isAbsenceAlertDismissed = true),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.close_rounded, size: 16, color: Color(0xFF991B1B)),
            ),
          ),
        ],
      ),
    );
  }

  // Auxiliary: Offline Notice
  Widget _buildOfflineNotice(
    BuildContext context,
    StudentController controller,
    bool isArabic,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_off_rounded, size: 16, color: Colors.amber),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isArabic ? 'يعمل التطبيق في وضع عدم الاتصال' : 'Working offline mode',
              style: GoogleFonts.almarai(fontSize: 11, color: Colors.amber.shade900),
            ),
          ),
        ],
      ),
    );
  }
}
