import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/response models/transaction_response.dart';
import '../../providers/transaction_provider.dart';
import '../../utils/device_utils.dart';
import 'payment_card.dart';

class PaymentCardList extends StatefulWidget {
  final List<TransactionData> transactions;
  final String? filterTransactionId;
  final String? filterStatus;
  final String? filterTransactionType;
  final String? filterEmail;
  final DateTime? filterStartDate;
  final DateTime? filterEndDate;

  const PaymentCardList({
    super.key,
    required this.transactions,
    this.filterTransactionId,
    this.filterStatus,
    this.filterTransactionType,
    this.filterEmail,
    this.filterStartDate,
    this.filterEndDate,

  });

  @override
  State<PaymentCardList> createState() => _PaymentCardListState();
}

class _PaymentCardListState extends State<PaymentCardList> {
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
    final isWide = DeviceUtils.getDeviceWidth(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final filteredTransactions = transactionProvider.filteredTransactions;

    if (filteredTransactions.isEmpty) {
      return const Center(child: Text("No payments found."));
    }

    return isWide
        ? _buildGridView(filteredTransactions)
        : _buildListView(filteredTransactions);
  }

  Widget _buildGridView(List<TransactionData> transactions) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: transactions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 300,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) => TransactionCard(
        transaction: transactions[index],
        isExpanded: expandedIndex == index,
        onExpandToggle: () => toggleExpanded(index),
      ),
    );
  }

  Widget _buildListView(List<TransactionData> transactions) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: TransactionCard(
          transaction: transactions[index],
          isExpanded: expandedIndex == index,
          onExpandToggle: () => toggleExpanded(index),
        ),
      ),
    );
  }
}
