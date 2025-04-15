import 'package:flutter/material.dart';
import 'package:qt_distributer/screens/payments/payment_card.dart';
import '../../models/payment_model.dart';

class PaymentCardList extends StatelessWidget {
  PaymentCardList({super.key});

  final List<PaymentModel> paymentList =
  samplePayments.map((e) => PaymentModel.fromMap(e)).toList();

  @override
  Widget build(BuildContext context) {
    if (samplePayments.isEmpty) {
      return const Center(child: Text('No payments found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 12),
      itemCount: paymentList.length,
      itemBuilder: (context, index) {
        return PaymentCard(payment: paymentList[index]); // You can create this card widget
      },
    );
  }
}



