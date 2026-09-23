import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        backgroundColor: isDark ? ThebesColors.darkBackground : ThebesColors.pageBg,
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
              indicatorColor: ThebesColors.orangePale,
              selectedIconTheme: const IconThemeData(color: ThebesColors.orange, size: 24),
              unselectedIconTheme: IconThemeData(
                color: isDark ? ThebesColors.slateLight : ThebesColors.slate,
                size: 22,
              ),
              selectedLabelTextStyle: GoogleFonts.cairo(
                color: ThebesColors.orange,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
              unselectedLabelTextStyle: GoogleFonts.cairo(
                color: isDark ? ThebesColors.slateLight : ThebesColors.slate,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: ThebesColors.logoGradient,
                    boxShadow: [
                      BoxShadow(
                        color: ThebesColors.orange.withAlpha(60),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'TA',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
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
            VerticalDivider(
              thickness: 1,
              width: 1,
              color: isDark ? ThebesColors.darkCardBorder : ThebesColors.lightCardBorder,
            ),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? ThebesColors.darkBackground : ThebesColors.pageBg,
      appBar: appBar,
      drawer: drawer,
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: _TheebaBottomBar(
        currentIndex: currentIndex,
        destinations: destinations,
        onTap: onNavigationIndexChanged,
      ),
    );
  }
}

class _TheebaBottomBar extends StatelessWidget {
  final int currentIndex;
  final List<AdaptiveNavigationDestination> destinations;
  final ValueChanged<int> onTap;

  const _TheebaBottomBar({
    required this.currentIndex,
    required this.destinations,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? ThebesColors.darkSurface : Colors.white;
    final borderColor = isDark ? ThebesColors.darkCardBorder : const Color(0xFFE2E8F0);

    return Container(
      height: 68 + MediaQuery.of(context).padding.bottom,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          top: BorderSide(
            color: borderColor,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 50 : 15),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(destinations.length, (index) {
            final d = destinations[index];
            final isSelected = index == currentIndex;
            final isCenterBtn = index == 2;

            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(index),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  height: 68,
                  child: isCenterBtn
                      ? _buildCenterButton(d, isSelected)
                      : _buildNavItem(d, isSelected, isDark),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildNavItem(AdaptiveNavigationDestination d, bool isSelected, bool isDark) {
    final activeColor = ThebesColors.orange;
    final inactiveColor = isDark ? ThebesColors.slateLight : ThebesColors.slate;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? ThebesColors.orangePale : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isSelected ? d.selectedIcon : d.icon,
            color: isSelected ? activeColor : inactiveColor,
            size: 22,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          d.label,
          style: GoogleFonts.cairo(
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? activeColor : inactiveColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildCenterButton(AdaptiveNavigationDestination d, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Elevated Orange Gradient QR Button
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: ThebesColors.orangeCtaGradient,
            boxShadow: [
              BoxShadow(
                color: ThebesColors.orange.withAlpha(isSelected ? 140 : 80),
                blurRadius: isSelected ? 14 : 8,
                spreadRadius: isSelected ? 1 : 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            isSelected ? d.selectedIcon : d.icon,
            color: Colors.white,
            size: 22,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          d.label,
          style: GoogleFonts.cairo(
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? ThebesColors.orange : ThebesColors.slate,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
