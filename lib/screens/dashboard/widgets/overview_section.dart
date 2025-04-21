import 'package:flutter/material.dart';
import 'package:qt_distributer/screens/dashboard/widgets/summary_card.dart';
import '../../../constants/app_textstyles.dart';
import '../../../providers/dashboard_provider.dart';

class OverviewSection extends StatelessWidget {
  final DashboardProvider dashboardProvider;

  const OverviewSection(this.dashboardProvider, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
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
                    style:  boldTextStyle(
                      fontSize: dimen18,
                      color: Colors.black,
                      latterSpace: 1.0,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0,horizontal: 4.0),
              child: SizedBox(
                height: 110,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(child: SummaryCard(title: 'Users', count: dashboardProvider.userCount)),
                    SizedBox(width: 10,),
                    Expanded(child: SummaryCard(title: 'Customers', count: dashboardProvider.customerCount)),
                    SizedBox(width: 10,),
                    Expanded(child: SummaryCard(title: 'Products', count: dashboardProvider.productCount)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

