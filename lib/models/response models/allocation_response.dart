class AllocationResponseModel {
  final bool success;
  final int status;
  final String message;
  final List<AllocationModel> data;
  final MetaData meta;

  AllocationResponseModel({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory AllocationResponseModel.fromJson(Map<String, dynamic> json) {
    return AllocationResponseModel(
      success: json['success'],
      status: json['status'],
      message: json['message'],
      data: List<AllocationModel>.from(
        json['data'].map((x) => AllocationModel.fromJson(x)),
      ),
      meta: MetaData.fromJson(json['meta']),
    );
  }
}

class AllocationModel {
  final String? id;
  final String? allocationPincode;
  final String? allocationArea;
  final String? topAllocationUser;
  final String? topAllocationRole;
  final DateTime? createdAt;
  final String? createdBy;
  final DateTime? updatedAt;
  final String? updatedBy;

  AllocationModel({
    this.id,
    this.allocationPincode,
    this.allocationArea,
    this.topAllocationUser,
    this.topAllocationRole,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  factory AllocationModel.fromJson(Map<String, dynamic> json) {
    return AllocationModel(
      id: json['_id'],
      allocationPincode: json['allocation_pincode'],
      allocationArea: json['allocation_area'],
      topAllocationUser: json['top_allocation_user'],
      topAllocationRole: json['top_allocation_role'],
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      createdBy: json['created_by'],
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
      updatedBy: json['updated_by'],
    );
  }
}


class MetaData {
  final int currentPage;
  final int from;
  final int lastPage;
  final int perPage;
  final int to;
  final int total;

  MetaData({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.perPage,
    required this.to,
    required this.total,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      currentPage: json['current_page'],
      from: json['from'],
      lastPage: json['last_page'],
      perPage: json['per_page'],
      to: json['to'],
      total: json['total'],
    );
  }
}
