class VendorRequestFilterModel {
  String? transactionId;
  String? email;
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
    startDate = null;
    endDate = null;
  }

  Map<String, String?> toMap() {
    return {
      'Transaction ID': transactionId,
      'Email': email,
      'Date Range': formattedDateRange,
    };
  }

  bool get hasFilters => toMap().values.any((v) => v != null);
}
