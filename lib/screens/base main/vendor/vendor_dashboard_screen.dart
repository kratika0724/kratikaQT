import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qt_distributer/screens/base%20main/vendor/wallet_screen.dart';
import 'package:qt_distributer/widgets/common_text_widgets.dart';
import '../../../constants/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/dashboard_provider.dart';
import '../../vendor_pages/vendor dashboard/widgets/vendor_overview_section.dart';
import 'package:qt_distributer/widgets/cash_payment_bottom_sheet.dart';

class VendorDashboardScreen extends StatefulWidget {
  const VendorDashboardScreen({super.key});

  @override
  State<VendorDashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<VendorDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final token = authProvider.loginResponse?.accessToken ?? '';
      if (token.isNotEmpty) {
        final provider = Provider.of<DashboardProvider>(context, listen: false);
        provider.getCustomerDatafromLocal();
        provider.getDatabyId(context, token);
        // provider.fetchUserCountData(context, token);
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
        elevation: 2,
        shadowColor: AppColors.primary.withOpacity(0.1),
        // actions: [
        //   _buildWalletIcon(),
        // ],
      ),
      body: SafeArea(
        child: dashboardProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : dashboardProvider.error != null
                ? Center(child: Text("Oops! Something went wrong"))
                : Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 16.0),
                            child: Column(
                              children: [
                                // VendorPaymentsSection(),
                                // const SizedBox(height: 16),
                                VendorOverviewSection(dashboardProvider),
                                const SizedBox(height: 20),
                                // VendorGraphSection(),
                                // const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                      _buildCashPaymentButton(),
                    ],
                  ),
      ),
    );
  }

  Widget _buildCashPaymentButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          _showCashPaymentBottomSheet(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 2,
          shadowColor: AppColors.primary.withOpacity(0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.payment,
              size: 24,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Text(
              'Cash Payment',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCashPaymentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return CashPaymentBottomSheet();
      },
    );
  }

  Widget _buildWalletIcon() {
    final dashboardProvider =
        Provider.of<DashboardProvider>(context, listen: true);
    final walletBalance = dashboardProvider.walletBalance;

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => WalletScreen()));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.primary.withOpacity(0.1),
            border: Border.all(color: AppColors.secondary),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                const Icon(
                  Icons.wallet,
                  color: AppColors.secondary,
                  size: 20,
                ),
                const SizedBox(width: 6),
                Text(
                  "₹ ${walletBalance.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                    fontSize: 14,
                  ),
                )
              ],
            ),
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
