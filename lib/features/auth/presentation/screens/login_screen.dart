import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:thebes_academy/core/localization/locale_provider.dart';
import 'package:thebes_academy/core/theme/thebes_colors.dart';
import 'package:thebes_academy/features/student/presentation/controllers/student_controller.dart';
import 'package:thebes_academy/features/app/presentation/screens/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _auth = LocalAuthentication();
  final _idController = TextEditingController(text: 'S20210089');
  final _passwordController = TextEditingController(text: '12345678');
  bool _obscurePassword = true;
  bool _isAuthenticating = false;
  bool _biometricAvailable = false;
  bool _biometricSuccess = false;
  bool _biometricFail = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _checkBiometrics();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometrics() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();
      if (mounted) {
        setState(() => _biometricAvailable = canCheck && isDeviceSupported);
      }
    } catch (_) {
      if (mounted) setState(() => _biometricAvailable = false);
    }
  }

  Future<void> _handleBiometricLogin() async {
    if (_isAuthenticating) return;
    setState(() {
      _isAuthenticating = true;
      _biometricSuccess = false;
      _biometricFail = false;
    });

    bool authenticated = false;
    try {
      authenticated = await _auth.authenticate(
        localizedReason: 'Theeba Academy Portal — Student Biometric Authentication',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
    } on PlatformException {
      authenticated = false;
    }

    if (!mounted) return;

    if (authenticated) {
      setState(() {
        _biometricSuccess = true;
        _isAuthenticating = false;
      });
      await Future.delayed(const Duration(milliseconds: 400));
      await _navigateToMain();
    } else {
      setState(() {
        _biometricFail = true;
        _isAuthenticating = false;
      });
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) setState(() => _biometricFail = false);
    }
  }

  Future<void> _handlePasswordLogin() async {
    if (_isAuthenticating) return;
    setState(() => _isAuthenticating = true);
    HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    final controller = context.read<StudentController>();
    await controller.loadInitialData();
    await _navigateToMain();
  }

  Future<void> _navigateToMain() async {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (ctx, anim, sec) => const MainScreen(),
        transitionsBuilder: (ctx, anim, sec, child) => FadeTransition(
          opacity: anim,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.96, end: 1.0).animate(
              CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        ),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _showForgotPasswordDialog(bool isArabic) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: ThebesColors.sky,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.help_outline_rounded, color: ThebesColors.navy, size: 28),
              ),
              const SizedBox(height: 16),
              Text(
                isArabic ? 'استعادة الحساب' : 'Account Recovery',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: ThebesColors.navy,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isArabic
                    ? 'يرجى مراجعة إدارة تكنولوجيا المعلومات في الأكاديمية أو الاتصال بالخط الساخن: 19572'
                    : 'Please visit the IT Academic Support Center or contact the student hotline: 19572',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: ThebesColors.slate,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThebesColors.navy,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    isArabic ? 'حسناً' : 'Close',
                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final isArabic = locale.isArabic;

    return Scaffold(
      backgroundColor: ThebesColors.pageBg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildNavyHeader(context, isArabic),
            _buildLoginFormCard(context, isArabic),
            _buildFooter(isArabic),
          ],
        ),
      ),
    );
  }

  Widget _buildNavyHeader(BuildContext context, bool isArabic) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, topPadding + 16, 20, 48),
      decoration: const BoxDecoration(
        gradient: ThebesColors.primaryHeaderGradient,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Background subtle concentric rings
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withAlpha(12), width: 1.5),
              ),
            ),
          ),
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withAlpha(8), width: 1.5),
              ),
            ),
          ),

          // Header Content
          Column(
            children: [
              // Logo in orange gradient rounded box
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: ThebesColors.orangeCtaGradient,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: ThebesColors.orange.withAlpha(100),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'TA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Title
              Text(
                isArabic ? 'بوابة أكاديمية طيبة' : 'Theeba Academy Portal',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),

              // Tagline
              Text(
                isArabic ? 'تمكين قادة المستقبل' : 'Empowering Future Leaders',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFE8EEFF).withAlpha(200),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoginFormCard(BuildContext context, bool isArabic) {
    return Transform.translate(
      offset: const Offset(0, -24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20), // rounded-2xl
            border: Border.all(color: ThebesColors.lightCardBorder, width: 1),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0C0F1A3D),
                blurRadius: 24,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isArabic ? 'تسجيل الدخول' : 'Sign In',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: ThebesColors.navy,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isArabic
                    ? 'أدخل رقم القيد وكلمة المرور للمتابعة'
                    : 'Enter your student ID and password to continue',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: ThebesColors.slate,
                ),
              ),
              const SizedBox(height: 20),

              // Student ID Field
              _buildFieldLabel(isArabic ? 'رقم القيد الجامعي' : 'Student ID'),
              const SizedBox(height: 6),
              TextField(
                controller: _idController,
                keyboardType: TextInputType.text,
                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.badge_outlined, color: ThebesColors.slate, size: 20),
                  hintText: isArabic ? 'مثال: S20210089' : 'e.g. S20210089',
                  filled: true,
                  fillColor: ThebesColors.pageBg,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: ThebesColors.lightCardBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: ThebesColors.lightCardBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: ThebesColors.orange, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Password Field
              _buildFieldLabel(isArabic ? 'كلمة المرور' : 'Password'),
              const SizedBox(height: 6),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline_rounded, color: ThebesColors.slate, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: ThebesColors.slate,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  hintText: '••••••••',
                  filled: true,
                  fillColor: ThebesColors.pageBg,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: ThebesColors.lightCardBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: ThebesColors.lightCardBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: ThebesColors.orange, width: 1.5),
                  ),
                ),
              ),

              // Forgot password link
              Align(
                alignment: isArabic ? Alignment.centerLeft : Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _showForgotPasswordDialog(isArabic),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: Text(
                    isArabic ? 'نسيت كلمة المرور؟' : 'Forgot Password?',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: ThebesColors.orange,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Orange CTA Sign In Button
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
                    onTap: _isAuthenticating ? null : _handlePasswordLogin,
                    child: Center(
                      child: _isAuthenticating
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  isArabic ? 'تسجيل الدخول' : 'Sign In',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                              ],
                            ),
                    ),
                  ),
                ),
              ),

              // Biometric Authentication Section
              if (_biometricAvailable) ...[
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Expanded(child: Divider(color: ThebesColors.lightCardBorder)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        isArabic ? 'أو الدخول السريع' : 'Or Quick Access',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: ThebesColors.slate,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: ThebesColors.lightCardBorder)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildBiometricTile(isArabic),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: ThebesColors.slateDark,
      ),
    );
  }

  Widget _buildBiometricTile(bool isArabic) {
    Color tileBg = ThebesColors.sky;
    Color tileBorder = ThebesColors.navy.withAlpha(20);
    Color contentColor = ThebesColors.navy;

    if (_biometricSuccess) {
      tileBg = ThebesColors.mint.withAlpha(30);
      tileBorder = ThebesColors.mint;
      contentColor = ThebesColors.mint;
    } else if (_biometricFail) {
      tileBg = ThebesColors.error.withAlpha(20);
      tileBorder = ThebesColors.error;
      contentColor = ThebesColors.error;
    }

    return ScaleTransition(
      scale: _pulseAnim,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isAuthenticating ? null : _handleBiometricLogin,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: tileBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: tileBorder, width: 1.2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _biometricSuccess
                      ? Icons.check_circle_rounded
                      : (_biometricFail ? Icons.error_outline_rounded : Icons.fingerprint_rounded),
                  color: contentColor,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  _biometricSuccess
                      ? (isArabic ? 'تم التحقق بنجاح!' : 'Authenticated!')
                      : (_biometricFail
                          ? (isArabic ? 'فشل التحقق، حاول مجدداً' : 'Failed, try again')
                          : (isArabic
                              ? 'تسجيل الدخول بالبصمة / Face ID'
                              : 'Sign in with Biometrics / Face ID')),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: contentColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(bool isArabic) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.headset_mic_outlined, size: 14, color: ThebesColors.slate),
              const SizedBox(width: 6),
              Text(
                isArabic ? 'الدعم الفني والخط الساخن: 19572' : 'Academic Hotline & Support: 19572',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: ThebesColors.slate,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Theeba Academy Portal · v1.0',
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: ThebesColors.slateLight,
            ),
          ),
        ],
      ),
    );
  }
}
