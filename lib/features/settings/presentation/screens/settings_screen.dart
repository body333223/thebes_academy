import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thebes_academy/core/theme/thebes_colors.dart';
import 'package:thebes_academy/core/localization/locale_provider.dart';
import 'package:thebes_academy/core/responsive/responsive_helper.dart';
import 'package:thebes_academy/core/widgets/user_avatar_widget.dart';
import 'package:thebes_academy/features/student/presentation/controllers/student_controller.dart';
import 'package:thebes_academy/features/student/presentation/screens/digital_id_screen.dart';
import 'package:thebes_academy/features/student/presentation/screens/profile_screen.dart';
import 'package:thebes_academy/features/student/presentation/screens/campus_guide_screen.dart';
import 'package:thebes_academy/features/auth/presentation/screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

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
              // Profile Banner (Clickable -> Opens Full Student Profile)
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                ),
                borderRadius: BorderRadius.circular(22),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isDark ? ThebesColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isDark ? ThebesColors.hairlineDark : const Color(0xFFEAECF0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black.withAlpha(40) : const Color(0x06101828),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: ThebesColors.orange, width: 2),
                        ),
                        child: UserAvatarWidget(
                          size: context.responsiveValue(mobile: 54.0, tablet: 62.0),
                          initials: isArabic ? 'ر.م' : 'R.A',
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student.getLocalizedName(isArabic),
                              style: GoogleFonts.almarai(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : ThebesColors.navy,
                                letterSpacing: -0.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              student.getLocalizedInstitute(isArabic),
                              style: GoogleFonts.almarai(
                                fontSize: 11.5,
                                color: ThebesColors.orange,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'ID: ${student.academicId} • ${student.email}',
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
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark ? ThebesColors.elevatedDarkCard : const Color(0xFFF1F5F9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isArabic ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
                          size: 18,
                          color: isDark ? Colors.white54 : ThebesColors.slate,
                        ),
                      ),
                    ],
                  ),
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

              // Modern Language Segmented Card
              Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? ThebesColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? ThebesColors.hairlineDark : const Color(0xFFEAECF0),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: ThebesColors.orangePale,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.translate_rounded, color: ThebesColors.orange, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          locale.tr('language'),
                          style: GoogleFonts.almarai(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : ThebesColors.navy,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isDark ? ThebesColors.elevatedDarkCard : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildSegmentButton(
                              label: 'العربية (Arabic)',
                              isSelected: isArabic,
                              onTap: isArabic ? null : () => locale.toggleLocale(),
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: _buildSegmentButton(
                              label: 'English (الإنجليزية)',
                              isSelected: !isArabic,
                              onTap: !isArabic ? null : () => locale.toggleLocale(),
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Modern Dark Mode / Theme Segmented Card
              Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? ThebesColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? ThebesColors.hairlineDark : const Color(0xFFEAECF0),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: ThebesColors.sky,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                            color: ThebesColors.navy,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          isArabic ? 'مظهر التطبيق (السمة)' : 'App Theme & Appearance',
                          style: GoogleFonts.almarai(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : ThebesColors.navy,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isDark ? ThebesColors.elevatedDarkCard : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildSegmentButton(
                              icon: Icons.light_mode_rounded,
                              label: isArabic ? 'الوضع النهاري' : 'Light Mode',
                              isSelected: !isDark,
                              onTap: !isDark ? null : () => locale.toggleTheme(),
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: _buildSegmentButton(
                              icon: Icons.dark_mode_rounded,
                              label: isArabic ? 'الوضع الليلي' : 'Dark Mode',
                              isSelected: isDark,
                              onTap: isDark ? null : () => locale.toggleTheme(),
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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

  Widget _buildSegmentButton({
    IconData? icon,
    required String label,
    required bool isSelected,
    required VoidCallback? onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? ThebesColors.primaryHeaderGradient.colors.first : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: isDark ? Colors.black.withAlpha(50) : const Color(0x15000000),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? (isDark ? ThebesColors.orangeLight : ThebesColors.navy)
                    : (isDark ? Colors.white54 : ThebesColors.slate),
              ),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.almarai(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected
                      ? (isDark ? Colors.white : ThebesColors.navy)
                      : (isDark ? Colors.white54 : ThebesColors.slate),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

