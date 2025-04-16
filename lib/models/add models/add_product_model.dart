class ProductAddModel{
  final bool success;
  final String message;
  final List<CreateProductModel> data;

  ProductAddModel({
    required this.success,
    required this.message,
    this.data = const [],
  });
  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data.map((address) => address.toJson()).toList(),
  };
  factory ProductAddModel.fromJson(Map<String, dynamic> json) {
    return ProductAddModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? List<CreateProductModel>.from(
        json['data'].map((item) => CreateProductModel.fromJson(item)),
      )
          : [],
    );
  }
}

class CreateProductModel {
  final String? productName;
  final String? productCode;
  final int? productAmount;
  final String? quaterDiscount;
  final String? halfyearDiscount;
  final String? yearlyDiscount;

  CreateProductModel({
    this.productName = '',
    this.productCode = '',
    this.productAmount = 0,
    this.quaterDiscount = '',
    this.halfyearDiscount = '',
    this.yearlyDiscount = '',
  });

  Map<String, dynamic> toJson() {
    return {
      "product_name": productName,
      "product_code": productCode,
      "product_amount": productAmount,
      "quater_discount": quaterDiscount,
      "halfyear_discount": halfyearDiscount,
      "yearly_discount": yearlyDiscount,
    };
  }

  factory CreateProductModel.fromJson(Map<String, dynamic> json) {
    return CreateProductModel(
      productName: json['product_name'],
      productCode: json['product_code'],
      productAmount: json['product_amount'],
      quaterDiscount: json['quater_discount'], // ← match spelling!
      halfyearDiscount: json['halfyear_discount'],
      yearlyDiscount: json['yearly_discount'],
    );
  }
}


