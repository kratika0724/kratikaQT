class CustomerResponseModel {
  final bool success;
  final String message;
  final int status;
  final List<CustomerModel> data;
  final Meta meta;

  CustomerResponseModel({
    required this.success,
    required this.message,
    required this.status,
    required this.data,
    required this.meta,
  });

  factory CustomerResponseModel.fromJson(Map<String, dynamic> json) {
    return CustomerResponseModel(
      success: json['success'],
      message: json['message'],
      status: json['status'],
      data: (json['data'] as List)
          .map((item) => CustomerModel.fromJson(item))
          .toList(),
      meta: Meta.fromJson(json['meta']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'status': status,
      'data': data.map((item) => item.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}

class CustomerModel {
  final String id;
  final String name;
  final String mobile;
  final String email;
  final String city;
  final String pincode;
  final String state;
  final String country;
  final bool isActive;
  final DateTime createdAt;
  final String createdBy;
  final DateTime updatedAt;
  final String updatedBy;

  CustomerModel({
    required this.id,
    required this.name,
    required this.mobile,
    required this.email,
    required this.city,
    required this.pincode,
    required this.state,
    required this.country,
    required this.isActive,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['_id'],
      name: json['name'],
      mobile: json['mobile'],
      email: json['email'],
      city: json['city'],
      pincode: json['pincode'],
      state: json['state'],
      country: json['country'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      createdBy: json['created_by'],
      updatedAt: DateTime.parse(json['updated_at']),
      updatedBy: json['updated_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'mobile': mobile,
      'email': email,
      'city': city,
      'pincode': pincode,
      'state': state,
      'country': country,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'created_by': createdBy,
      'updated_at': updatedAt.toIso8601String(),
      'updated_by': updatedBy,
    };
  }
}

class Meta {
  final int currentPage;
  final int from;
  final int lastPage;
  final int perPage;
  final int to;
  final int total;

  Meta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.perPage,
    required this.to,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      currentPage: json['current_page'],
      from: json['from'],
      lastPage: json['last_page'],
      perPage: json['per_page'],
      to: json['to'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'from': from,
      'last_page': lastPage,
      'per_page': perPage,
      'to': to,
      'total': total,
    };
  }
}
