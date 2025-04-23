class GetAgentListByAreaResponse {
  final bool success;
  final int status;
  final String message;
  final List<CustomerAgentByAreaData> data;

  GetAgentListByAreaResponse({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetAgentListByAreaResponse.fromJson(Map<String, dynamic> json) {
    return GetAgentListByAreaResponse(
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CustomerAgentByAreaData.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class CustomerAgentByAreaData {
  final String? id;
  final String? companyName;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? gender;
  final DateTime? dob;
  final String? email;
  final String? mobile;
  final String? crmId;
  final String? quintusId;
  final Address? address;
  final BankDetails? bankDetails;
  final DateTime? createdAt;
  final String? createdBy;
  final DateTime? updatedAt;
  final String? updatedBy;
  final dynamic collectedId;
  final bool isEmail;
  final bool isBankDetail;
  final bool isAddressDetail;
  final bool isMobile;
  final bool isApproved;
  final bool isBlocked;
  final bool kycStatus;
  final bool isWallet;
  final bool isActive;

  CustomerAgentByAreaData({
    this.id,
    this.companyName,
    this.firstName,
    this.middleName,
    this.lastName,
    this.gender,
    this.dob,
    this.email,
    this.mobile,
    this.crmId,
    this.quintusId,
    this.address,
    this.bankDetails,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.collectedId,
    required this.isEmail,
    required this.isBankDetail,
    required this.isAddressDetail,
    required this.isMobile,
    required this.isApproved,
    required this.isBlocked,
    required this.kycStatus,
    required this.isWallet,
    required this.isActive,
  });

  factory CustomerAgentByAreaData.fromJson(Map<String, dynamic> json) {
    return CustomerAgentByAreaData(
      id: json['_id'],
      companyName: json['company_name'],
      firstName: json['first_name'],
      middleName: json['middle_name'],
      lastName: json['last_name'],
      gender: json['gender'],
      dob: json['dob'] != null ? DateTime.tryParse(json['dob']) : null,
      email: json['email'],
      mobile: json['mobile'],
      crmId: json['crm_id'],
      quintusId: json['quintus_id'],
      address:
      json['address'] != null ? Address.fromJson(json['address']) : null,
      bankDetails: json['bank_details'] != null
          ? BankDetails.fromJson(json['bank_details'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      createdBy: json['created_by'],
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      updatedBy: json['updated_by'],
      collectedId: json['collectedId'],
      isEmail: json['is_email'] ?? false,
      isBankDetail: json['is_bankDetail'] ?? false,
      isAddressDetail: json['is_addressDetail'] ?? false,
      isMobile: json['is_mobile'] ?? false,
      isApproved: json['is_approved'] ?? false,
      isBlocked: json['is_blocked'] ?? false,
      kycStatus: json['kyc_status'] ?? false,
      isWallet: json['is_wallet'] ?? false,
      isActive: json['is_active'] ?? false,
    );
  }
}

class Address {
  final String? address1;
  final String? address2;
  final String? city;
  final String? pin;
  final String? state;
  final String? country;

  Address({
    this.address1,
    this.address2,
    this.city,
    this.pin,
    this.state,
    this.country,
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
}

class BankDetails {
  final String? address;
  final String? account;
  final String? ifsc;
  final String? name;
  final String? mobile;

  BankDetails({
    this.address,
    this.account,
    this.ifsc,
    this.name,
    this.mobile,
  });

  factory BankDetails.fromJson(Map<String, dynamic> json) {
    return BankDetails(
      address: json['address'],
      account: json['account'],
      ifsc: json['ifsc'],
      name: json['name'],
      mobile: json['mobile'],
    );
  }
}
