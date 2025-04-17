import 'package:flutter/widgets.dart';

class DeviceUtils {
  // Get the device width
  static bool getDeviceWidth(BuildContext context) {
    return MediaQuery.of(context).size.width > 600;
  }

  // Get the device height
  static double getDeviceHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}
