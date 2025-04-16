class AgentResponseModel {
  final bool success;
  final int status;
  final String message;
  final List<AgentModel> data;
  final Meta meta;

  AgentResponseModel({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory AgentResponseModel.fromJson(Map<String, dynamic> json) {
    return AgentResponseModel(
      success: json['success'],
      status: json['status'],
      message: json['message'],
      data: List<AgentModel>.from(
        json['data'].map((item) => AgentModel.fromJson(item)),
      ),
      meta: Meta.fromJson(json['meta']),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'status': status,
    'message': message,
    'data': data.map((agent) => agent.toJson()).toList(),
    'meta': meta.toJson(),
  };
}

class AgentModel {
  final String id;
  final String companyName;
  final String firstName;
  final String middleName;
  final String lastName;
  final String gender;
  final DateTime dob;
  final String email;
  final String mobile;
  final String crmId;
  final String quintusId;
  final Address address;
  final String roleId;
  final String topUser;
  final DateTime createdAt;
  final String createdBy;
  final DateTime updatedAt;
  final String updatedBy;
  final List<dynamic> updatedRecord;
  final bool isEmail;
  final bool isMobile;
  final bool isApproved;
  final bool isBlocked;
  final bool kycStatus;
  final bool isWallet;
  final bool isActive;
  final List<dynamic> statusUpdatedRecord;

  AgentModel({
    required this.id,
    required this.companyName,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.gender,
    required this.dob,
    required this.email,
    required this.mobile,
    required this.crmId,
    required this.quintusId,
    required this.address,
    required this.roleId,
    required this.topUser,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    required this.updatedRecord,
    required this.isEmail,
    required this.isMobile,
    required this.isApproved,
    required this.isBlocked,
    required this.kycStatus,
    required this.isWallet,
    required this.isActive,
    required this.statusUpdatedRecord,
  });

  factory AgentModel.fromJson(Map<String, dynamic> json) {
    return AgentModel(
      id: json['_id'],
      companyName: json['company_name'],
      firstName: json['first_name'],
      middleName: json['middle_name'],
      lastName: json['last_name'],
      gender: json['gender'],
      dob: DateTime.parse(json['dob']),
      email: json['email'],
      mobile: json['mobile'],
      crmId: json['crm_id'],
      quintusId: json['quintus_id'],
      address: Address.fromJson(json['address']),
      roleId: json['roleId'],
      topUser: json['topUser'],
      createdAt: DateTime.parse(json['created_at']),
      createdBy: json['created_by'],
      updatedAt: DateTime.parse(json['updated_at']),
      updatedBy: json['updated_by'],
      updatedRecord: List<dynamic>.from(json['updated_record']),
      isEmail: json['is_email'],
      isMobile: json['is_mobile'],
      isApproved: json['is_approved'],
      isBlocked: json['is_blocked'],
      kycStatus: json['kyc_status'],
      isWallet: json['is_wallet'],
      isActive: json['is_active'],
      statusUpdatedRecord: List<dynamic>.from(json['status_updated_record']),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'company_name': companyName,
    'first_name': firstName,
    'middle_name': middleName,
    'last_name': lastName,
    'gender': gender,
    'dob': dob.toIso8601String(),
    'email': email,
    'mobile': mobile,
    'crm_id': crmId,
    'quintus_id': quintusId,
    'address': address.toJson(),
    'roleId': roleId,
    'topUser': topUser,
    'created_at': createdAt.toIso8601String(),
    'created_by': createdBy,
    'updated_at': updatedAt.toIso8601String(),
    'updated_by': updatedBy,
    'updated_record': updatedRecord,
    'is_email': isEmail,
    'is_mobile': isMobile,
    'is_approved': isApproved,
    'is_blocked': isBlocked,
    'kyc_status': kycStatus,
    'is_wallet': isWallet,
    'is_active': isActive,
    'status_updated_record': statusUpdatedRecord,
  };
}
class Address {
  final String address1;
  final String address2;
  final String city;
  final String pin;
  final String state;
  final String country;

  Address({
    required this.address1,
    required this.address2,
    required this.city,
    required this.pin,
    required this.state,
    required this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address1: json['address_1'],
      address2: json['address_2'],
      city: json['city'],
      pin: json['pin'],
      state: json['state'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() => {
    'address_1': address1,
    'address_2': address2,
    'city': city,
    'pin': pin,
    'state': state,
    'country': country,
  };
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

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json['current_page'],
    from: json['from'],
    lastPage: json['last_page'],
    perPage: json['per_page'],
    to: json['to'],
    total: json['total'],
  );

  Map<String, dynamic> toJson() => {
    'current_page': currentPage,
    'from': from,
    'last_page': lastPage,
    'per_page': perPage,
    'to': to,
    'total': total,
  };
}

