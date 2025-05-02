import 'package:flutter/material.dart';
import 'package:qt_distributer/screens/vendor_pages/vendor%20dashboard/widgets/vendor_summary_card.dart';
import '../../../../constants/app_textstyles.dart';
import '../../../../providers/dashboard_provider.dart';

class VendorOverviewSection extends StatelessWidget {
  final DashboardProvider dashboardProvider;

  const VendorOverviewSection(this.dashboardProvider, {super.key});

  @override
  Widget build(BuildContext context) {
    final summaryItems = [
      VendorSummaryCard(title: 'Users', count: dashboardProvider.userCount),
      VendorSummaryCard(title: 'Customers', count: dashboardProvider.customerCount),
      VendorSummaryCard(title: 'Distributors', count: dashboardProvider.customerCount),
      VendorSummaryCard(title: 'Products', count: dashboardProvider.productCount),
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Overview",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: boldTextStyle(
                      fontSize: dimen18,
                      color: Colors.black,
                      latterSpace: 1.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.8,
              physics: const NeverScrollableScrollPhysics(),
              children: summaryItems,
            ),
          ],
        ),
      ),
    );
  }
}

