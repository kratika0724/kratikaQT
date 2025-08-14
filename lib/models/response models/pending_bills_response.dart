class PendingBillsResponseModel {
  final bool success;
  final int status;
  final String message;
  final List<PendingBillData> data;
  final Map<String, dynamic> totals;
  final Meta meta;

  PendingBillsResponseModel({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
    required this.totals,
    required this.meta,
  });

  factory PendingBillsResponseModel.fromJson(Map<String, dynamic> json) {
    return PendingBillsResponseModel(
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] != null && json['data'] is List)
          ? List<PendingBillData>.from(
              json['data'].map((x) => PendingBillData.fromJson(x)))
          : [],
      totals: json['totals'] ?? {},
      meta: json['meta'] != null
          ? Meta.fromJson(json['meta'])
          : Meta(
              currentPage: 1,
              from: 0,
              lastPage: 1,
              perPage: 10,
              to: 0,
              total: 0),
    );
  }
}

class PendingBillData {
  final String id;
  final String firstName;
  final String middleName;
  final String lastName;
  final String mobile;
  final String email;
  final List<WalletHistoryItem> walletHistory;
  final double balance;

  PendingBillData({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.mobile,
    required this.email,
    required this.walletHistory,
    required this.balance,
  });

  factory PendingBillData.fromJson(Map<String, dynamic> json) {
    return PendingBillData(
      id: json['_id'] ?? '',
      firstName: json['first_name'] ?? '',
      middleName: json['middle_name'] ?? '',
      lastName: json['last_name'] ?? '',
      mobile: json['mobile'] ?? '',
      email: json['email'] ?? '',
      walletHistory: (json['walletHistory'] != null &&
              json['walletHistory'] is List)
          ? List<WalletHistoryItem>.from(
              json['walletHistory'].map((x) => WalletHistoryItem.fromJson(x)))
          : [],
      balance: double.tryParse(
              (json['balance'] ?? '0').toString().replaceAll('-', '')) ??
          0.0,
    );
  }

  String get fullName {
    List<String> parts = [firstName, middleName, lastName];
    return parts.where((part) => part.trim().isNotEmpty).join(" ");
  }
}

class WalletHistoryItem {
  final String id;
  final String userId;
  final double previousBalance;
  final double previousPayoutBalance;
  final double amount;
  final double previousLien;
  final double updatedLien;
  final double updatedBalance;
  final double updatedPayoutBalance;
  final String walletType;
  final String transactionType;
  final String action;
  final String originalUrl;
  final int revisionCount;
  final String notes;
  final bool isActive;
  final DateTime createdAt;
  final String createdBy;
  final DateTime updatedAt;
  final String updatedBy;
  final List<dynamic> updatedRecord;

  WalletHistoryItem({
    required this.id,
    required this.userId,
    required this.previousBalance,
    required this.previousPayoutBalance,
    required this.amount,
    required this.previousLien,
    required this.updatedLien,
    required this.updatedBalance,
    required this.updatedPayoutBalance,
    required this.walletType,
    required this.transactionType,
    required this.action,
    required this.originalUrl,
    required this.revisionCount,
    required this.notes,
    required this.isActive,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    required this.updatedRecord,
  });

  factory WalletHistoryItem.fromJson(Map<String, dynamic> json) {
    return WalletHistoryItem(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      previousBalance: (json['previous_balance'] ?? 0).toDouble(),
      previousPayoutBalance: (json['previous_payout_balance'] ?? 0).toDouble(),
      amount: (json['amount'] ?? 0).toDouble(),
      previousLien: (json['previous_lien'] ?? 0).toDouble(),
      updatedLien: (json['updated_lien'] ?? 0).toDouble(),
      updatedBalance: (json['updated_balance'] ?? 0).toDouble(),
      updatedPayoutBalance: (json['updated_payout_balance'] ?? 0).toDouble(),
      walletType: json['walletType'] ?? '',
      transactionType: json['transactionType'] ?? '',
      action: json['action'] ?? '',
      originalUrl: json['originalUrl'] ?? '',
      revisionCount: json['revisionCount'] ?? 0,
      notes: json['notes'] ?? '',
      isActive: json['is_active'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      createdBy: json['created_by'] ?? '',
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      updatedBy: json['updated_by'] ?? '',
      updatedRecord: json['updated_record'] ?? [],
    );
  }
}

class Meta {
  final int currentPage;
  final int from;
  final int lastPage;
  final int perPage;
  final int to;
  final int total;

  Meta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.perPage,
    required this.to,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      currentPage: json['current_page'] ?? 1,
      from: json['from'] ?? 0,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 10,
      to: json['to'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}
