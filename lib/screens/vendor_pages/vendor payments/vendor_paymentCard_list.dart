import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/transaction_provider.dart';
import 'vendor_payment_card.dart';
import '../../../models/response models/transaction_response.dart';

class VendorPaymentCardList extends StatefulWidget {
  const VendorPaymentCardList({Key? key}) : super(key: key);

  @override
  State<VendorPaymentCardList> createState() => _VendorPaymentCardListState();
}

class _VendorPaymentCardListState extends State<VendorPaymentCardList> {
  int? expandedIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionProvider>().getTransactions(context);
    });
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

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        if (transactionProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (transactionProvider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  transactionProvider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    transactionProvider.getTransactions(context);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (transactionProvider.transactions.isEmpty) {
          return const Center(
            child: Text(
              'No transactions found',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => transactionProvider.refreshTransactionData(context),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            itemCount: transactionProvider.filteredTransactions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 4),
            itemBuilder: (context, index) {
              final transaction = transactionProvider.filteredTransactions[index];
              return VendorPaymentCard(
                transaction: transaction,
                isExpanded: expandedIndex == index,
                onExpandToggle: () => toggleExpanded(index),
              );
            },
          ),
        );
      },
    );
  }
}
