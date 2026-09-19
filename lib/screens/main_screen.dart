import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/localization/locale_provider.dart';
import '../core/responsive/adaptive_scaffold.dart';
import '../features/student/domain/entities/student_entity.dart';
import '../features/student/presentation/controllers/student_controller.dart';
import 'student/home_dashboard.dart';
import 'student/schedule_screen.dart';
import 'student/grades_screen.dart';
import 'student/services_screen.dart';
import 'common/settings_screen.dart';
import 'faculty/faculty_dashboard.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentController>().loadInitialData();
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final controller = context.watch<StudentController>();

    if (controller.role == UserRole.faculty) {
      return const FacultyDashboardScreen();
    }

    final pages = [
      HomeDashboardScreen(onNavigateTab: _onTabTapped),
      const ScheduleScreen(),
      const GradesScreen(),
      const ServicesScreen(),
      const SettingsScreen(),
    ];

    final destinations = [
      AdaptiveNavigationDestination(
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard_rounded,
        label: locale.tr('nav_home'),
      ),
      AdaptiveNavigationDestination(
        icon: Icons.calendar_today_outlined,
        selectedIcon: Icons.calendar_month_rounded,
        label: locale.tr('nav_schedule'),
      ),
      AdaptiveNavigationDestination(
        icon: Icons.assessment_outlined,
        selectedIcon: Icons.assessment_rounded,
        label: locale.tr('nav_grades'),
      ),
      AdaptiveNavigationDestination(
        icon: Icons.receipt_long_outlined,
        selectedIcon: Icons.receipt_long_rounded,
        label: locale.tr('nav_services'),
      ),
      AdaptiveNavigationDestination(
        icon: Icons.person_outline_rounded,
        selectedIcon: Icons.person_rounded,
        label: locale.tr('nav_profile'),
      ),
    ];

    return AdaptiveScaffold(
      currentIndex: _currentIndex,
      onNavigationIndexChanged: _onTabTapped,
      destinations: destinations,
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
    );
  }
}
