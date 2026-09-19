import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/thebes_colors.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/responsive/responsive_helper.dart';
import '../../core/widgets/user_avatar_widget.dart';
import '../../features/student/domain/entities/academic_entities.dart';
import '../../features/student/presentation/controllers/student_controller.dart';
import 'digital_id_screen.dart';
import 'schedule_screen.dart';
import 'services_screen.dart';

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
    final isTabletOrDesktop = context.isTablet || context.isDesktop;

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
                  // 1. Top Header with Student Info & Controls
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const DigitalIdScreen()),
                        ),
                        child: Stack(
                          children: [
                            UserAvatarWidget(
                              size: context.responsiveValue(mobile: 48.0, tablet: 56.0),
                              initials: 'أ.ش',
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: ThebesColors.success,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${locale.tr('welcome_back')} 👋',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? ThebesColors.darkTextSecondary : ThebesColors.lightTextSecondary,
                              ),
                            ),
                            Text(
                              student.getLocalizedName(isArabic),
                              style: TextStyle(
                                fontSize: context.responsiveValue(mobile: 15.0, tablet: 18.0),
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : ThebesColors.primaryDark,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${student.getLocalizedDepartment(isArabic)} • ${isArabic ? "الفرقة 3" : "Year 3"}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: ThebesColors.gold,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.translate_rounded, color: ThebesColors.gold, size: 20),
                        onPressed: () => locale.toggleLocale(),
                        tooltip: 'Language',
                      ),
                      IconButton(
                        icon: Icon(
                          isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                          color: isDark ? ThebesColors.gold : ThebesColors.primary,
                          size: 20,
                        ),
                        onPressed: () => locale.toggleTheme(),
                        tooltip: 'Theme',
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // 2. Responsive Hero Row: Side-by-side on Tablet/Desktop, stacked on Mobile
                  if (isTabletOrDesktop)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildDigitalIdBanner(context, locale, student, isArabic)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildNextLectureCard(context, locale, nextLecture, isArabic, isDark)),
                      ],
                    )
                  else ...[
                    _buildDigitalIdBanner(context, locale, student, isArabic),
                    const SizedBox(height: 16),
                    _buildNextLectureCard(context, locale, nextLecture, isArabic, isDark),
                  ],

                  const SizedBox(height: 18),

                  // 3. Quick Academic Stats (4 in a row on Tablet/Desktop, 2x2 grid on Mobile)
                  if (isTabletOrDesktop)
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            context,
                            title: locale.tr('gpa'),
                            value: student.gpa.toStringAsFixed(2),
                            subtitle: locale.tr('excellent'),
                            color: ThebesColors.gold,
                            icon: Icons.auto_awesome_rounded,
                            onTap: () => onNavigateTab?.call(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            context,
                            title: locale.tr('completed_hours'),
                            value: '${student.completedHours} / ${student.totalRequiredHours}',
                            subtitle: isArabic ? 'متبقي 44 ساعة' : '44 hrs left',
                            color: ThebesColors.cyanAccent,
                            icon: Icons.history_edu_rounded,
                            onTap: () => onNavigateTab?.call(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            context,
                            title: locale.tr('attendance_rate'),
                            value: '${student.attendanceRate}%',
                            subtitle: isArabic ? 'منتظم ومتميز' : 'Good Standing',
                            color: ThebesColors.info,
                            icon: Icons.fact_check_outlined,
                            onTap: () => onNavigateTab?.call(1),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            context,
                            title: locale.tr('financial_status'),
                            value: locale.tr('paid'),
                            subtitle: isArabic ? 'لا توجد متأخرات' : 'Up to date',
                            color: ThebesColors.success,
                            icon: Icons.check_circle_outline_rounded,
                            onTap: () => onNavigateTab?.call(3),
                          ),
                        ),
                      ],
                    )
                  else ...[
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            context,
                            title: locale.tr('gpa'),
                            value: student.gpa.toStringAsFixed(2),
                            subtitle: locale.tr('excellent'),
                            color: ThebesColors.gold,
                            icon: Icons.auto_awesome_rounded,
                            onTap: () => onNavigateTab?.call(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            context,
                            title: locale.tr('completed_hours'),
                            value: '${student.completedHours} / ${student.totalRequiredHours}',
                            subtitle: isArabic ? 'متبقي 44 ساعة' : '44 hrs left',
                            color: ThebesColors.cyanAccent,
                            icon: Icons.history_edu_rounded,
                            onTap: () => onNavigateTab?.call(2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            context,
                            title: locale.tr('attendance_rate'),
                            value: '${student.attendanceRate}%',
                            subtitle: isArabic ? 'منتظم ومتميز' : 'Good Standing',
                            color: ThebesColors.info,
                            icon: Icons.fact_check_outlined,
                            onTap: () => onNavigateTab?.call(1),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            context,
                            title: locale.tr('financial_status'),
                            value: locale.tr('paid'),
                            subtitle: isArabic ? 'لا توجد متأخرات' : 'Up to date',
                            color: ThebesColors.success,
                            icon: Icons.check_circle_outline_rounded,
                            onTap: () => onNavigateTab?.call(3),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 22),

                  // 4. Quick Actions Row
                  Text(
                    locale.tr('quick_actions'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : ThebesColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildActionButton(
                        context,
                        label: locale.tr('exam_schedule'),
                        icon: Icons.calendar_month_outlined,
                        color: const Color(0xFF6366F1),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ScheduleScreen(initialTab: 1)),
                          );
                        },
                      ),
                      _buildActionButton(
                        context,
                        label: locale.tr('enrollment_cert'),
                        icon: Icons.assignment_outlined,
                        color: const Color(0xFF0EA5E9),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ServicesScreen(initialTab: 1)),
                          );
                        },
                      ),
                      _buildActionButton(
                        context,
                        label: locale.tr('course_reg'),
                        icon: Icons.post_add_rounded,
                        color: const Color(0xFF10B981),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isArabic
                                    ? 'تم فتح التسجيل للفصل الدراسي القادم'
                                    : 'Course Registration is open for next term',
                              ),
                              backgroundColor: ThebesColors.primary,
                            ),
                          );
                        },
                      ),
                      _buildActionButton(
                        context,
                        label: locale.tr('complaints'),
                        icon: Icons.support_agent_rounded,
                        color: const Color(0xFFF59E0B),
                        onTap: () => _showSupportDialog(context, locale),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 5. Announcements Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          locale.tr('announcements'),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : ThebesColors.primaryDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        locale.tr('view_all'),
                        style: const TextStyle(
                          fontSize: 12,
                          color: ThebesColors.gold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  if (isTabletOrDesktop)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: controller.announcements.length,
                      itemBuilder: (context, index) {
                        return _buildAnnouncementCard(
                          context,
                          controller.announcements[index],
                          isArabic,
                          isDark,
                        );
                      },
                    )
                  else
                    ...controller.announcements.map((ann) => _buildAnnouncementCard(context, ann, isArabic, isDark)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDigitalIdBanner(BuildContext context, LocaleProvider locale, dynamic student, bool isArabic) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DigitalIdScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: ThebesColors.primaryGradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ThebesColors.gold, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: ThebesColors.opacity(ThebesColors.primaryDark, 0.35),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ThebesColors.opacity(ThebesColors.gold, 0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.badge_rounded, color: ThebesColors.gold, size: 30),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locale.tr('digital_id_btn'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${locale.tr('academic_id')}: ${student.academicId}',
                    style: TextStyle(
                      color: Colors.white.withAlpha(190),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: ThebesColors.gold,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.qr_code_rounded, color: ThebesColors.primaryDark, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    isArabic ? 'إظهار الرمز' : 'Show QR',
                    style: const TextStyle(
                      color: ThebesColors.primaryDark,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
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

  Widget _buildNextLectureCard(BuildContext context, LocaleProvider locale, dynamic nextLecture, bool isArabic, bool isDark) {
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
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.timer_outlined, color: ThebesColors.warning, size: 18),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        locale.tr('next_lecture'),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white70 : ThebesColors.lightTextSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: ThebesColors.opacity(ThebesColors.warning, 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${locale.tr("starts_in")} 25 دقيقة',
                  style: const TextStyle(
                    color: ThebesColors.warning,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            nextLecture.getLocalizedTitle(isArabic),
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : ThebesColors.primaryDark,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person_outline, size: 14, color: isDark ? Colors.grey : Colors.grey.shade600),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  nextLecture.getLocalizedInstructor(isArabic),
                  style: TextStyle(fontSize: 12, color: isDark ? Colors.grey : Colors.grey.shade700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              Icon(Icons.room_outlined, size: 14, color: isDark ? Colors.grey : Colors.grey.shade600),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  nextLecture.getLocalizedHall(isArabic),
                  style: TextStyle(fontSize: 12, color: isDark ? Colors.grey : Colors.grey.shade700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? ThebesColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(16),
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
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.white60 : ThebesColors.lightTextSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(icon, color: color, size: 18),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : ThebesColors.primaryDark,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10.5,
                color: color,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: context.responsiveValue(mobileSmall: 64.0, mobile: 74.0, tablet: 92.0),
        child: Column(
          children: [
            Container(
              width: context.responsiveValue(mobileSmall: 46.0, mobile: 52.0, tablet: 60.0),
              height: context.responsiveValue(mobileSmall: 46.0, mobile: 52.0, tablet: 60.0),
              decoration: BoxDecoration(
                color: ThebesColors.opacity(color, 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ThebesColors.opacity(color, 0.3)),
              ),
              child: Icon(
                icon,
                color: color,
                size: context.responsiveValue(mobileSmall: 20.0, mobile: 24.0),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.responsiveValue(mobileSmall: 9.5, mobile: 10.5),
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : ThebesColors.lightTextPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementCard(
    BuildContext context,
    AnnouncementEntity ann,
    bool isArabic,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? ThebesColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ann.isImportant
              ? ThebesColors.opacity(ThebesColors.gold, 0.6)
              : (isDark ? ThebesColors.darkCardBorder : ThebesColors.lightCardBorder),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: ThebesColors.opacity(ThebesColors.primary, 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    ann.getLocalizedCategory(isArabic),
                    style: const TextStyle(
                      color: ThebesColors.gold,
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                ann.date,
                style: TextStyle(
                  fontSize: 10.5,
                  color: isDark ? Colors.grey : ThebesColors.lightTextMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            ann.getLocalizedTitle(isArabic),
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : ThebesColors.primaryDark,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            ann.getLocalizedContent(isArabic),
            style: TextStyle(
              fontSize: 11.5,
              color: isDark ? Colors.white70 : ThebesColors.lightTextSecondary,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showSupportDialog(BuildContext context, LocaleProvider locale) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(locale.tr('contact_us')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(locale.tr('hotline'), style: const TextStyle(fontWeight: FontWeight.bold, color: ThebesColors.gold)),
            const SizedBox(height: 8),
            Text(locale.tr('campus_maadi')),
            const SizedBox(height: 4),
            Text(locale.tr('campus_giza')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(locale.isArabic ? 'إغلاق' : 'Close'),
          ),
        ],
      ),
    );
  }
}
