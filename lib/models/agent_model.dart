class AgentModel {
  final String name;
  final String companyName;
  final String contact;
  final String email;
  final String status;
  final String createdAt;

  AgentModel({
    required this.name,
    required this.companyName,
    required this.contact,
    required this.email,
    required this.status,
    required this.createdAt,
  });

  factory AgentModel.fromMap(Map<String, String> map) {
    return AgentModel(
      name: map['name'] ?? '',
      companyName: map['companyName'] ?? '',
      contact: map['contact'] ?? '',
      email: map['email'] ?? '',
      status: map['status'] ?? '',
      createdAt: map['createdAt'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'name': name,
      'companyName': companyName,
      'email': email,
      'contact': contact,
      'status': status,
      'createdAt': createdAt,
    };
  }
}


final List<Map<String, String>> sampleAgents = [
  {
    'name': 'Agent A',
    'companyName': 'Company 1',
    'email': 'agentA@example.com',
    'contact': '9876543210',
    'status': 'Active',
    'createdAt': '11 Apr 2025, 1:00 PM'
  },
  {
    'name': 'Agent B',
    'companyName': 'Company 2',
    'email': 'agentB@example.com',
    'contact': '9123456789',
    'status': 'Inactive',
    'createdAt': '09 Apr 2025, 8:50 AM'
  },
];
