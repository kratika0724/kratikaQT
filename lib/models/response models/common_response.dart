class CommonResponse {
  bool? success;
  String? message;
  String? errors;
  String? error;
  String? status;
  int? statusCode;
  dynamic data;

  CommonResponse({
    this.success,
    this.message,
    this.errors,
    this.error,
    this.status,
    this.statusCode,
    this.data,
  });

  // factory CommonResponse.fromJson(Map<String, dynamic> json) =>
  //     CommonResponse(
  //       success: json['success'] ?? false, // Default to `false` if `status` is null
  //       message: json['message'] ?? 'No message available',
  //       errors: json['errors'] ?? '',
  //       error: json['error'] ?? '',
  //       status: json['status'] ?? 'false',
  //       statusCode: json['status_code'] ?? 404, // Default status code for "not found"
  //       data: json['data'], // Keep as is or provide a default if required
  //     );

  factory CommonResponse.fromJson(Map<String, dynamic> json) => CommonResponse(
    success: json['success'] ?? false,
    message: json['message']?.toString() ?? 'No message available',
    errors: json['errors']?.toString(),  // Safely convert to String
    error: json['error']?.toString(),    // Safely convert to String
    status: json['status']?.toString() ?? 'false',
    statusCode: json['status_code'] is int ? json['status_code'] : int.tryParse(json['status_code']?.toString() ?? '404'),
    data: json['data'],
  );


  Map<String, dynamic> toJson() =>
      {
        'status': success,
        'message': message,
        'errors': errors,
        'error': error,
        'status':status,
        'status_code': statusCode,
        'data': data,
      };

  @override
  String toString() {
    return 'CommonResponse{status: $success, message: $message, errors: $errors, status_code: $statusCode, status: $status,data: $data}';
  }
}
