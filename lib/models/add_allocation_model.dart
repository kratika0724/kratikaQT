class AddAllocationModel {
  final bool success;
  final String message;
  final List<CreateAllocationModel> data;

  AddAllocationModel({
    required this.success,
    required this.message,
    this.data = const [],
  });

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data.map((item) => item.toJson()).toList(),
  };

  factory AddAllocationModel.fromJson(Map<String, dynamic> json) {
    return AddAllocationModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? List<CreateAllocationModel>.from(
        json['data'].map((item) => CreateAllocationModel.fromJson(item)),
      )
          : [],
    );
  }
}

class CreateAllocationModel {
  final String? allocationPincode;
  final String? allocationArea;

  CreateAllocationModel({
    this.allocationPincode = '',
    this.allocationArea = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'allocation_pincode': allocationPincode,
      'allocation_area': allocationArea,
    };
  }

  factory CreateAllocationModel.fromJson(Map<String, dynamic> json) {
    return CreateAllocationModel(
      allocationPincode: json['allocation_pincode'],
      allocationArea: json['allocation_area'],
    );
  }
}
