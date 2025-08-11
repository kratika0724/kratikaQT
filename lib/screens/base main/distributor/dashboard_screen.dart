import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qt_distributer/widgets/common_text_widgets.dart';
import '../../../constants/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/dashboard_provider.dart';
import '../../distributer_pages/distributor dashboard/widgets/graph_section.dart';
import '../../distributer_pages/distributor dashboard/widgets/overview_section.dart';
import '../../distributer_pages/distributor dashboard/widgets/payments_section.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final token = authProvider.loginResponse?.accessToken ?? '';
      if (token.isNotEmpty) {
        final provider = Provider.of<DashboardProvider>(context, listen: false);
        provider.fetchUserCountData(context, token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardProvider =
        Provider.of<DashboardProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: AppColors.ghostWhite.withOpacity(0.7),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: HeaderTextBlack("Dashboard"),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        actions: [
          _buildNotificationIcon(),
          _buildProfileIcon(),
        ],
      ),
      body: SafeArea(
        child: dashboardProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : dashboardProvider.error != null
                ? Center(child: Text("Oops! Something went wrong"))
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 10.0),
                      child: Column(
                        children: [
                          PaymentsSection(),
                          const SizedBox(height: 10),
                          OverviewSection(dashboardProvider),
                          const SizedBox(height: 10),
                          GraphSection(),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            color: AppColors.primary.withOpacity(0.1),
            border: Border.all(color: AppColors.secondary),
          ),
          child: const Icon(
            Icons.notifications_none,
            color: AppColors.secondary,
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileIcon() {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            color: AppColors.primary.withOpacity(0.1),
            border: Border.all(color: AppColors.secondary),
          ),
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                colors: [Colors.amber, Colors.amberAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds);
            },
            child: Icon(Icons.person, size: 20, color: Colors.yellow.shade500),
          ),
        ),
      ),
    );
  }
}
