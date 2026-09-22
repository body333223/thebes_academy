import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:thebes_academy/core/localization/locale_provider.dart';
import 'package:thebes_academy/features/student/presentation/controllers/student_controller.dart';
import 'package:thebes_academy/features/app/presentation/screens/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _auth = LocalAuthentication();
  final _idController = TextEditingController(text: '20220451');
  final _passwordController = TextEditingController(text: '12345678');
  bool _obscurePassword = true;
  bool _isAuthenticating = false;
  bool _biometricAvailable = false;
  bool _biometricSuccess = false;
  bool _biometricFail = false;

  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _particleController;
  late AnimationController _glowController;
  late AnimationController _fadeController;

  late Animation<double> _pulseAnim;
  late Animation<double> _glowAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _glowAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _checkBiometrics();
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
        localizedReason:
            'تسجيل الدخول إلى بوابة أكاديمية طيبة الطلابية',
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
      await Future.delayed(const Duration(milliseconds: 600));
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
    await Future.delayed(const Duration(milliseconds: 400));
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
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        ),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _showForgotPasswordDialog(bool isArabic) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF0D0D1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: CosmicColors.indigo.withAlpha(100)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.help_outline_rounded,
                  color: CosmicColors.neonGold, size: 36),
              const SizedBox(height: 12),
              Text(
                isArabic ? 'استعادة الحساب' : 'Account Recovery',
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                isArabic
                    ? 'توجه لمكتب تكنولوجيا المعلومات أو اتصل بالخط الساخن: 19572'
                    : 'Visit the IT center or call the academic hotline: 19572',
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  color: Colors.white60,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  isArabic ? 'حسناً' : 'OK',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.w800,
                    color: CosmicColors.neonGold,
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
  void dispose() {
    _pulseController.dispose();
    _particleController.dispose();
    _glowController.dispose();
    _fadeController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final isArabic = locale.isArabic;
    final size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: CosmicColors.void_,
        body: Stack(
          children: [
            // ─── Animated Particle Background ───
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _particleController,
                builder: (_, child) => CustomPaint(
                  painter: CosmicParticlePainter(_particleController.value),
                ),
              ),
            ),

            // ─── Ambient Glow Orbs ───
            AnimatedBuilder(
              animation: _glowAnim,
              builder: (_, child) {
                return Stack(
                  children: [
                    Positioned(
                      top: -120,
                      left: -80,
                      child: _GlowOrb(
                        size: 320,
                        color: CosmicColors.indigo,
                        opacity: _glowAnim.value * 0.18,
                      ),
                    ),
                    Positioned(
                      bottom: -60,
                      right: -100,
                      child: _GlowOrb(
                        size: 280,
                        color: CosmicColors.violet,
                        opacity: _glowAnim.value * 0.14,
                      ),
                    ),
                    Positioned(
                      top: size.height * 0.4,
                      left: -40,
                      child: _GlowOrb(
                        size: 160,
                        color: CosmicColors.neonGold,
                        opacity: _glowAnim.value * 0.10,
                      ),
                    ),
                  ],
                );
              },
            ),

            // ─── Main Content ───
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 16),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: Column(
                        children: [
                          // ── Top Bar (Lang + Theme) ──
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildTopChip(
                                isArabic
                                    ? 'بوابة الطالب'
                                    : 'Student Portal',
                              ),
                              Row(
                                children: [
                                  _buildIconBtn(
                                    icon: Icons.translate_rounded,
                                    onTap: () => locale.toggleLocale(),
                                  ),
                                  const SizedBox(width: 4),
                                  _buildIconBtn(
                                    icon: locale.isDarkMode
                                        ? Icons.light_mode_rounded
                                        : Icons.dark_mode_rounded,
                                    onTap: () => locale.toggleTheme(),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 36),

                          // ── Academy Logo & Title ──
                          _buildLogoSection(isArabic),

                          const SizedBox(height: 40),

                          // ── Glassmorphism Login Card ──
                          _buildGlassCard(isArabic),

                          const SizedBox(height: 28),

                          // ── Biometric Ring Button ──
                          if (_biometricAvailable)
                            _buildBiometricRing(isArabic),

                          const SizedBox(height: 32),

                          // ── Footer ──
                          _buildFooter(isArabic),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: CosmicColors.neonGold.withAlpha(18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: CosmicColors.neonGold.withAlpha(70),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.school_rounded,
              color: CosmicColors.neonGold, size: 12),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.cairo(
              color: CosmicColors.neonGold,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconBtn(
      {required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(12),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withAlpha(25)),
        ),
        child: Icon(icon, color: Colors.white70, size: 16),
      ),
    );
  }

  Widget _buildLogoSection(bool isArabic) {
    return Column(
      children: [
        // Glowing emblem ring
        AnimatedBuilder(
          animation: _pulseAnim,
          builder: (_, child) => Transform.scale(
            scale: _pulseAnim.value,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: const [
                    CosmicColors.indigo,
                    CosmicColors.violet,
                    CosmicColors.neonGold,
                    CosmicColors.indigo,
                  ],
                  stops: const [0.0, 0.33, 0.66, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: CosmicColors.indigo.withAlpha(130),
                    blurRadius: 30,
                    spreadRadius: 4,
                  ),
                  BoxShadow(
                    color: CosmicColors.neonGold.withAlpha(60),
                    blurRadius: 20,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(3),
              child: Container(
                decoration: const BoxDecoration(
                  color: CosmicColors.void_,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.account_balance_rounded,
                    color: CosmicColors.neonGold,
                    size: 38,
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 18),

        Text(
          isArabic ? 'أكاديمية طيبة' : 'Thebes Academy',
          style: GoogleFonts.cairo(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [CosmicColors.indigo, CosmicColors.neonCyan, CosmicColors.violet],
          ).createShader(bounds),
          child: Text(
            isArabic
                ? 'بوابة الخدمات الطلابية الذكية'
                : 'Smart Student Services Portal',
            style: GoogleFonts.cairo(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildGlassCard(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withAlpha(10),
        border: Border.all(color: Colors.white.withAlpha(25), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: CosmicColors.indigo.withAlpha(40),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Text(
            isArabic ? 'تسجيل الدخول' : 'Sign In',
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            isArabic
                ? 'أدخل بياناتك الأكاديمية للمتابعة'
                : 'Enter your academic credentials to continue',
            style: GoogleFonts.cairo(
              fontSize: 12,
              color: Colors.white38,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // Academic ID Field
          _buildCosmicField(
            controller: _idController,
            label: isArabic ? 'الرقم الأكاديمي' : 'Academic ID',
            hint: '20220451',
            icon: Icons.badge_outlined,
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 16),

          // Password Field
          _buildCosmicField(
            controller: _passwordController,
            label: isArabic ? 'كلمة المرور' : 'Password',
            hint: '••••••••',
            icon: Icons.lock_outline_rounded,
            isPassword: true,
          ),

          const SizedBox(height: 10),

          // Forgot Password
          Align(
            alignment: isArabic ? Alignment.centerLeft : Alignment.centerRight,
            child: TextButton(
              onPressed: () => _showForgotPasswordDialog(isArabic),
              child: Text(
                isArabic ? 'نسيت كلمة المرور؟' : 'Forgot Password?',
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: CosmicColors.neonCyan,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Login Button
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 52,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: _isAuthenticating
                    ? null
                    : const LinearGradient(
                        colors: [
                          CosmicColors.indigo,
                          CosmicColors.violet,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                color: _isAuthenticating
                    ? Colors.white10
                    : null,
                boxShadow: _isAuthenticating
                    ? null
                    : [
                        BoxShadow(
                          color: CosmicColors.indigo.withAlpha(140),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed:
                    _isAuthenticating ? null : _handlePasswordLogin,
                child: _isAuthenticating
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isArabic ? 'دخول' : 'Sign In',
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            isArabic
                                ? Icons.arrow_back_rounded
                                : Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 18,
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

  Widget _buildCosmicField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.white60,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword ? _obscurePassword : false,
          style: GoogleFonts.spaceMono(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white24),
            prefixIcon: Icon(icon,
                color: CosmicColors.neonCyan.withAlpha(180), size: 20),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: Colors.white38,
                      size: 18,
                    ),
                    onPressed: () => setState(
                        () => _obscurePassword = !_obscurePassword),
                  )
                : null,
            filled: true,
            fillColor: Colors.white.withAlpha(8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                  color: Colors.white.withAlpha(20), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                  color: Colors.white.withAlpha(20), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                  color: CosmicColors.neonCyan, width: 1.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildBiometricRing(bool isArabic) {
    Color ringColor;
    IconData ringIcon;
    String ringLabel;

    if (_biometricSuccess) {
      ringColor = const Color(0xFF00E676);
      ringIcon = Icons.check_circle_rounded;
      ringLabel = isArabic ? 'تم التحقق بنجاح!' : 'Verified!';
    } else if (_biometricFail) {
      ringColor = const Color(0xFFFF1744);
      ringIcon = Icons.cancel_rounded;
      ringLabel = isArabic ? 'فشل التحقق' : 'Auth Failed';
    } else {
      ringColor = CosmicColors.neonGold;
      ringIcon = Icons.fingerprint_rounded;
      ringLabel = isArabic
          ? 'الدخول عبر البصمة / Face ID'
          : 'Fingerprint / Face ID Login';
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Divider(color: Colors.white.withAlpha(20))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                isArabic ? 'أو' : 'or',
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: Colors.white30,
                ),
              ),
            ),
            Expanded(
                child: Divider(color: Colors.white.withAlpha(20))),
          ],
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: _isAuthenticating ? null : _handleBiometricLogin,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (_, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Outer glow ring
                  Transform.scale(
                    scale:
                        _biometricSuccess || _biometricFail
                            ? 1.0
                            : 0.9 + _pulseAnim.value * 0.15,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ringColor.withAlpha(80),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: ringColor.withAlpha(90),
                            blurRadius: 24,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Inner button
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withAlpha(10),
                      border: Border.all(
                        color: ringColor.withAlpha(160),
                        width: 1.5,
                      ),
                    ),
                    child: _isAuthenticating
                        ? const Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white60,
                            ),
                          )
                        : Icon(ringIcon,
                            color: ringColor, size: 34),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        Text(
          ringLabel,
          style: GoogleFonts.cairo(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.white60,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(bool isArabic) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.headset_mic_rounded,
            size: 13, color: Colors.white24),
        const SizedBox(width: 6),
        Text(
          isArabic
              ? 'الخط الساخن الأكاديمي: 19572'
              : 'Academic Hotline: 19572',
          style: GoogleFonts.cairo(
            fontSize: 11,
            color: Colors.white24,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Cosmic Color Palette
// ─────────────────────────────────────────────
class CosmicColors {
  static const Color void_ = Color(0xFF000814);
  static const Color surface = Color(0xFF070B14);
  static const Color card = Color(0xFF0D1120);
  static const Color indigo = Color(0xFF5C4FF6);
  static const Color violet = Color(0xFF8B3CF7);
  static const Color neonGold = Color(0xFFFFD700);
  static const Color neonCyan = Color(0xFF00E5FF);
  static const Color emerald = Color(0xFF00E676);
}

// ─────────────────────────────────────────────
// Glow Orb Widget
// ─────────────────────────────────────────────
class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;

  const _GlowOrb({
    required this.size,
    required this.color,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withAlpha((opacity * 255).round()),
            blurRadius: size * 0.6,
            spreadRadius: size * 0.1,
          ),
        ],
        color: color.withAlpha((opacity * 0.3 * 255).round()),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Cosmic Particle Painter
// ─────────────────────────────────────────────
class CosmicParticlePainter extends CustomPainter {
  final double progress;

  CosmicParticlePainter(this.progress);

  static final List<_Particle> _particles = List.generate(
    55,
    (i) {
      final rand = math.Random(i * 31 + 7);
      return _Particle(
        x: rand.nextDouble(),
        y: rand.nextDouble(),
        size: rand.nextDouble() * 2.2 + 0.4,
        speed: rand.nextDouble() * 0.012 + 0.003,
        opacity: rand.nextDouble() * 0.5 + 0.2,
        color: i % 5 == 0
            ? CosmicColors.neonGold
            : i % 5 == 1
                ? CosmicColors.indigo
                : i % 5 == 2
                    ? CosmicColors.neonCyan
                    : i % 5 == 3
                        ? CosmicColors.violet
                        : Colors.white,
      );
    },
  );

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particles) {
      final y = (p.y - progress * p.speed * 4) % 1.0;
      final paint = Paint()
        ..color = p.color.withAlpha((p.opacity * 255).round())
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.2);
      canvas.drawCircle(
        Offset(p.x * size.width, y * size.height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CosmicParticlePainter old) => old.progress != progress;
}

class _Particle {
  final double x, y, size, speed, opacity;
  final Color color;
  const _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.color,
  });
}
