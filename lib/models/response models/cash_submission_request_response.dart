class CashSubmissionRequestResponse {
  final bool success;
  final int status;
  final String message;
  final List<CashSubmissionRequestData> data;

  CashSubmissionRequestResponse({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
  });

  factory CashSubmissionRequestResponse.fromJson(Map<String, dynamic> json) {
    return CashSubmissionRequestResponse(
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => CashSubmissionRequestData.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class CashSubmissionRequestData {
  final String id;
  final int amount;
  final String note;
  final String createdAt;
  final String status;
  final String updatedAt;
  final String agentName;
  final String topUserName;

  CashSubmissionRequestData({
    required this.id,
    required this.amount,
    required this.note,
    required this.createdAt,
    required this.status,
    required this.updatedAt,
    required this.agentName,
    required this.topUserName,
  });

  factory CashSubmissionRequestData.fromJson(Map<String, dynamic> json) {
    return CashSubmissionRequestData(
      id: json['_id'] ?? '',
      amount: json['amount'] ?? 0,
      note: json['note'] ?? '',
      createdAt: json['created_at'] ?? '',
      status: json['status'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      agentName: json['agentName'] ?? '',
      topUserName: json['topUserName'] ?? '',
    );
  }
}
