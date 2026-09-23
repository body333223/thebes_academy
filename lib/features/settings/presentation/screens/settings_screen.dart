import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thebes_academy/core/theme/thebes_colors.dart';
import 'package:thebes_academy/core/localization/locale_provider.dart';
import 'package:thebes_academy/core/responsive/responsive_helper.dart';
import 'package:thebes_academy/core/widgets/user_avatar_widget.dart';
import 'package:thebes_academy/features/student/presentation/controllers/student_controller.dart';
import 'package:thebes_academy/features/student/presentation/screens/digital_id_screen.dart';
import 'package:thebes_academy/features/student/presentation/screens/campus_guide_screen.dart';
import 'package:thebes_academy/features/auth/presentation/screens/login_screen.dart';

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

              // Campus Guide
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ThebesColors.opacity(ThebesColors.cyanAccent, 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.map_rounded, color: ThebesColors.cyanAccent),
                ),
                title: Text(
                  isArabic ? 'دليل المقرات والمدرجات' : 'Campus & Hall Directory',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(isArabic ? 'مقرات المعادي وسقارة، أرقام المدرجات وأرقام التواصل' : 'Maadi & Saqqara campuses, halls & contacts'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CampusGuideScreen()),
                  );
                },
              ),

              const Divider(height: 24),

              // Security & Password Section Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Text(
                  isArabic ? 'الأمان والحساب' : 'Account & Security',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: ThebesColors.gold,
                  ),
                ),
              ),

              // Change Password
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ThebesColors.opacity(ThebesColors.primaryLight, 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.lock_reset_rounded, color: ThebesColors.primaryLight),
                ),
                title: Text(
                  isArabic ? 'تغيير كلمة المرور' : 'Change Password',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(isArabic ? 'تحديث كلمة مرور الدخول لحسابك' : 'Update your account login password'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () => _showChangePasswordDialog(context, locale),
              ),

              // 2FA Security Status
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ThebesColors.opacity(ThebesColors.emerald, 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.verified_user_rounded, color: ThebesColors.emerald),
                ),
                title: Text(
                  isArabic ? 'التحقق الثنائي وتأمين الأجهزة' : 'Two-Factor & Device Security',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(isArabic ? 'مفعل • البصمة وتأكيد الدخول عبر SMS' : 'Active • Biometric & SMS verify'),
                trailing: const Icon(Icons.check_circle_rounded, color: ThebesColors.emerald, size: 20),
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

  void _showChangePasswordDialog(BuildContext context, LocaleProvider locale) {
    final currentPassController = TextEditingController();
    final newPassController = TextEditingController();
    final confirmPassController = TextEditingController();
    bool obscureCurrent = true;
    bool obscureNew = true;
    bool obscureConfirm = true;
    String? errorText;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          final isDark = locale.isDarkMode;
          return AlertDialog(
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ThebesColors.primaryLight.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.lock_reset_rounded, color: ThebesColors.primaryLight, size: 22),
                ),
                const SizedBox(width: 10),
                Text(locale.isArabic ? 'تغيير كلمة المرور' : 'Change Password'),
              ],
            ),
            content: SizedBox(
              width: 360,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (errorText != null) ...[
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: ThebesColors.error.withAlpha(25),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: ThebesColors.error.withAlpha(90)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline_rounded, color: ThebesColors.error, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                errorText!,
                                style: const TextStyle(color: ThebesColors.error, fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    TextField(
                      controller: currentPassController,
                      obscureText: obscureCurrent,
                      decoration: InputDecoration(
                        labelText: locale.isArabic ? 'كلمة المرور الحالية' : 'Current Password',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          icon: Icon(obscureCurrent ? Icons.visibility_off_rounded : Icons.visibility_rounded),
                          onPressed: () => setDialogState(() => obscureCurrent = !obscureCurrent),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: newPassController,
                      obscureText: obscureNew,
                      decoration: InputDecoration(
                        labelText: locale.isArabic ? 'كلمة المرور الجديدة' : 'New Password',
                        prefixIcon: const Icon(Icons.key_rounded),
                        suffixIcon: IconButton(
                          icon: Icon(obscureNew ? Icons.visibility_off_rounded : Icons.visibility_rounded),
                          onPressed: () => setDialogState(() => obscureNew = !obscureNew),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: confirmPassController,
                      obscureText: obscureConfirm,
                      decoration: InputDecoration(
                        labelText: locale.isArabic ? 'تأكيد كلمة المرور الجديدة' : 'Confirm New Password',
                        prefixIcon: const Icon(Icons.check_circle_outline_rounded),
                        suffixIcon: IconButton(
                          icon: Icon(obscureConfirm ? Icons.visibility_off_rounded : Icons.visibility_rounded),
                          onPressed: () => setDialogState(() => obscureConfirm = !obscureConfirm),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      locale.isArabic
                          ? '• يجب أن لا تقل عن 6 أحرف أو أرقام\n• تجنب استخدام أرقام الهواتف أو تواريخ الميلاد'
                          : '• At least 6 characters or numbers\n• Avoid using phone numbers or birthdates',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.grey : ThebesColors.lightTextMuted,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(locale.isArabic ? 'إلغاء' : 'Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThebesColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  final cur = currentPassController.text.trim();
                  final n = newPassController.text.trim();
                  final c = confirmPassController.text.trim();

                  if (cur.isEmpty || n.isEmpty || c.isEmpty) {
                    setDialogState(() {
                      errorText = locale.isArabic ? 'يرجى ملء جميع الحقول المطلوبة' : 'Please fill all required fields';
                    });
                    return;
                  }
                  if (n.length < 6) {
                    setDialogState(() {
                      errorText = locale.isArabic
                          ? 'كلمة المرور الجديدة يجب أن تتكون من 6 خانات على الأقل'
                          : 'New password must be at least 6 characters';
                    });
                    return;
                  }
                  if (n != c) {
                    setDialogState(() {
                      errorText = locale.isArabic
                          ? 'كلمة المرور الجديدة وتأكيدها غير متطابقين'
                          : 'New password and confirmation do not match';
                    });
                    return;
                  }

                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            locale.isArabic
                                ? 'تم تحديث كلمة المرور بنجاح'
                                : 'Password updated successfully',
                          ),
                        ],
                      ),
                      backgroundColor: ThebesColors.emerald,
                    ),
                  );
                },
                child: Text(locale.isArabic ? 'حفظ التغيير' : 'Save'),
              ),
            ],
          );
        },
      ),
    );
  }
}
