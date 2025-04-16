import 'package:flutter/material.dart';
import 'package:qt_distributer/screens/payments/payment_card.dart';
import '../../models/payment_model.dart';

class PaymentCardList extends StatefulWidget {
  PaymentCardList({super.key});

  @override
  State<PaymentCardList> createState() => _PaymentCardListState();
}

class _PaymentCardListState extends State<PaymentCardList> {
  final List<PaymentModel> paymentList =
  samplePayments.map((e) => PaymentModel.fromMap(e)).toList();

  int? expandedIndex;

  void toggleExpanded(int index) {
    setState(() {
      if (expandedIndex == index) {
        expandedIndex = null;
      } else {
        expandedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (samplePayments.isEmpty) {
      return const Center(child: Text('No payments found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 12),
      itemCount: paymentList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: PaymentCard(
            payment: paymentList[index],
            isExpanded: expandedIndex == index,
            onExpandToggle: () => toggleExpanded(index),
          ),
        ); // You can create this card widget
      },
    );
  }
}



