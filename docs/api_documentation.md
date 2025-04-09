# API Documentation

## Base URL
```
https://api.qtcollector.com/api
```

## Endpoints

### 1. Send OTP
Send OTP to the provided phone number.

**Endpoint:** `/qt/agents/sendOtp`  
**Method:** POST  
**Content-Type:** application/json

#### Request Parameters
```json
{
    "authid": "8878277553"  // 10-digit phone number
}
```

#### Response
```json
{
    "success": true,
    "status": 200,
    "message": "OTP SENT SUCCESSFULLY",
    "authid": "8878277553",
    "otp": null
}
```

#### Response Model (Dart)
```dart
class OtpResponse {
  final bool success;
  final int status;
  final String message;
  final String authid;
  final String? otp;

  OtpResponse({
    required this.success,
    required this.status,
    required this.message,
    required this.authid,
    this.otp,
  });
}
```

#### Usage Example
```dart
final apiService = ApiService();
try {
  final response = await apiService.sendOtp("8878277553");
  if (response.success) {
    // Handle success
  } else {
    // Handle failure
  }
} catch (e) {
  // Handle error
}
```

## Error Handling
The API service includes error handling for:
- Network errors
- Invalid responses
- Non-200 status codes

Errors are thrown as exceptions with descriptive messages.

## Notes
- All requests should include proper error handling
- The API uses JSON for request and response bodies
- Phone numbers should be 10 digits
- Responses include a success flag and status code for easy error handling 