class CustomerModel {
  final String name;
  final String contact;
  final String service;

  CustomerModel({
    required this.name,
    required this.contact,
    required this.service,
  });

  factory CustomerModel.fromMap(Map<String, String> map) {
    return CustomerModel(
      name: map['name'] ?? '',
      contact: map['contact'] ?? '',
      service: map['service'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'name': name,
      'contact': contact,
      'service': service,
    };
  }
}


final List<Map<String, String>> sampleCustomers = [
  {
    'name': 'John Doe',
    'contact': '9876543210',
    'service': 'Loan Recovery',
  },
  {
    'name': 'Jane Smith',
    'contact': '9123456789',
    'service': 'Payment Collection',
  },
];
