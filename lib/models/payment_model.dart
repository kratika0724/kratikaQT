class PaymentModel {
  final String status;
  final String transactionId;
  final String name;
  final String email;
  final String amount;
  final String createdAt;

  PaymentModel({
    required this.status,
    required this.transactionId,
    required this.name,
    required this.email,
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
  },
  {
    'status': 'Pending',
    'transactionId': 'TXN654321',
    'name': 'Jane Smith',
    'email': 'jane@example.com',
    'amount': '₹ 850',
    'createdAt': '09 Apr 2025, 8:50 AM',
  },
  {
    'status': 'Failed',
    'transactionId': 'TXN123789',
    'name': 'Smith B.',
    'email': 'smith@example.com',
    'amount': '₹ 1300',
    'createdAt': '11 Apr 2025, 1:00 PM',
  },
];

