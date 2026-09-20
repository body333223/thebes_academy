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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Container(
            height: 66,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0C182B).withAlpha(240) : Colors.white.withAlpha(245),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? ThebesColors.darkCardBorder : ThebesColors.gold.withAlpha(80),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? Colors.black : ThebesColors.primaryDark).withAlpha(isDark ? 80 : 35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(destinations.length, (index) {
                final d = destinations[index];
                final isSelected = index == currentIndex;

                return Expanded(
                  child: InkWell(
                    onTap: () => onNavigationIndexChanged(index),
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? ThebesColors.gold.withAlpha(isDark ? 40 : 30)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              isSelected ? d.selectedIcon : d.icon,
                              color: isSelected
                                  ? ThebesColors.gold
                                  : (isDark ? Colors.white60 : ThebesColors.lightTextSecondary),
                              size: 22,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            d.label,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              color: isSelected
                                  ? ThebesColors.gold
                                  : (isDark ? Colors.white54 : ThebesColors.lightTextSecondary),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
