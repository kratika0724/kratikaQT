class AgentAddModel {
  final String name;
  final String crmId;
  final String contact;
  final String email;
  final String status;
  final String gender;
  final String services;
  final String createdAt;

  AgentAddModel({
    required this.name,
    required this.crmId,
    required this.contact,
    required this.email,
    required this.status,
    required this.gender,
    required this.services,
    required this.createdAt,
  });

  factory AgentAddModel.fromMap(Map<String, String> map) {
    return AgentAddModel(
      name: map['name'] ?? '',
      crmId: map['crmId'] ?? '',
      contact: map['contact'] ?? '',
      email: map['email'] ?? '',
      status: map['status'] ?? '',
      gender: map['gender'] ?? '',
      services: map['services'] ?? '',
      createdAt: map['createdAt'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'name': name,
      'crmId': crmId,
      'email': email,
      'contact': contact,
      'status': status,
      'gender': gender,
      'services': services,
      'createdAt': createdAt,
    };
  }
}


final List<Map<String, String>> sampleAgents = [
  {
    'name': 'Agent A',
    'crmId': 'ABYID15096321',
    'email': 'agentA@example.com',
    'contact': '9876543210',
    'status': 'Active',
    'gender': 'Male',
    'services': 'Loan Recovery',
    'createdAt': '11 Apr 2025, 1:00 PM'
  },
  {
    'name': 'Agent B',
    'crmId': 'AARID15096321',
    'email': 'agentB@example.com',
    'contact': '9123456789',
    'status': 'Inactive',
    'gender': 'Female',
    'services': 'Payment Collection',
    'createdAt': '09 Apr 2025, 8:50 AM'
  },
  {
    'name': 'Agent C',
    'crmId': 'ABYID15096321',
    'email': 'agentA@example.com',
    'contact': '9876543210',
    'status': 'Active',
    'gender': 'Female',
    'services': 'Loan Recovery',
    'createdAt': '11 Apr 2025, 1:00 PM'
  },
  {
    'name': 'Agent D',
    'crmId': 'AARID15096321',
    'email': 'agentB@example.com',
    'contact': '9123456789',
    'status': 'Inactive',
    'gender': 'Female',
    'services': 'Payment Collection',
    'createdAt': '09 Apr 2025, 8:50 AM'
  },
  {
    'name': 'Agent A',
    'crmId': 'ABYID15096321',
    'email': 'agentA@example.com',
    'contact': '9876543210',
    'status': 'Active',
    'gender': 'Male',
    'services': 'Loan Recovery',
    'createdAt': '11 Apr 2025, 1:00 PM'
  },
  {
    'name': 'Agent B',
    'crmId': 'AARID15096321',
    'email': 'agentB@example.com',
    'contact': '9123456789',
    'status': 'Inactive',
    'gender': 'Male',
    'services': 'Payment Collection',
    'createdAt': '09 Apr 2025, 8:50 AM'
  },
  {
    'name': 'Agent A',
    'crmId': 'ABYID15096321',
    'email': 'agentA@example.com',
    'contact': '9876543210',
    'status': 'Active',
    'gender': 'Male',
    'services': 'Loan Recovery',
    'createdAt': '11 Apr 2025, 1:00 PM'
  },
  {
    'name': 'Agent B',
    'crmId': 'AARID15096321',
    'email': 'agentB@example.com',
    'contact': '9123456789',
    'status': 'Inactive',
    'gender': 'Female',
    'services': 'Payment Collection',
    'createdAt': '09 Apr 2025, 8:50 AM'
  },
];
