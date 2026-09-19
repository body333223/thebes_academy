import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/thebes_colors.dart';
import '../../core/widgets/thebes_logo.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/responsive/responsive_helper.dart';
import '../../features/student/domain/entities/student_entity.dart';
import '../../features/student/presentation/controllers/student_controller.dart';
import '../main_screen.dart';

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
  UserRole _selectedRole = UserRole.student;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(BuildContext context, {UserRole? overrideRole}) {
    final controller = context.read<StudentController>();
    controller.switchRole(overrideRole ?? _selectedRole);

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

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final isDark = locale.isDarkMode;
    final isArabic = locale.isArabic;
    final isTabletOrDesktop = context.isTablet || context.isDesktop;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: context.responsiveScreenPadding,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 480),
              padding: isTabletOrDesktop ? const EdgeInsets.all(32) : EdgeInsets.zero,
              decoration: isTabletOrDesktop
                  ? BoxDecoration(
                      color: isDark ? ThebesColors.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isDark ? ThebesColors.darkCardBorder : ThebesColors.lightCardBorder,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(25),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    )
                  : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Action Bar: Lang + Theme Switch
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                          color: isDark ? ThebesColors.gold : ThebesColors.primary,
                        ),
                        onPressed: () => locale.toggleTheme(),
                        tooltip: 'Theme',
                      ),
                      InkWell(
                        onTap: () => locale.toggleLocale(),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDark ? ThebesColors.darkCard : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: ThebesColors.opacity(ThebesColors.gold, 0.5),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.language_rounded, size: 16, color: ThebesColors.gold),
                              const SizedBox(width: 6),
                              Text(
                                isArabic ? 'English' : 'العربية',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : ThebesColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Logo Header
                  Center(
                    child: ThebesLogoWidget(
                      size: context.responsiveValue(mobile: 74.0, tablet: 88.0),
                      showText: true,
                      textColor: isDark ? Colors.white : ThebesColors.primaryDark,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Role Segmented Selector
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isDark ? ThebesColors.darkCard : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? ThebesColors.darkCardBorder : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedRole = UserRole.student),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _selectedRole == UserRole.student
                                    ? ThebesColors.primary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: _selectedRole == UserRole.student
                                    ? [
                                        BoxShadow(
                                          color: ThebesColors.opacity(ThebesColors.primary, 0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.school_outlined,
                                    size: 18,
                                    color: _selectedRole == UserRole.student
                                        ? Colors.white
                                        : (isDark ? Colors.grey : ThebesColors.lightTextSecondary),
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      locale.tr('student_portal'),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: _selectedRole == UserRole.student
                                            ? Colors.white
                                            : (isDark ? Colors.grey : ThebesColors.lightTextSecondary),
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
                            onTap: () => setState(() => _selectedRole = UserRole.faculty),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                              decoration: BoxDecoration(
                                color: _selectedRole == UserRole.faculty
                                    ? ThebesColors.primary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: _selectedRole == UserRole.faculty
                                    ? [
                                        BoxShadow(
                                          color: ThebesColors.opacity(ThebesColors.primary, 0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person_search_outlined,
                                    size: 18,
                                    color: _selectedRole == UserRole.faculty
                                        ? Colors.white
                                        : (isDark ? Colors.grey : ThebesColors.lightTextSecondary),
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      locale.tr('faculty_portal'),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: _selectedRole == UserRole.faculty
                                            ? Colors.white
                                            : (isDark ? Colors.grey : ThebesColors.lightTextSecondary),
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

                  const SizedBox(height: 24),

                  // Academic ID Field
                  Text(
                    locale.tr('academic_id'),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _idController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: locale.tr('academic_id_hint'),
                      prefixIcon: const Icon(Icons.badge_outlined, color: ThebesColors.gold),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Password Field
                  Text(
                    locale.tr('password'),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: locale.tr('password_hint'),
                      prefixIcon: const Icon(Icons.lock_outline_rounded, color: ThebesColors.gold),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
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
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _rememberMe,
                              activeColor: ThebesColors.primary,
                              onChanged: (val) => setState(() => _rememberMe = val ?? true),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            locale.tr('remember_me'),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          locale.tr('forgot_password'),
                          style: const TextStyle(
                            fontSize: 12,
                            color: ThebesColors.gold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Main Sign In Button
                  ElevatedButton(
                    onPressed: () => _handleLogin(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThebesColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          locale.tr('login_button'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey.withAlpha(80))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          isArabic ? 'أو تجربة الحسابات التجريبية' : 'Or Test Demo Accounts',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey : Colors.grey.shade600,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey.withAlpha(80))),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Quick Student Login Button
                  OutlinedButton.icon(
                    onPressed: () => _handleLogin(context, overrideRole: UserRole.student),
                    icon: const Icon(Icons.school, color: ThebesColors.gold, size: 18),
                    label: Text(
                      locale.tr('quick_login_student'),
                      style: TextStyle(
                        color: isDark ? Colors.white : ThebesColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      side: BorderSide(
                        color: ThebesColors.opacity(ThebesColors.gold, 0.6),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Quick Doctor Login Button
                  OutlinedButton.icon(
                    onPressed: () => _handleLogin(context, overrideRole: UserRole.faculty),
                    icon: const Icon(Icons.psychology_outlined, color: ThebesColors.cyanAccent, size: 18),
                    label: Text(
                      locale.tr('quick_login_doctor'),
                      style: TextStyle(
                        color: isDark ? Colors.white : ThebesColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      side: BorderSide(
                        color: ThebesColors.opacity(ThebesColors.cyanAccent, 0.6),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
