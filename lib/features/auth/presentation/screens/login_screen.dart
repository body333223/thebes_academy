import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:thebes_academy/core/theme/thebes_colors.dart';
import 'package:thebes_academy/core/widgets/thebes_logo.dart';
import 'package:thebes_academy/core/localization/locale_provider.dart';
import 'package:thebes_academy/core/responsive/responsive_helper.dart';
import 'package:thebes_academy/features/student/presentation/controllers/student_controller.dart';
import 'package:thebes_academy/features/app/presentation/screens/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _idController = TextEditingController(text: '20220451');
  final _passwordController = TextEditingController(text: '12345678');
  bool _obscurePassword = true;
  bool _rememberMe = true;
  bool _isAuthenticating = false;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() => _isAuthenticating = true);
    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;

    final controller = context.read<StudentController>();
    await controller.loadInitialData();

    if (!mounted) return;
    setState(() => _isAuthenticating = false);

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const MainScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _showForgotPasswordDialog(bool isArabic) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.help_outline_rounded, color: ThebesColors.gold),
            const SizedBox(width: 10),
            Text(
              isArabic ? 'استعادة الحساب' : 'Account Recovery',
              style: GoogleFonts.cairo(fontWeight: FontWeight.w800, fontSize: 16),
            ),
          ],
        ),
        content: Text(
          isArabic
              ? 'في حال نسيان كلمة المرور أو رقم القيد الأكاديمي، يرجى التوجه لمكتب تكنولوجيا المعلومات والإدارة الإلكترونية أو الاتصال بالخط الساخن للأكاديمية 19572.'
              : 'If you forgot your Academic ID or Password, please visit the Academy IT center or call hotline 19572.',
          style: GoogleFonts.cairo(fontSize: 13, height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              isArabic ? 'حسناً' : 'OK',
              style: GoogleFonts.cairo(fontWeight: FontWeight.w800, color: ThebesColors.gold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final isDark = locale.isDarkMode;
    final isArabic = locale.isArabic;
    final isTabletOrDesktop = context.isTablet || context.isDesktop;

    return Scaffold(
      body: Stack(
        children: [
          // Luxury Deep Navy Ambient Glow Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: isDark
                    ? const LinearGradient(
                        colors: [Color(0xFF040A14), Color(0xFF091629), Color(0xFF0D2240)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )
                    : const LinearGradient(
                        colors: [Color(0xFFEDF2F9), Color(0xFFF6F9FD), Colors.white],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
              ),
            ),
          ),

          // Top right subtle gold aura
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ThebesColors.gold.withAlpha(isDark ? 28 : 20),
              ),
            ),
          ),

          // Main Interactive Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: context.responsiveScreenPadding,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 460),
                  padding: isTabletOrDesktop ? const EdgeInsets.all(36) : const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0C1829).withAlpha(235) : Colors.white.withAlpha(240),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: isDark ? ThebesColors.gold.withAlpha(70) : ThebesColors.lightCardBorder,
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ThebesColors.primaryDark.withAlpha(isDark ? 160 : 40),
                        blurRadius: 36,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Top Quick Controls (Language & Theme)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: ThebesColors.gold.withAlpha(25),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: ThebesColors.gold.withAlpha(60)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.school_rounded, color: ThebesColors.gold, size: 14),
                                const SizedBox(width: 6),
                                Text(
                                  isArabic ? 'بوابة الطالب' : 'Student Portal',
                                  style: GoogleFonts.cairo(
                                    color: ThebesColors.gold,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  isArabic ? Icons.language : Icons.translate,
                                  size: 20,
                                  color: ThebesColors.gold,
                                ),
                                tooltip: 'Language',
                                onPressed: () => locale.toggleLocale(),
                              ),
                              IconButton(
                                icon: Icon(
                                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                                  size: 20,
                                  color: ThebesColors.gold,
                                ),
                                tooltip: 'Theme',
                                onPressed: () => locale.toggleTheme(),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Academy Emblem with Golden Aura
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: ThebesColors.gold.withAlpha(70),
                                  blurRadius: 30,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                          const ThebesLogoWidget(size: 88, showText: false),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // University Titles
                      Text(
                        isArabic ? 'أكاديمية طيبة المتكاملة للعلوم' : 'Thebes Academy of Science',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : ThebesColors.primary,
                        ),
                      ),
                      Text(
                        isArabic
                            ? 'بوابة الخدمات الطلابية والتعليم الإلكتروني'
                            : 'Student Services & E-Learning Portal',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          color: ThebesColors.gold,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Form Fields
                      // Academic ID
                      Align(
                        alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
                        child: Text(
                          isArabic ? 'الرقم الأكاديمي (رقم القيد)' : 'Academic ID',
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: isDark ? Colors.white70 : ThebesColors.lightTextSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _idController,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.cairo(fontWeight: FontWeight.w700, letterSpacing: 1),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.badge_rounded, color: ThebesColors.gold),
                          hintText: 'e.g. 20220451',
                          filled: true,
                          fillColor: isDark ? const Color(0xFF13233A) : const Color(0xFFF1F5F9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: ThebesColors.gold, width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Password
                      Align(
                        alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
                        child: Text(
                          isArabic ? 'كلمة المرور' : 'Password',
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: isDark ? Colors.white70 : ThebesColors.lightTextSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: GoogleFonts.cairo(fontWeight: FontWeight.w700),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline_rounded, color: ThebesColors.gold),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                              color: Colors.grey,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          hintText: '••••••••',
                          filled: true,
                          fillColor: isDark ? const Color(0xFF13233A) : const Color(0xFFF1F5F9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: ThebesColors.gold, width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Remember Me & Forgot Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                activeColor: ThebesColors.gold,
                                checkColor: ThebesColors.primaryDark,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                onChanged: (v) => setState(() => _rememberMe = v ?? true),
                              ),
                              Text(
                                isArabic ? 'تذكرني' : 'Remember me',
                                style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () => _showForgotPasswordDialog(isArabic),
                            child: Text(
                              isArabic ? 'نسيت كلمة المرور؟' : 'Forgot Password?',
                              style: GoogleFonts.cairo(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: ThebesColors.gold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Primary Login Button (Full Width Regal Gold)
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ThebesColors.gold,
                            foregroundColor: ThebesColors.primaryDark,
                            elevation: 4,
                            shadowColor: ThebesColors.gold.withAlpha(120),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: _isAuthenticating ? null : () => _handleLogin(),
                          child: _isAuthenticating
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: ThebesColors.primaryDark,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      isArabic ? 'تسجيل الدخول' : 'Sign In',
                                      style: GoogleFonts.cairo(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      isArabic ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded,
                                      size: 18,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Biometric Fingerprint Option
                      InkWell(
                        onTap: () => _handleLogin(),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isDark ? Colors.white12 : Colors.black12,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.fingerprint_rounded, color: ThebesColors.gold, size: 22),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  isArabic ? 'الدخول السريع عبر البصمة البيومترية' : 'Quick Biometric Login',
                                  style: GoogleFonts.cairo(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white70 : ThebesColors.primary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Footer Hotline & Support
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.headset_mic_rounded, size: 14, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            isArabic ? 'الخط الساخن الأكاديمي: 19572' : 'Academic Hotline: 19572',
                            style: GoogleFonts.cairo(
                              fontSize: 11,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
