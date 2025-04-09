class OtpResponse {
  final bool success;
  final int status;
  final String message;
  final String authid;
  final String? otp;

  OtpResponse({
    required this.success,
    required this.status,
    required this.message,
    required this.authid,
    this.otp,
  });

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      authid: json['authid'] ?? '',
      otp: json['otp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'status': status,
      'message': message,
      'authid': authid,
      'otp': otp,
    };
  }
} 