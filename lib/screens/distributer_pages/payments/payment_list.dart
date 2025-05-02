import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/response models/transaction_response.dart';
import '../../../providers/transaction_provider.dart';
import '../../../utils/device_utils.dart';
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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }


  void toggleExpanded(int index) {
    setState(() {
      if (expandedIndex == index) {
        expandedIndex = null;
      } else {
        expandedIndex = index;
      }
    });
  }

  void _onScroll() {
    final provider = Provider.of<TransactionProvider>(context, listen: false);
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !provider.isFetchingMore &&
        provider.hasMoreData) {
      provider.getTransactions(context, loadMore: true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
    final isOdd = transactions.length.isOdd;
    final totalItems = isOdd ? transactions.length + 1 : transactions.length;

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: totalItems,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 300,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        if (index >= transactions.length) {
          return const SizedBox(); // Empty widget to balance the grid
        }

        return TransactionCard(
          transaction: transactions[index],
          isExpanded: expandedIndex == index,
          onExpandToggle: () => toggleExpanded(index),
        );
      },
    );
  }

  Widget _buildListView(List<TransactionData> transactions) {
    return ListView.builder(
      controller: _scrollController,
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


