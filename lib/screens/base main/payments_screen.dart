import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qt_distributer/widgets/common_text_widgets.dart';
import '../../constants/app_colors.dart';
import '../../providers/transaction_provider.dart';
import '../../utils/device_utils.dart';
import '../payments/payment_card.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
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
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<TransactionProvider>(context, listen: false).getTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWide = DeviceUtils.getDeviceWidth(context);
    return Scaffold(
      backgroundColor: AppColors.ghostWhite.withOpacity(0.7),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: HeaderTextBlack("Payments"),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        // elevation: 3,
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, _) {
          final transactions = provider.transactions;
          return Column(
              children: [
                if(isWide)
                  Expanded(child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: transactions.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 200, // Adjust height as needed
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return TransactionCard(transaction: transaction,isExpanded: expandedIndex == index,
                        onExpandToggle: () {
                          toggleExpanded(index);
                        },);
                    },
                  )),
                if(!isWide)
                  Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 12),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return TransactionCard(
                        transaction: transaction,
                        isExpanded: expandedIndex == index,
                        onExpandToggle: () {
                          toggleExpanded(index);
                        },);
                    },
                  ),
                ),
                SizedBox(height: 10,),
              ]
          );
        },
      ),
    );
  }
}

