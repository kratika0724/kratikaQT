class VendorPaymentFilterModel {
  String? transactionId;
  String? email;
  String? status;
  String? transactionType;
  DateTime? startDate;
  DateTime? endDate;

  String? get formattedDateRange {
    if (startDate != null && endDate != null) {
      return '${startDate!.toIso8601String().substring(0, 10)} - ${endDate!.toIso8601String().substring(0, 10)}';
    }
    return null;
  }

  void clear() {
    transactionId = null;
    email = null;
    status = null;
    transactionType = null;
    startDate = null;
    endDate = null;
  }

  Map<String, String?> toMap() {
    return {
      'Transaction ID': transactionId,
      'Email': email,
      'Transaction Type': transactionType,
      'Transaction Status': status,
      'Date Range': formattedDateRange,
    };
  }

  bool get hasFilters => toMap().values.any((v) => v != null);
}
