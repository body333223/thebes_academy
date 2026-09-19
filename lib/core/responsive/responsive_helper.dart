import 'package:flutter/material.dart';
import 'responsive_breakpoints.dart';

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  Orientation get orientation => MediaQuery.orientationOf(this);

  bool get isMobileSmall => screenWidth < ResponsiveBreakpoints.mobileSmall;
  bool get isMobile => screenWidth < ResponsiveBreakpoints.mobile;
  bool get isTablet =>
      screenWidth >= ResponsiveBreakpoints.mobile && screenWidth < ResponsiveBreakpoints.tablet;
  bool get isDesktop => screenWidth >= ResponsiveBreakpoints.tablet;
  bool get isLandscape => orientation == Orientation.landscape;

  DeviceScreenType get deviceType => ResponsiveBreakpoints.getDeviceType(screenWidth);

  T responsiveValue<T>({
    required T mobile,
    T? tablet,
    T? desktop,
    T? mobileSmall,
  }) {
    if (isMobileSmall && mobileSmall != null) return mobileSmall;
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  int get responsiveGridColumns {
    if (isDesktop) return 4;
    if (isTablet) return isLandscape ? 3 : 2;
    return 1;
  }

  EdgeInsets get responsiveScreenPadding {
    if (isDesktop) {
      final horizontal = (screenWidth - ResponsiveBreakpoints.maxContentWidth) / 2;
      return EdgeInsets.symmetric(horizontal: horizontal > 24 ? horizontal : 24, vertical: 20);
    }
    if (isTablet) {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
    return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  }
}

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= ResponsiveBreakpoints.tablet && desktop != null) {
          return desktop!;
        }
        if (constraints.maxWidth >= ResponsiveBreakpoints.mobile && tablet != null) {
          return tablet!;
        }
        return mobile;
      },
    );
  }
}
