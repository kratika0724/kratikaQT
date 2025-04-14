class UserCountResponse {
  final bool success;
  final String message;
  final int status;
  final int total;

  UserCountResponse({
    required this.success,
    required this.message,
    required this.status,
    required this.total,
  });

  factory UserCountResponse.fromJson(Map<String, dynamic> json) {
    return UserCountResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      status: json['status'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}
