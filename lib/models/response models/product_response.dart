class ProductResponseModel {
  final bool success;
  final String message;
  final int status;
  final List<ProductModel> data;
  final Meta meta;

  ProductResponseModel({
    required this.success,
    required this.message,
    required this.status,
    required this.data,
    required this.meta,
  });

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      status: json['status'] ?? 0,
      data: (json['data'] != null && json['data'] is List)
          ? (json['data'] as List)
          .map((item) => ProductModel.fromJson(item))
          .toList()
          : [],
      meta: json['meta'] != null
          ? Meta.fromJson(json['meta'])
          : Meta(currentPage: 1, from: 0, lastPage: 1, perPage: 10, to: 0, total: 0),
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

class ProductModel {
  final String id;
  final String topUser;
  final String productName;
  final String productCode;
  final int productAmount;
  final int quaterDiscount;
  final int halfyearDiscount;
  final int yearlyDiscount;
  final bool isActive;
  final DateTime createdAt;
  final String createdBy;
  final DateTime updatedAt;
  final String updatedBy;

  ProductModel({
    required this.id,
    required this.topUser,
    required this.productName,
    required this.productCode,
    required this.productAmount,
    required this.quaterDiscount,
    required this.halfyearDiscount,
    required this.yearlyDiscount,
    required this.isActive,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? '',
      topUser: json['topUser'] ?? '',
      productName: json['product_name'] ?? '',
      productCode: json['product_code'] ?? '',
      productAmount: (json['product_amount'] ?? 0).toInt(),
      quaterDiscount: (json['quater_discount'] ?? 0).toInt(),
      halfyearDiscount: (json['halfyear_discount'] ?? 0).toInt(),
      yearlyDiscount: (json['yearly_discount'] ?? 0).toInt(),
      isActive: json['is_active'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      createdBy: json['created_by'] ?? '',
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      updatedBy: json['updated_by'] ?? '',
    );
  }


  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'topUser': topUser,
      'product_name': productName,
      'product_code': productCode,
      'product_amount': productAmount,
      'quater_discount': quaterDiscount,
      'halfyear_discount': halfyearDiscount,
      'yearly_discount': yearlyDiscount,
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
      currentPage: json['current_page'] ?? 1,
      from: json['from'] ?? 0,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 10,
      to: json['to'] ?? 0,
      total: json['total'] ?? 0,
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
