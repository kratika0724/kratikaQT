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
  int get customerCount => _userCountData?.total.customerCount ?? 0;

  String? user_firstname = "";
  String? user_middlename = "";
  String? user_lastname = "";
  String? user_mobile_no = "";
  String? user_email_id = "";
  String? user_role = "";
  String? user_profile_img = "";
  String? user_role_name = "";
  String? user_customer_id = "";
  String? user_id = "";

  String get fullName {
    List<String> parts = [
      user_firstname ?? "",
      user_middlename ?? "",
      user_lastname ?? ""
    ];
    return parts.where((part) => part.trim().isNotEmpty).join(" ");
  }

  Future<void> fetchUserCountData(BuildContext context, String token) async {

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await apiService
          .getAuth(context, ApiPath.getDashboardData, {});
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
    PreferencesServices.getPreferencesData(PreferencesServices.userId)
        .then((userid) {
      user_id = (userid?.toString() ?? "").isEmpty || userid == ""
          ? "UserId"
          : userid.toString();
    });
    PreferencesServices.getPreferencesData(PreferencesServices.firstName)
        .then((firstname) {
      user_firstname = (firstname?.toString() ?? "").isEmpty || firstname == ""
          ? "Username"
          : firstname.toString();
    });
    PreferencesServices.getPreferencesData(PreferencesServices.middleName)
        .then((middlename) {
      user_middlename =
          (middlename?.toString() ?? "") == "" ? "" : middlename.toString();
    });
    PreferencesServices.getPreferencesData(PreferencesServices.lastName)
        .then((lastname) {
      user_lastname = (lastname?.toString() ?? "").isEmpty || lastname == ""
          ? ""
          : lastname.toString();
    });
    PreferencesServices.getPreferencesData(PreferencesServices.mobileNo)
        .then((mobile) {
      user_mobile_no = (mobile?.toString() ?? "") == ""
          ? "Mobile number"
          : mobile.toString();
    });
    PreferencesServices.getPreferencesData(PreferencesServices.emailId)
        .then((email) {
      user_email_id = (email?.toString() ?? "").isEmpty || email == ""
          ? "Email ID"
          : email.toString();
    });
    PreferencesServices.getPreferencesData(PreferencesServices.role)
        .then((role) {
      user_role = (role?.toString() ?? "").isEmpty || role == ""
          ? "Role"
          : role.toString();
    });
    PreferencesServices.getPreferencesData(PreferencesServices.profileImg)
        .then((profileImg) {
      user_profile_img = (profileImg?.toString() ?? "").isEmpty ||
              profileImg == ""
          // ? "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
          ? "https://www.gravatar.com/avatar/2c7d99fe281ecd3bcd65ab915bac6dd5?s=250"
          : profileImg.toString();
    });
    PreferencesServices.getPreferencesData(PreferencesServices.roleName)
        .then((roleName) {
      user_role_name = (roleName?.toString() ?? "").isEmpty || roleName == ""
          ? ""
          : roleName.toString();
    });

    PreferencesServices.getPreferencesData(PreferencesServices.customerId)
        .then((customerId) {
      user_customer_id =
          (customerId?.toString() ?? "").isEmpty || customerId == ""
              ? ""
              : customerId.toString();
    });

    notifyListeners();
  }
}
