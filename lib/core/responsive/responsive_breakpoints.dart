enum DeviceScreenType {
  mobileSmall, // < 360
  mobile,      // 360 - 599
  tablet,      // 600 - 1023
  desktop,     // >= 1024
}

class ResponsiveBreakpoints {
  static const double mobileSmall = 360;
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double maxContentWidth = 1140;

  static DeviceScreenType getDeviceType(double width) {
    if (width < mobileSmall) return DeviceScreenType.mobileSmall;
    if (width < mobile) return DeviceScreenType.mobile;
    if (width < tablet) return DeviceScreenType.tablet;
    return DeviceScreenType.desktop;
  }
}
