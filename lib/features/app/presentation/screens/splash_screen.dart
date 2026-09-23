import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:thebes_academy/core/theme/thebes_colors.dart';
import 'package:thebes_academy/core/widgets/thebes_logo.dart';
import 'package:thebes_academy/core/localization/locale_provider.dart';
import 'package:thebes_academy/features/auth/presentation/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );

    _animController.forward();

    _navTimer = Timer(const Duration(milliseconds: 2400), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
              opacity: animation,
              child: child,
            ),
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final isArabic = locale.isArabic;

    return Scaffold(
      backgroundColor: const Color(0xFF08101E),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background ambient gradient glow
          Positioned(
            top: -120,
            right: -120,
            child: Container(
              width: 340,
              height: 340,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    ThebesColors.cobalt.withAlpha(50),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    ThebesColors.orange.withAlpha(30),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ThebesLogoWidget(
                        size: 110,
                        showText: true,
                        textColor: Colors.white,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(16),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withAlpha(25),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          isArabic
                              ? 'بوابة الطالب الأكاديمية الذكية'
                              : 'Smart Academic & Student Portal',
                          style: GoogleFonts.cairo(
                            color: const Color(0xFFE2E8F0),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 36,
            child: Column(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: const AlwaysStoppedAnimation<Color>(ThebesColors.cobaltLight),
                    backgroundColor: Colors.white.withAlpha(20),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Thebes Higher Institutes • المعاهد العليا بطيبة',
                  style: GoogleFonts.cairo(
                    color: Colors.white54,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
