class UserDataResponse {
  final bool success;
  final int status;
  final String message;
  final UserData data;

  UserDataResponse({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
  });

  factory UserDataResponse.fromJson(Map<String, dynamic> json) {
    return UserDataResponse(
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: UserData.fromJson(json['data'] ?? {}),
    );
  }
}

class UserData {
  final String id;
  final String userId;
  final double balance;
  final double lien;
  final double holdAmount;
  final double payoutBalance;
  final bool isActive;
  final String createdAt;
  final String createdBy;
  final String updatedAt;
  final String updatedBy;
  final List<dynamic> updatedRecord;
  final String firstName;
  final String middleName;
  final String lastName;
  final String email;
  final String mobile;
  final String quintusId;

  UserData({
    required this.id,
    required this.userId,
    required this.balance,
    required this.lien,
    required this.holdAmount,
    required this.payoutBalance,
    required this.isActive,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    required this.updatedRecord,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.quintusId,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      lien: (json['lien'] ?? 0).toDouble(),
      holdAmount: (json['hold_amount'] ?? 0).toDouble(),
      payoutBalance: (json['payout_balance'] ?? 0).toDouble(),
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] ?? '',
      createdBy: json['created_by'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      updatedBy: json['updated_by'] ?? '',
      updatedRecord: json['updated_record'] ?? [],
      firstName: json['first_name'] ?? '',
      middleName: json['middle_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      quintusId: json['quintus_id'] ?? '',
    );
  }
}
