class DashboardResponse {
  final bool success;
  final String message;
  final int status;
  final TotalCount total;

  DashboardResponse({
    required this.success,
    required this.message,
    required this.status,
    required this.total,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
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
  final int customerCount;

  TotalCount({
    required this.userCount,
    required this.productCount,
    required this.customerCount,
  });

  factory TotalCount.fromJson(Map<String, dynamic> json) {
    return TotalCount(
      userCount: json['userCount'] ?? 0,
      productCount: json['productCount'] ?? 0,
      customerCount: json['customerCount'] ?? 0,
    );
  }
}
