import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thebes_academy/core/localization/locale_provider.dart';
import 'package:thebes_academy/core/responsive/adaptive_scaffold.dart';
import 'package:thebes_academy/features/student/presentation/controllers/student_controller.dart';
import 'package:thebes_academy/features/student/presentation/screens/home_dashboard.dart';
import 'package:thebes_academy/features/student/presentation/screens/schedule_screen.dart';
import 'package:thebes_academy/features/student/presentation/screens/qr_attendance_screen.dart';
import 'package:thebes_academy/features/student/presentation/screens/grades_screen.dart';
import 'package:thebes_academy/features/student/presentation/screens/services_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
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

    final pages = [
      HomeDashboardScreen(onNavigateTab: _onTabTapped),
      const ScheduleScreen(),
      const QrAttendanceScreen(),
      const GradesScreen(),
      const ServicesScreen(),
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
        icon: Icons.qr_code_scanner_rounded,
        selectedIcon: Icons.qr_code_2_rounded,
        label: locale.tr('nav_attendance'),
      ),
      AdaptiveNavigationDestination(
        icon: Icons.assessment_outlined,
        selectedIcon: Icons.assessment_rounded,
        label: locale.tr('nav_grades'),
      ),
      AdaptiveNavigationDestination(
        icon: Icons.account_balance_wallet_outlined,
        selectedIcon: Icons.account_balance_wallet_rounded,
        label: locale.tr('nav_services'),
      ),
    ];

    return Scaffold(
      body: AdaptiveScaffold(
        currentIndex: _currentIndex,
        onNavigationIndexChanged: _onTabTapped,
        destinations: destinations,
        body: IndexedStack(
          index: _currentIndex,
          children: pages,
        ),
      ),
    );
  }
}
