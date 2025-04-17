import 'package:qt_distributer/services/api_path.dart';

class VerifyOtpResponse {
  final bool success;
  final int status;
  final String message;
  final String accessToken;
  final String refreshToken;
  final User user;

  VerifyOtpResponse({
    required this.success,
    required this.status,
    required this.message,
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'status': status,
      'message': message,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': user.toJson(),
    };
  }
}

class User {
  final String id;
  final String firstName;
  final String middleName;
  final String lastName;
  final String email;
  final String mobile;
  final String role;
  final String profileImg;
  final String roleName;
  final String customerId;

  User({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.role,
    required this.profileImg,
    required this.roleName,
    required this.customerId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // const String baseUrl = ApiPath.imageURL;

    return User(
      id: json['id'] ?? '',
      firstName: json['first_name'] ?? '',
      middleName: json['middle_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      role: json['role'] ?? '',
      profileImg: json['profile_img'] ?? '',
      // profileImg: json['profile_img'] != null
          // ? baseUrl + json['profile_img']
          // : '',
      roleName: json['roleName'] ?? '',
      customerId: json['customerId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'email': email,
      'mobile': mobile,
      'role': role,
      'profile_img': profileImg,
      'roleName': roleName,
      'customerId': customerId,
    };
  }
}


// "user":{
// "id":"67a5994be99375d3b9bb16c7",
// "first_name":"Anuj",
// "middle_name":"",
// "last_name":"Singh",
// "email":"anuj@voso.store",
// "mobile":"9109854123",
// "role":"67a1c0b1d12daf2082ba4e21",
// "profile_img":"",
// "roleName":"Distributor",
// "customerId":"QT-100003"
// }}}