class PaymentModel {
  final String status;
  final String transactiontype;
  final String transactionId;
  final String name;
  final String email;
  final String mobile;
  final String amount;
  final String createdAt;

  PaymentModel({
    required this.status,
    required this.transactionId,
    required this.transactiontype,
    required this.name,
    required this.email,
    required this.mobile,
    required this.amount,
    required this.createdAt,
  });

  /// Factory to create [PaymentModel] from a map
  factory PaymentModel.fromMap(Map<String, String> map) {
    return PaymentModel(
      status: map['status'] ?? '',
      transactionId: map['transactionId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      amount: map['amount'] ?? '',
      createdAt: map['createdAt'] ?? '',
      transactiontype: map['transactiontype'] ?? '',
      mobile: map['mobile'] ?? '',
    );
  }

  /// Optional: Convert back to map
  Map<String, String> toMap() {
    return {
      'status': status,
      'transactionId': transactionId,
      'name': name,
      'email': email,
      'amount': amount,
      'createdAt': createdAt,
      'transactiontype': transactiontype,
      'mobile': mobile,
    };
  }
}

final List<Map<String, String>> samplePayments = [
  {
    'status': 'Success',
    'transactionId': 'TXN123456',
    'name': 'John Doe',
    'email': 'john@example.com',
    'amount': '₹ 500',
    'createdAt': '10 Apr 2025, 10:00 AM',
    'transactiontype': 'Credit',
    'mobile': '9876543210'
  },
  {
    'status': 'Pending',
    'transactionId': 'TXN654321',
    'name': 'Jane Smith',
    'email': 'jane@example.com',
    'amount': '₹ 850',
    'createdAt': '09 Apr 2025, 8:50 AM',
    'transactiontype': 'Debit',
    'mobile': '9876543210'
  },
  {
    'status': 'Failed',
    'transactionId': 'TXN123789',
    'name': 'Smith B.',
    'email': 'smith@example.com',
    'amount': '₹ 1300',
    'createdAt': '11 Apr 2025, 1:00 PM',
    'transactiontype': 'Credit',
    'mobile': '9876543210'
  },
];

