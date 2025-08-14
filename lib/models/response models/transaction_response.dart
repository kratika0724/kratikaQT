class TransactionResponseModel {
  final bool success;
  final bool fromCache;
  final String message;
  final int status;
  final List<TransactionData> data;
  final Meta meta;

  TransactionResponseModel({
    required this.success,
    required this.fromCache,
    required this.message,
    required this.status,
    required this.data,
    required this.meta,
  });

  factory TransactionResponseModel.fromJson(Map<String, dynamic> json) {
    return TransactionResponseModel(
      success: json['success'] ?? false,
      fromCache: json['fromCache'] ?? false,
      message: json['message'] ?? '',
      status: json['status'] ?? 0,
      data: (json['data'] != null && json['data'] is List)
          ? List<TransactionData>.from(
              json['data'].map((x) => TransactionData.fromJson(x)))
          : [],
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

class TransactionData {
  final String id;
  final double customerCommission;
  final double serviceCharge;
  final double transactionAmount;
  final String referenceNo;
  final String quintusTransactionId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final TransactionUser user;
  final WalletHistory walletHistory;

  TransactionData({
    required this.id,
    required this.customerCommission,
    required this.serviceCharge,
    required this.transactionAmount,
    required this.referenceNo,
    required this.quintusTransactionId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.walletHistory,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      id: json['_id'] ?? '',
      customerCommission: (json['customerCommission'] ?? 0).toDouble(),
      serviceCharge: (json['serviceCharge'] ?? 0).toDouble(),
      transactionAmount: double.tryParse((json['transactionAmount'] ?? '0')
              .toString()
              .replaceAll('-', '')) ??
          0.0,
      referenceNo: json['referenceNo'] ?? '',
      quintusTransactionId: json['quintus_transaction_id'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      user: json['user'] != null
          ? TransactionUser.fromJson(json['user'])
          : TransactionUser.empty(),
      walletHistory: json['walletHistory'] != null
          ? WalletHistory.fromJson(json['walletHistory'])
          : WalletHistory.empty(),
    );
  }
}

class TransactionUser {
  final String firstName;
  final String middleName;
  final String lastName;
  final String email;
  final String mobile;
  final String topUser;

  TransactionUser({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.topUser,
  });

  factory TransactionUser.empty() {
    return TransactionUser(
      firstName: '',
      middleName: '',
      lastName: '',
      email: '',
      mobile: '',
      topUser: '',
    );
  }
  factory TransactionUser.fromJson(Map<String, dynamic> json) {
    return TransactionUser(
      firstName: json['first_name'],
      middleName: json['middle_name'],
      lastName: json['last_name'],
      email: json['email'],
      mobile: json['mobile'],
      topUser: json['topUser'],
    );
  }
}

class WalletHistory {
  final List<Map<String, dynamic>> serviceDetails;
  final double previousBalance;
  final double previousPayoutBalance;
  final double amount;
  final double updatedBalance;
  final double updatedPayoutBalance;
  final String walletType;
  final String transactionType;

  WalletHistory({
    required this.serviceDetails,
    required this.previousBalance,
    required this.previousPayoutBalance,
    required this.amount,
    required this.updatedBalance,
    required this.updatedPayoutBalance,
    required this.walletType,
    required this.transactionType,
  });

  // Empty constructor for fallback
  factory WalletHistory.empty() {
    return WalletHistory(
      serviceDetails: [],
      previousBalance: 0.0,
      previousPayoutBalance: 0.0,
      amount: 0.0,
      updatedBalance: 0.0,
      updatedPayoutBalance: 0.0,
      walletType: '',
      transactionType: '',
    );
  }

  factory WalletHistory.fromJson(Map<String, dynamic> json) {
    return WalletHistory(
      serviceDetails: (json['serviceDetails'] != null &&
              json['serviceDetails'] is List)
          ? List<Map<String, dynamic>>.from(
              json['serviceDetails'].map((x) => Map<String, dynamic>.from(x)))
          : [],
      previousBalance: (json['previous_balance'] ?? 0.0).toDouble(),
      previousPayoutBalance:
          (json['previous_payout_balance'] ?? 0.0).toDouble(),
      amount: (json['amount'] ?? 0.0).toDouble(),
      updatedBalance: (json['updated_balance'] ?? 0.0).toDouble(),
      updatedPayoutBalance: (json['updated_payout_balance'] ?? 0.0).toDouble(),
      walletType: json['walletType'] ?? '',
      transactionType: json['transactionType'] ?? '',
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
      currentPage: json['current_page'],
      from: json['from'],
      lastPage: json['last_page'],
      perPage: json['per_page'],
      to: json['to'],
      total: json['total'],
    );
  }
}
