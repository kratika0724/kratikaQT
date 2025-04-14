class AllocationModel {
  final String allocationPincode;
  final String allocationArea;
  final String actions;
  final String createdAt;

  AllocationModel({
    required this.allocationPincode,
    required this.allocationArea,
    required this.actions,
    required this.createdAt,
  });

  factory AllocationModel.fromMap(Map<String, String> map) {
    return AllocationModel(
      allocationPincode: map['allocationPincode'] ?? '',
      allocationArea: map['allocationArea'] ?? '',
      actions: map['actions'] ?? '',
      createdAt: map['createdAt'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'allocationPincode': allocationPincode,
      'allocationArea': allocationArea,
      'actions': actions,
      'createdAt': createdAt,
    };
  }
}


final List<Map<String, String>> sampleAllocations = [
  {
    'allocationPincode': '452010',
    'allocationArea': 'Indore',
    'actions': 'actions',
    'createdAt': '11 Apr 2025, 1:00 PM'
  },
  {
    'allocationPincode': '651281',
    'allocationArea': 'Ahmedabad',
    'actions': 'actions',
    'createdAt': '09 Apr 2025, 10:00 AM'
  },
];
