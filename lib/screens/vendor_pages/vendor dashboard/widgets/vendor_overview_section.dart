import 'package:flutter/material.dart';
import 'package:qt_distributer/screens/vendor_pages/vendor%20dashboard/widgets/vendor_summary_card.dart';
import '../../../../constants/app_textstyles.dart';
import '../../../../constants/app_colors.dart';
import '../../../../providers/dashboard_provider.dart';

class VendorOverviewSection extends StatelessWidget {
  final DashboardProvider dashboardProvider;

  const VendorOverviewSection(this.dashboardProvider, {super.key});

  @override
  Widget build(BuildContext context) {
    final walletItems = [
      VendorSummaryCard(
        title: 'Wallet Balance',
        count: dashboardProvider.walletBalance.toInt(),
        isCurrency: true,
      ),
      VendorSummaryCard(
        title: 'Hold Amount',
        count: dashboardProvider.holdAmount.toInt(),
        isCurrency: true,
      ),
      VendorSummaryCard(
        title: 'Payout Balance',
        count: dashboardProvider.payoutBalance.toInt(),
        isCurrency: true,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Wallet Information",
                    style: boldTextStyle(
                      fontSize: dimen18,
                      color: Colors.black87,
                      latterSpace: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
              physics: const NeverScrollableScrollPhysics(),
              children: walletItems,
            ),
          ],
        ),
      ),
    );
  }
}
