import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/pending_bills_provider.dart';
import 'pending_bill_card.dart';

class PendingBillsList extends StatefulWidget {
  const PendingBillsList({Key? key}) : super(key: key);

  @override
  State<PendingBillsList> createState() => _PendingBillsListState();
}

class _PendingBillsListState extends State<PendingBillsList> {
  int? expandedIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PendingBillsProvider>().getPendingBills(context);
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
    return Consumer<PendingBillsProvider>(
      builder: (context, pendingBillsProvider, child) {
        if (pendingBillsProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (pendingBillsProvider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  pendingBillsProvider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    pendingBillsProvider.getPendingBills(context);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (pendingBillsProvider.pendingBills.isEmpty) {
          return const Center(
            child: Text(
              'No pending bills found',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () =>
              pendingBillsProvider.refreshPendingBillsData(context),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            itemCount: pendingBillsProvider.pendingBills.length,
            separatorBuilder: (_, __) => const SizedBox(height: 4),
            itemBuilder: (context, index) {
              final pendingBill = pendingBillsProvider.pendingBills[index];
              return PendingBillCard(
                pendingBill: pendingBill,
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
