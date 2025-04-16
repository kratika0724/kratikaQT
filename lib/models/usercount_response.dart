class UserCountResponse {
  final bool success;
  final String message;
  final int status;
  final TotalCount total;

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
      total: TotalCount.fromJson(json['total'] ?? {}),
    );
  }
}

class TotalCount {
  final int userCount;
  final int productCount;

  TotalCount({
    required this.userCount,
    required this.productCount,
  });

  factory TotalCount.fromJson(Map<String, dynamic> json) {
    return TotalCount(
      userCount: json['userCount'] ?? 0,
      productCount: json['productCount'] ?? 0,
    );
  }
}
