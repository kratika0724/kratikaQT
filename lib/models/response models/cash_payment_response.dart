class CashPaymentResponse {
  final bool success;
  final int status;
  final double userBalance;
  final double walletAmountToPay;
  final double updatedBalance;
  final double previousLien;
  final double updatedLien;
  final String message;

  CashPaymentResponse({
    required this.success,
    required this.status,
    required this.userBalance,
    required this.walletAmountToPay,
    required this.updatedBalance,
    required this.previousLien,
    required this.updatedLien,
    required this.message,
  });

  factory CashPaymentResponse.fromJson(Map<String, dynamic> json) {
    return CashPaymentResponse(
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
      userBalance: (json['userBalance'] ?? 0).toDouble(),
      walletAmountToPay: (json['walletAmountToPay'] ?? 0).toDouble(),
      updatedBalance: (json['updatedBalance'] ?? 0).toDouble(),
      previousLien: (json['previous_lien'] ?? 0).toDouble(),
      updatedLien: (json['updated_lien'] ?? 0).toDouble(),
      message: json['message'] ?? '',
    );
  }
}
