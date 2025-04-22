class CustomerAddModel {
  final bool success;
  final String message;
  final List<CreateCustomerModel> data;

  CustomerAddModel({
    required this.success,
    required this.message,
    this.data = const [],
  });

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data.map((customer) => customer.toJson()).toList(),
  };

  factory CustomerAddModel.fromJson(Map<String, dynamic> json) {
    return CustomerAddModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? List<CreateCustomerModel>.from(
        json['data'].map((item) => CreateCustomerModel.fromJson(item)),
      )
          : [],
    );
  }
}

class CreateCustomerModel {
  final String? name;
  final String? mobile;
  final String? email;
  final String? city;
  final String? pin;
  final String? state;
  final String? country;

  CreateCustomerModel({
    this.name = '',
    this.mobile = '',
    this.email = '',
    this.city = '',
    this.pin = '',
    this.state = '',
    this.country = '',
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "mobile": mobile,
      "email": email,
      "city": city,
      "pin": pin,
      "state": state,
      "country": country,
    };
  }

  factory CreateCustomerModel.fromJson(Map<String, dynamic> json) {
    return CreateCustomerModel(
      name: json['name'],
      mobile: json['mobile'],
      email: json['email'],
      city: json['city'],
      pin: json['pin'],
      state: json['state'],
      country: json['country'],
    );
  }
}
