import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:qt_distributer/services/user_preferences.dart';
import 'package:qt_distributer/utils/utils.dart';
import '../constants/commonString.dart';
import '../models/response models/otp_response.dart';
import '../models/response models/verify_otp_response.dart';
import '../providers/auth_provider.dart';
import '../screens/login/login_screen.dart';
import '../utils/logger.dart';
import 'api_path.dart';

class ApiService {
  Future<OtpResponse> sendOtp(String phoneNumber) async {
    try {
      AppLogger.info('Sending OTP to phone number: $phoneNumber');
      final url = ApiPath.baseUrl + ApiPath.sendOtp;
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
        throw Exception(
            data['message'] ?? 'Failed to send OTP: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error sending OTP', e, stackTrace);
      throw Exception('Error sending OTP: $e');
    }
  }

  Future<VerifyOtpResponse> verifyOtp(String phoneNumber, String otp) async {
    try {
      AppLogger.info('Verifying OTP for phone number: $phoneNumber');

      final url = ApiPath.baseUrl + ApiPath.verifyOtp;
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
        isLogin = true;
        PreferencesServices.setPreferencesData(
          PreferencesServices.isLogin,
          true,
        );
        PreferencesServices.setPreferencesData(
          PreferencesServices.apiToken,
          verifyResponse.accessToken ?? '',
        );
        setUserData(verifyResponse.user);
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
        throw Exception(
            data['message'] ?? 'Failed to verify OTP: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error verifying OTP', e, stackTrace);
      throw Exception('Error verifying OTP: $e');
    }
  }

  Future<Map<String, dynamic>> updateDeviceToken(
      BuildContext context, String token) async {
    try {
      final response = await post_auth(context, ApiPath.updateDeviceToken, {
        'token': token,
      });

      return response;
    } catch (e) {
      throw Exception('Error updating device token: $e');
    }
  }

  Future<Map<String, dynamic>> getAuth(BuildContext context, String endpoint,
      Map<String, String> queryParams) async {
    final url = Uri.parse("${ApiPath.baseUrl}$endpoint")
        .replace(queryParameters: queryParams);

    // Fetch the token from Preferences
    String token = await PreferencesServices.getPreferencesData(
        PreferencesServices.apiToken);

    // Log the URL and query parameters
    print("Auth Token: $token");
    print('Request URL: ${url.toString()}');
    print('Query Parameters: $queryParams');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Add Authorization header
        },
      );

      // Log the response
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // Handle 450 status code (Session expired)
      if (response.statusCode == 450) {
        await Provider.of<AuthProvider>(context, listen: false).logout();
        await PreferencesServices.clearData();
        Fluttertoast.showToast(
            msg: "Your Session is expired please log in again to continue!");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }

      try {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } catch (e) {
        throw Exception('Something Error');
      }
    } catch (e) {
      // Log the error
      throw Exception('Something Error');
      // throw Exception('Network error: $e');
    }
  }

// POST Request
  Future<Map<String, dynamic>> post_auth(
      BuildContext context, String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse("${ApiPath.baseUrl}$endpoint");
    print('Request URL: ${url.toString()}');
    print('Request Body: $body');
    String token = await PreferencesServices.getPreferencesData(
        PreferencesServices.apiToken);
    try {
      var request = http.Request('POST', url);
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode(body);
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: $responseBody');
      if (response.statusCode == 450) {
        Fluttertoast.showToast(
            msg: "Your Session is expired please log in again to continue!");
        await Provider.of<AuthProvider>(context, listen: false).logout();
        await PreferencesServices.clearData();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
      try {
        return jsonDecode(responseBody);
      } catch (e) {
        throw Exception('Something Error');
      }
    } catch (e) {
      throw Exception('Something Error');
      throw Exception('Network error: $e');
    }
  }
}
