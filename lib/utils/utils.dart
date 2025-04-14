import 'package:flutter/cupertino.dart';
import '../models/verify_otp_response.dart';
import '../services/user_preferences.dart';


Future<bool> checkLogin() async {
  bool isLogin = false;
  try {
    final resultValue = await PreferencesServices.getPreferencesData(PreferencesServices.isLogin);
    debugPrint("resultValue: $resultValue");
    isLogin = resultValue;
  }
  catch(e)
  {}
  return isLogin;
}

void setUserData(User userData) {
  PreferencesServices.setPreferencesData(
    PreferencesServices.firstName,
    userData.firstName?? '',
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
}
