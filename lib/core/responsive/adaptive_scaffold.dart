import 'package:flutter/material.dart';
import '../theme/thebes_colors.dart';
import 'responsive_helper.dart';

class AdaptiveNavigationDestination {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const AdaptiveNavigationDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

class AdaptiveScaffold extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onNavigationIndexChanged;
  final List<AdaptiveNavigationDestination> destinations;
  final Widget body;
  final Widget? drawer;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;

  const AdaptiveScaffold({
    super.key,
    required this.currentIndex,
    required this.onNavigationIndexChanged,
    required this.destinations,
    required this.body,
    this.drawer,
    this.appBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final isTabletOrDesktop = context.isTablet || context.isDesktop;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isTabletOrDesktop) {
      return Scaffold(
        appBar: appBar,
        drawer: drawer,
        floatingActionButton: floatingActionButton,
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: currentIndex,
              onDestinationSelected: onNavigationIndexChanged,
              labelType: NavigationRailLabelType.all,
              backgroundColor: isDark ? ThebesColors.darkSurface : Colors.white,
              selectedIconTheme: const IconThemeData(color: ThebesColors.gold),
              unselectedIconTheme: IconThemeData(
                color: isDark ? Colors.white60 : ThebesColors.lightTextSecondary,
              ),
              selectedLabelTextStyle: const TextStyle(
                color: ThebesColors.gold,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              unselectedLabelTextStyle: TextStyle(
                color: isDark ? Colors.white60 : ThebesColors.lightTextSecondary,
                fontSize: 11,
              ),
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ThebesColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: ThebesColors.gold, width: 1.5),
                  ),
                  child: const Icon(Icons.school_rounded, color: ThebesColors.gold, size: 24),
                ),
              ),
              destinations: destinations.map((d) {
                return NavigationRailDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(d.selectedIcon),
                  label: Text(d.label),
                );
              }).toList(),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? ThebesColors.darkSurface : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? ThebesColors.darkCardBorder : ThebesColors.lightCardBorder,
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onNavigationIndexChanged,
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? ThebesColors.darkSurface : Colors.white,
          selectedItemColor: ThebesColors.gold,
          unselectedItemColor: isDark ? Colors.white60 : ThebesColors.lightTextSecondary,
          selectedFontSize: 11.5,
          unselectedFontSize: 10.5,
          elevation: 0,
          items: destinations.map((d) {
            return BottomNavigationBarItem(
              icon: Icon(d.icon),
              activeIcon: Icon(d.selectedIcon),
              label: d.label,
            );
          }).toList(),
        ),
      ),
    );
  }
}
