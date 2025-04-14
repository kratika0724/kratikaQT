import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/verify_otp_response.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _error;
  VerifyOtpResponse? _loginResponse;
  bool _isAuthenticated = false;
  static const String _authKey = 'auth_data';
  static const String _isAuthenticatedKey = 'is_authenticated';

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  VerifyOtpResponse? get loginResponse => _loginResponse;
  bool get isAuthenticated => _isAuthenticated;


  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;


  AuthProvider() {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool(_isAuthenticatedKey) ?? false;
    if (_isAuthenticated) {
      final authData = prefs.getString(_authKey);
      if (authData != null) {
        try {
          final Map<String, dynamic> json = Map<String, dynamic>.from(
              Map<String, dynamic>.from(jsonDecode(authData)));
          _loginResponse = VerifyOtpResponse.fromJson(json);
        } catch (e) {
          _isAuthenticated = false;
          await prefs.remove(_authKey);
          await prefs.remove(_isAuthenticatedKey);
        }
      }
    }
    _isInitialized = true;
    notifyListeners();
  }




  Future<void> _saveAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    if (_loginResponse != null) {
      await prefs.setString(_authKey, jsonEncode(_loginResponse!.toJson()));
      await prefs.setBool(_isAuthenticatedKey, _isAuthenticated);
    }
  }


  // Send OTP
  Future<bool> sendOtp(String phoneNumber) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.sendOtp(phoneNumber);
      _isLoading = false;
      notifyListeners();
      return response.success;
    } catch (e) {
      _isLoading = false;
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // Verify OTP
  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.verifyOtp(phoneNumber, otp);
      _isLoading = false;

      if (response.success) {
        _loginResponse = response;
        _isAuthenticated = true;
        await _saveAuthState();
        notifyListeners();
        return true;
      } else {
        _error = response.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authKey);
    await prefs.remove(_isAuthenticatedKey);

    _loginResponse = null;
    _isAuthenticated = false;
    _error = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
