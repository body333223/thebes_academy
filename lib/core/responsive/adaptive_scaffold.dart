import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'responsive_helper.dart';

const _indigo = Color(0xFF5C4FF6);
const _violet = Color(0xFF8B3CF7);
const _neonCyan = Color(0xFF00E5FF);
const _voidBg = Color(0xFF000814);
const _surfaceBg = Color(0xFF080D1A);

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

    if (isTabletOrDesktop) {
      return Scaffold(
        backgroundColor: _voidBg,
        appBar: appBar,
        drawer: drawer,
        floatingActionButton: floatingActionButton,
        body: Row(
          children: [
            // Cosmic Navigation Rail
            Container(
              width: 76,
              decoration: BoxDecoration(
                color: _surfaceBg,
                border: Border(
                  right: BorderSide(
                    color: Colors.white.withAlpha(15),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Logo
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [_indigo, _violet],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _indigo.withAlpha(100),
                          blurRadius: 14,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.account_balance_rounded,
                      color: Color(0xFFFFD700),
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(destinations.length, (index) {
                        final d = destinations[index];
                        final isSelected = index == currentIndex;
                        return _buildRailItem(
                          icon: isSelected ? d.selectedIcon : d.icon,
                          label: d.label,
                          isSelected: isSelected,
                          onTap: () => onNavigationIndexChanged(index),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: _voidBg,
      appBar: appBar,
      drawer: drawer,
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: _CosmicBottomBar(
        currentIndex: currentIndex,
        destinations: destinations,
        onTap: onNavigationIndexChanged,
      ),
    );
  }

  Widget _buildRailItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 56,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? _indigo.withAlpha(40) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: isSelected
                ? Border.all(color: _indigo.withAlpha(80), width: 1)
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? _neonCyan : Colors.white38,
                size: 22,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.cairo(
                  fontSize: 9,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? _neonCyan : Colors.white38,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CosmicBottomBar extends StatelessWidget {
  final int currentIndex;
  final List<AdaptiveNavigationDestination> destinations;
  final ValueChanged<int> onTap;

  const _CosmicBottomBar({
    required this.currentIndex,
    required this.destinations,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70 + MediaQuery.of(context).padding.bottom,
      decoration: BoxDecoration(
        color: _surfaceBg,
        border: Border(
          top: BorderSide(
            color: Colors.white.withAlpha(15),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(150),
            blurRadius: 20,
            offset: const Offset(0, -5),
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

            // Center button (index 2 = Attendance) gets special treatment
            final isCenterBtn = index == 2;

            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(index),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  height: 70,
                  child: isCenterBtn
                      ? _buildCenterButton(d, isSelected)
                      : _buildNavItem(d, isSelected),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildNavItem(AdaptiveNavigationDestination d, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          decoration: BoxDecoration(
            color: isSelected ? _indigo.withAlpha(50) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            isSelected ? d.selectedIcon : d.icon,
            color: isSelected ? _neonCyan : Colors.white30,
            size: 22,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          d.label,
          style: GoogleFonts.cairo(
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
            color: isSelected ? _neonCyan : Colors.white30,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildCenterButton(
      AdaptiveNavigationDestination d, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Elevated center QR button
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [_indigo, _violet],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: _indigo.withAlpha(isSelected ? 160 : 80),
                blurRadius: isSelected ? 16 : 8,
                spreadRadius: isSelected ? 2 : 0,
              ),
            ],
          ),
          child: Icon(
            isSelected ? d.selectedIcon : d.icon,
            color: Colors.white,
            size: 22,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          d.label,
          style: GoogleFonts.cairo(
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
            color: isSelected ? _neonCyan : Colors.white30,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
