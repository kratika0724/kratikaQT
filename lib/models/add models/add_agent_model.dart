class AgentAddModel {
  final bool success;
  final String message;
  final List<CreateAgentModel> data;

  AgentAddModel({
    required this.success,
    required this.message,
    this.data = const [],
  });

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data.map((agent) => agent.toJson()).toList(),
  };

  factory AgentAddModel.fromJson(Map<String, dynamic> json) {
    return AgentAddModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? List<CreateAgentModel>.from(
        json['data'].map((item) => CreateAgentModel.fromJson(item)),
      )
          : [],
    );
  }
}

class CreateAgentModel {
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? email;
  final String? mobile;
  final String? city;
  final String? state;
  final String? country;
  final String? pin;
  final String? assignedPin;
  final String? assignedArea;
  final String? gender;
  final String? dob;

  CreateAgentModel({
    this.firstName = '',
    this.middleName = '',
    this.lastName = '',
    this.email = '',
    this.mobile = '',
    this.city = '',
    this.state = '',
    this.country = '',
    this.pin = '',
    this.assignedPin = '',
    this.assignedArea = '',
    this.gender = '',
    this.dob = '',
  });

  Map<String, dynamic> toJson() {
    return {
      "first_name": firstName,
      "middle_name": middleName,
      "last_name": lastName,
      "email": email,
      "mobile": mobile,
      "city": city,
      "state": state,
      "country": country,
      "pin": pin,
      "assigned_pin": assignedPin,
      "assigned_area": assignedArea,
      "gender": gender,
      "dob": dob,
    };
  }

  factory CreateAgentModel.fromJson(Map<String, dynamic> json) {
    return CreateAgentModel(
      firstName: json['first_name'],
      middleName: json['middle_name'],
      lastName: json['last_name'],
      email: json['email'],
      mobile: json['mobile'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      pin: json['pin'],
      assignedPin: json['assigned_pin'],
      assignedArea: json['assigned_area'],
      gender: json['gender'],
      dob: json['dob'],
    );
  }
}

