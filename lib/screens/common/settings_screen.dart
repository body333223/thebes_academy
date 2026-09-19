import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/thebes_colors.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/responsive/responsive_helper.dart';
import '../../core/widgets/user_avatar_widget.dart';
import '../../features/student/domain/entities/student_entity.dart';
import '../../features/student/presentation/controllers/student_controller.dart';
import '../student/digital_id_screen.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final isArabic = locale.isArabic;
    final isDark = locale.isDarkMode;
    final controller = context.watch<StudentController>();
    final student = controller.student;

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.tr('settings')),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: context.responsiveScreenPadding,
            children: [
              // Profile Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? ThebesColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? ThebesColors.darkCardBorder : ThebesColors.lightCardBorder,
                  ),
                ),
                child: Row(
                  children: [
                    UserAvatarWidget(
                      size: context.responsiveValue(mobile: 56.0, tablet: 64.0),
                      initials: 'أ.ش',
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student.getLocalizedName(isArabic),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : ThebesColors.primaryDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            student.getLocalizedInstitute(isArabic),
                            style: const TextStyle(
                              fontSize: 11,
                              color: ThebesColors.gold,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'ID: ${student.academicId} • ${student.email}',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.grey : ThebesColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Digital ID Quick Launch Button
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ThebesColors.opacity(ThebesColors.gold, 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.qr_code_2_rounded, color: ThebesColors.gold),
                ),
                title: Text(
                  locale.tr('digital_id_btn'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(isArabic ? 'عرض البطاقة الجامعية وكود البوابات' : 'Display digital ID and campus gate code'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DigitalIdScreen()),
                  );
                },
              ),

              const Divider(height: 24),

              // Language Switch
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ThebesColors.opacity(ThebesColors.primary, 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.translate_rounded, color: ThebesColors.primaryLight),
                ),
                title: Text(locale.tr('language')),
                subtitle: Text(isArabic ? 'العربية (Arabic)' : 'English (الإنجليزية)'),
                trailing: Switch(
                  value: !isArabic,
                  onChanged: (_) => locale.toggleLocale(),
                ),
              ),

              // Dark Mode Toggle
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.dark_mode_outlined, color: Colors.purple),
                ),
                title: Text(locale.tr('dark_mode')),
                trailing: Switch(
                  value: isDark,
                  onChanged: (_) => locale.toggleTheme(),
                ),
              ),

              // Switch Role (Student <-> Faculty)
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ThebesColors.opacity(ThebesColors.cyanAccent, 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.swap_horiz_rounded, color: ThebesColors.cyanAccent),
                ),
                title: Text(isArabic ? 'تبديل الدور (طالب / دكتور)' : 'Switch Role (Student / Faculty)'),
                subtitle: Text(
                  controller.isStudent
                      ? (isArabic ? 'الحساب الحالي: طالب' : 'Current: Student')
                      : (isArabic ? 'الحساب الحالي: دكتور' : 'Current: Faculty'),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () {
                  controller.switchRole(controller.isStudent ? UserRole.faculty : UserRole.student);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        controller.isStudent
                            ? (isArabic ? 'تم التبديل لبوابة الطالب' : 'Switched to Student')
                            : (isArabic ? 'تم التبديل لبوابة الدكتور' : 'Switched to Faculty'),
                      ),
                      backgroundColor: ThebesColors.primary,
                    ),
                  );
                },
              ),

              const Divider(height: 24),

              // About Thebes Academy
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.info_outline_rounded, color: Colors.blue),
                ),
                title: Text(locale.tr('about_academy')),
                subtitle: Text(
                  isArabic
                      ? 'معاهد هندسة، تكنولوجيا الإدارة والمعلومات، الإعلام واللغات'
                      : 'Engineering, Management & IT Institutes',
                ),
                onTap: () => _showAboutDialog(context, locale),
              ),

              // Contact Us & Hotline
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.headset_mic_outlined, color: Colors.green),
                ),
                title: Text(locale.tr('contact_us')),
                subtitle: Text(locale.tr('hotline')),
                onTap: () => _showContactDialog(context, locale),
              ),

              const SizedBox(height: 20),

              // Logout Button
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout_rounded, color: Colors.white),
                label: Text(
                  locale.tr('logout'),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThebesColors.error,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: Text(
                  'Thebes Academy Smart Campus • v2.4.0 (Clean Architecture)',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.grey : ThebesColors.lightTextMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context, LocaleProvider locale) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(locale.tr('about_academy')),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                locale.isArabic
                    ? 'أكاديمية طيبة المتكاملة للعلوم مؤسسة تعليمية رائدة معتمدة من وزارة التعليم العالي والمجلس الأعلى للجامعات، وتضم:'
                    : 'Thebes Integrated Academy is accredited by the Ministry of Higher Education and the Supreme Council of Universities:',
                style: const TextStyle(fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 10),
              Text(locale.isArabic ? '• المعهد العالي للهندسة' : '• Thebes Higher Institute of Engineering'),
              Text(locale.isArabic ? '• المعهد العالي لتكنولوجيا الإدارة والمعلومات' : '• Higher Institute of Management & IT'),
              Text(locale.isArabic ? '• المعهد العالي للغات والترجمة' : '• Higher Institute of Languages'),
            ],
          ),
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

  void _showContactDialog(BuildContext context, LocaleProvider locale) {
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
