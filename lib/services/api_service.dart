import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/otp_response.dart';
import '../models/verify_otp_response.dart';
import '../utils/logger.dart';

class ApiService {
  static const String baseUrl = 'https://api.qtcollector.com/api';

  Future<OtpResponse> sendOtp(String phoneNumber) async {
    try {
      AppLogger.info('Sending OTP to phone number: $phoneNumber');
      
      final url = '$baseUrl/qt/agents/sendOtp';
      final body = jsonEncode({
        'authid': phoneNumber,
      });

      AppLogger.debug('API Request:', {
        'url': url,
        'method': 'POST',
        'body': body,
      });

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      AppLogger.debug('API Response:', {
        'statusCode': response.statusCode,
        'body': response.body,
      });

      final Map<String, dynamic> data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        final otpResponse = OtpResponse.fromJson(data);
        AppLogger.info('OTP sent successfully to: $phoneNumber');
        return otpResponse;
      } else if (response.statusCode == 404) {
        AppLogger.warning('User not registered', {
          'statusCode': response.statusCode,
          'response': response.body,
        });
        throw Exception('User not registered. Please contact support.');
      } else {
        AppLogger.error('Failed to send OTP', {
          'statusCode': response.statusCode,
          'response': response.body,
        });
        throw Exception(data['message'] ?? 'Failed to send OTP: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error sending OTP', e, stackTrace);
      throw Exception('Error sending OTP: $e');
    }
  }

  Future<VerifyOtpResponse> verifyOtp(String phoneNumber, String otp) async {
    try {
      AppLogger.info('Verifying OTP for phone number: $phoneNumber');
      
      final url = '$baseUrl/qt/agents/verifyOtp';
      final body = jsonEncode({
        'authid': phoneNumber,
        'otp': otp,
      });

      AppLogger.debug('API Request:', {
        'url': url,
        'method': 'POST',
        'body': body,
      });

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      AppLogger.debug('API Response:', {
        'statusCode': response.statusCode,
        'body': response.body,
      });

      final Map<String, dynamic> data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        final verifyResponse = VerifyOtpResponse.fromJson(data);
        AppLogger.info('OTP verified successfully for: $phoneNumber');
        return verifyResponse;
      } else if (response.statusCode == 404) {
        AppLogger.warning('Invalid OTP', {
          'statusCode': response.statusCode,
          'response': response.body,
        });
        throw Exception('Invalid OTP. Please try again.');
      } else {
        AppLogger.error('Failed to verify OTP', {
          'statusCode': response.statusCode,
          'response': response.body,
        });
        throw Exception(data['message'] ?? 'Failed to verify OTP: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error verifying OTP', e, stackTrace);
      throw Exception('Error verifying OTP: $e');
    }
  }
}
