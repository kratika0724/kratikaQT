import 'package:flutter/material.dart';
import 'package:qt_distributer/screens/vendor%20payments/vendor_payment_card.dart';
import '../../models/sample models/payment_model.dart';

class VendorPaymentCardList extends StatefulWidget {
  const VendorPaymentCardList({Key? key}) : super(key: key);

  @override
  State<VendorPaymentCardList> createState() => _VendorPaymentCardListState();
}

class _VendorPaymentCardListState extends State<VendorPaymentCardList> {
  final List<PaymentModel> _payments = [
    PaymentModel(
      amount: "1200.50",
      status: 'Success',
      transactiontype: 'Credit',
      name: 'John Doe',
      email: 'john@example.com',
      mobile: '9876543210',
      transactionId: 'QTX123456',
      createdAt: '22 Apr, 2025, 10:00 AM',
    ),
    PaymentModel(
      amount: "650.75",
      status: 'Pending',
      transactiontype: 'Debit',
      name: 'Alice Smith',
      email: 'alice@example.com',
      mobile: '9123456780',
      transactionId: 'QTX654321',
      createdAt: '22 Apr, 2025, 10:00 AM',
    ),
    PaymentModel(
      amount: "420.75",
      status: 'Failed',
      transactiontype: 'Credit',
      name: 'Anuj Singh',
      email: 'alice@example.com',
      mobile: '9123456780',
      transactionId: 'QTX654321',
      createdAt: '22 Apr, 2025, 10:00 AM',
    ),
    PaymentModel(
      amount: "950.75",
      status: 'Success',
      transactiontype: 'Debit',
      name: 'Jitendra Soni',
      email: 'alice@example.com',
      mobile: '9123456780',
      transactionId: 'QTX654321',
      createdAt: '22 Apr, 2025, 10:00 AM',
    ),
    // Add more mock data if needed
  ];
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
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      itemCount: _payments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final payment = _payments[index];
        return VendorPaymentCard(
          payment: payment,
          isExpanded: expandedIndex == index,
          onExpandToggle: () => toggleExpanded(index),
        );
      },
    );
  }
}
