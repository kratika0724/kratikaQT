import 'package:flutter/material.dart';
import 'package:qt_distributer/widgets/common_text_widgets.dart';
import '../../constants/app_colors.dart';
import '../payments/payment_card_list.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: HeaderTextThemeSecondary("Payments"),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 3,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // List of payment cards
            Expanded(
              child: PaymentCardList(),
            ),
          ],
        ),
      ),
    );
  }
}

