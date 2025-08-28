import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qt_distributer/screens/vendor_pages/cash_submission_history_screen.dart';
import 'package:qt_distributer/services/api_service.dart';

class MessagingService {
  static String? fcmToken; // Variable to store the FCM token

  static final MessagingService _instance = MessagingService._internal();

  factory MessagingService() => _instance;

  MessagingService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  void askNotificationPermission() {
    Permission.notification.request();
  }

  Future<void> saveToken(String token, BuildContext? context) async {
    askNotificationPermission();
    try {
      final apiService = ApiService();
      await apiService.updateDeviceToken(context!, token);
      print("Device token updated successfully");
    } catch (e) {
      print("Error updating device token: $e");
    }
  }

  void initializeNotificationService(BuildContext context) {
    final MessagingService _notificationService = MessagingService();
    _notificationService.init(context);
  }

  Future<void> init(BuildContext context) async {
    fcmToken = await _fcm.getToken();
    saveToken(fcmToken!, context); // Context will be passed later when needed
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null) {
        if (message.notification!.title != null &&
            message.notification!.body != null) {}
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationClick(message, context);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationClick(message, context);
    });
  }

  void _handleNotificationClick(RemoteMessage message, BuildContext context) {
    String click_action = message.data["click_action"];
    if (click_action == "OPEN_CASH_REJECTED_REQUEST") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CashSubmissionHistoryScreen(),
        ),
      );
    }
    if (click_action == "OPEN_CASH_APPROVED_REQUEST") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CashSubmissionHistoryScreen(),
        ),
      );
    }
  }

  // Method to update device token with context (call this after user login)
  Future<void> updateTokenWithContext(BuildContext context) async {
    if (fcmToken != null) {
      await saveToken(fcmToken!, context);
    }
  }
}

// Handler for background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}
