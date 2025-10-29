import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/login/login_screen.dart';
import '../services/user_preferences.dart';
import '../providers/auth_provider.dart';
import 'app_theme_button.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logging Out!"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'NO',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () async {
                await Provider.of<AuthProvider>(context, listen: false)
                    .logout();
                await PreferencesServices.clearData();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text(
                'YES',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 30),
      child: AppThemeButton(
        label: 'Log Out',
        onPressed: () => _showLogoutDialog(context),
      ),
    );
  }
}
