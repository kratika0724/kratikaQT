import 'package:flutter/widgets.dart';
import 'package:qt_distributer/constants/commonString.dart';

class DeviceUtils {
  // Get the device width
  static bool getDeviceWidth(BuildContext context) {
    return MediaQuery.of(context).size.width > widthThreshold;
  }

  // Get the device height
  static double getDeviceHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}
