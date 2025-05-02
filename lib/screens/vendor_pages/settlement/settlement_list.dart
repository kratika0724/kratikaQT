import 'package:flutter/material.dart';
import '../../../models/sample models/settlement_model.dart';
import 'settlement_card.dart'; // Import your SettlementCard file

class SettlementListScreen extends StatefulWidget {
  const SettlementListScreen({Key? key}) : super(key: key);

  @override
  State<SettlementListScreen> createState() => _SettlementListScreenState();
}

class _SettlementListScreenState extends State<SettlementListScreen> {
  final List<SettlementModel> _settlements = [
    SettlementModel(
      amount: "1200.50",
      status: 'Success',
      transactiontype: 'Credit',
      name: 'John Doe',
      email: 'john@example.com',
      mobile: '9876543210',
      transactionId: 'QTX123456',
      createdAt: '22 Apr, 2025, 10:00 AM',
    ),
    SettlementModel(
      amount: "650.75",
      status: 'Pending',
      transactiontype: 'Debit',
      name: 'Alice Smith',
      email: 'alice@example.com',
      mobile: '9123456780',
      transactionId: 'QTX654321',
      createdAt: '22 Apr, 2025, 10:00 AM',
    ),
    SettlementModel(
      amount: "420.75",
      status: 'Failed',
      transactiontype: 'Credit',
      name: 'Anuj Singh',
      email: 'alice@example.com',
      mobile: '9123456780',
      transactionId: 'QTX654321',
      createdAt: '22 Apr, 2025, 10:00 AM',
    ),
    SettlementModel(
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _settlements.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final settlement = _settlements[index];
        return SettlementCard(
          payment: settlement,
          isExpanded: expandedIndex == index,
          onExpandToggle: () => toggleExpanded(index),
        );
      },
    );
  }
}
