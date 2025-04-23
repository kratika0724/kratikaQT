class CustomerResponse {
  final bool success;
  final String message;
  final int status;
  final List<CustomerData> data;
  final CustomerMeta meta;

  CustomerResponse({
    required this.success,
    required this.message,
    required this.status,
    required this.data,
    required this.meta,
  });

  factory CustomerResponse.fromJson(Map<String, dynamic> json) {
    return CustomerResponse(
      success: json['success'],
      message: json['message'],
      status: json['status'],
      data: List<CustomerData>.from(
        json['data'].map((x) => CustomerData.fromJson(x)),
      ),
      meta: CustomerMeta.fromJson(json['meta']),
    );
  }
}

class CustomerData {
  final String id;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String mobile;
  final String email;
  final String address;
  final String createdAt;
  final String createdBy;
  final String updatedAt;
  final String updatedBy;
  final String agentName;
  final String topVendorName;

  CustomerData({
    required this.id,
    this.firstName,
    this.middleName,
    this.lastName,
    required this.mobile,
    required this.email,
    required this.address,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    required this.agentName,
    required this.topVendorName,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      id: json['_id'],
      firstName: json['first_name'],
      middleName: json['middle_name'],
      lastName: json['last_name'],
      mobile: json['mobile'],
      email: json['email'],
      address: json['address'] ?? "",
      createdAt: json['created_at'],
      createdBy: json['created_by'],
      updatedAt: json['updated_at'],
      updatedBy: json['updated_by'],
      agentName: json['agentName'],
      topVendorName: json['topVendorName'],
    );
  }
}

class CustomerMeta {
  final int currentPage;
  final int from;
  final int lastPage;
  final int perPage;
  final int to;
  final int total;

  CustomerMeta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.perPage,
    required this.to,
    required this.total,
  });

  factory CustomerMeta.fromJson(Map<String, dynamic> json) {
    return CustomerMeta(
      currentPage: json['current_page'],
      from: json['from'],
      lastPage: json['last_page'],
      perPage: json['per_page'],
      to: json['to'],
      total: json['total'],
    );
  }
}
