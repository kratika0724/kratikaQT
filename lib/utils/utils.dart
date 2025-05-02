import 'package:flutter/cupertino.dart';
import '../constants/commonString.dart';
import '../models/response models/verify_otp_response.dart';
import '../services/user_preferences.dart';


Future<bool> checkLogin() async {
  bool isLogin = false;
  try {
    final resultValue = await PreferencesServices.getPreferencesData(PreferencesServices.isLogin);
    debugPrint("resultValue: $resultValue");
    isLogin = resultValue;
  } catch(e) {}
  return isLogin;
}

void setUserData(User userData) {
  PreferencesServices.setPreferencesData(
    PreferencesServices.userId,
    userData.id ?? '',
  );
  PreferencesServices.setPreferencesData(
    PreferencesServices.firstName,
    userData.firstName?? '',
  );
  PreferencesServices.setPreferencesData(
    PreferencesServices.middleName,
    userData.middleName ?? '',
  );
  PreferencesServices.setPreferencesData(
    PreferencesServices.lastName,
    userData.lastName?? '',
  );
  PreferencesServices.setPreferencesData(
    PreferencesServices.emailId,
    userData.email ?? '',
  );
  PreferencesServices.setPreferencesData(
    PreferencesServices.mobileNo,
    userData.mobile ?? '',
  );
  PreferencesServices.setPreferencesData(
    PreferencesServices.role,
      userData.role ?? '',
  );
  PreferencesServices.setPreferencesData(
    PreferencesServices.profileImg,
    userData.profileImg ?? '',
      );
  PreferencesServices.setPreferencesData(
    PreferencesServices.roleName,
    userData.roleName ?? '',
  );
  PreferencesServices.setPreferencesData(
    PreferencesServices.customerId,
    userData.customerId ?? '',
  );
  // distributor OR vendor_pages
  // final roleName = (userData.roleName ?? '').toLowerCase().trim();
  // if (roleName == 'distributor') {
  //   is_distributer = true;
  // } else {
  //   is_distributer = false;
  // }
  //
  // debugPrint('Role: $roleName');
  // debugPrint('Is Distributor: $is_distributer');
}
