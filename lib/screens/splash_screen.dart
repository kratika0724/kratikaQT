import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login/login_screen.dart';
import 'base main/home_screen.dart';
import '../constants/app_colors.dart';
import '../constants/app_assets.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _controller.forward();
    _checkAuthState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _checkAuthState() async {
    await Future.delayed(const Duration(seconds: 0));
    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isInitialized) {
      await Future.delayed(const Duration(milliseconds: 500));
      return _checkAuthState();
    }

    if (authProvider.isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Container(
        child: Center(
          child: Image.asset(
            AppAssets.logo,
            color: Colors.white,
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}
