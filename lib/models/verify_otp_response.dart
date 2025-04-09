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
    return User(
      id: json['id'] ?? '',
      firstName: json['first_name'] ?? '',
      middleName: json['middle_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      role: json['role'] ?? '',
      profileImg: json['profile_img'] ?? '',
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