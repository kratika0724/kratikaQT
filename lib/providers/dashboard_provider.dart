import 'package:flutter/material.dart';
import 'package:qt_distributer/services/api_path.dart';
import '../models/response models/dashboard_response.dart';
import '../services/api_service.dart';
import '../services/user_preferences.dart';

class DashboardProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  bool isLoading = false;
  String? error;

  DashboardResponse? _userCountData;
  DashboardResponse? get userCountData => _userCountData;

  int get userCount => _userCountData?.total.userCount ?? 0;
  int get productCount => _userCountData?.total.productCount ?? 0;

  String? user_firstname = "";
  String? user_middlename = "";
  String? user_lastname = "";
  String? user_mobile_no = "";
  String? user_email_id = "";

  String get fullName {
    List<String> parts = [
      user_firstname ?? "",
      user_middlename ?? "",
      user_lastname ?? ""
    ];
    return parts.where((part) => part.trim().isNotEmpty).join(" ");
  }

  Future<void> fetchUserCountData(String token) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await apiService.getAuth(ApiPath.getUSerCountDashboardData, {});
      final mResponse = DashboardResponse.fromJson(response);
      if (mResponse.success) {
        _userCountData = mResponse;
      } else {
        error = "Failed to load data: ${mResponse.message}";
      }
    } catch (e) {
      error = "Error: $e";
    }

    isLoading = false;
    notifyListeners();
  }

  void getCustomerDatafromLocal() {
    PreferencesServices.getPreferencesData(PreferencesServices.firstName).then((firstname) {
      user_firstname = (firstname?.toString() ?? "").isEmpty || firstname == ""
          ? "Username"
          : firstname.toString();
    });
    PreferencesServices.getPreferencesData(PreferencesServices.middleName).then((middlename) {
      user_middlename = (middlename?.toString() ?? "") == "" ? "" : middlename.toString();
    });
    PreferencesServices.getPreferencesData(PreferencesServices.lastName).then((lastname) {
      user_lastname = (lastname?.toString() ?? "").isEmpty || lastname == ""
          ? ""
          : lastname.toString();
    });
    PreferencesServices.getPreferencesData(PreferencesServices.mobileNo).then((mobile) {
      user_mobile_no = (mobile?.toString() ?? "") == "null" ? "Mobile number" : mobile.toString();
    });

    notifyListeners();
  }
}
