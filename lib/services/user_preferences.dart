import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesServices{

  static String apiToken = "apiToken";
  static String isLogin = "isLogin";

  static String userId = "userId";
  static String firstName = "firstName";
  static String middleName = "middleName";
  static String lastName = "lastName";
  static String emailId = "emailId";
  static String mobileNo = "mobileNo";
  static String role = "role";
  static String profileImg = "profileImg";
  static String roleName = "roleName";
  static String customerId = "customerId";


  ///..... SharePrefences save data ........
  static void setPreferencesData(String key, dynamic data) async {
    final prefences = await SharedPreferences.getInstance();
    if (data is String) {
      prefences.setString(key, data);
    } else if (data is int) {
      prefences.setInt(key, data);
    } else if (data is bool) {
      prefences.setBool(key, data);
    } else if (data is double) {
      prefences.setDouble(key, data);
    } else {
      debugPrint("Invalid datatype");
    }
  }


  static Future<dynamic> getPreferencesData(String key) async {
    final preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey(key)) {
      // Try to determine the type of the stored data
      dynamic data = preferences.get(key);
      debugPrint(key);
      return data;
    } else {
      debugPrint("Key not found");
      return null;
    }
  }


  static void setLogoutPreferencesData(){
    setPreferencesData(isLogin, false);
    setPreferencesData(apiToken,"");
  }


  ///---------------------Delete Data------------------------

  static Future<bool> deleteData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }


  ///---------------------Clear all Data------------------------

  static Future clearData() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}