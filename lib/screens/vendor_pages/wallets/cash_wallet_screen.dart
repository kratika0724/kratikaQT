import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_textstyles.dart';
import '../../../widgets/common_text_widgets.dart';

class CashWalletScreen extends StatefulWidget {
  const CashWalletScreen({super.key});

  @override
  State<CashWalletScreen> createState() => CashWalletScreenState();
}

class CashWalletScreenState extends State<CashWalletScreen> {
  // Static sample data
  final double totalBalance = 12500.00;
  final double totalCredit = 15000.00;
  final double totalDebit = 2500.00;

  final List<Map<String, dynamic>> transactions = [
    {
      'amount': 5000.00,
      'type': 'Credit',
      'status': 'Success',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'description': 'Commission from Service #1234',
    },
    {
      'amount': 2000.00,
      'type': 'Debit',
      'status': 'Success',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'description': 'Withdrawal to Bank Account',
    },
    {
      'amount': 8000.00,
      'type': 'Credit',
      'status': 'Success',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'description': 'Commission from Service #5678',
    },
    {
      'amount': 500.00,
      'type': 'Debit',
      'status': 'Success',
      'date': DateTime.now().subtract(const Duration(days: 4)),
      'description': 'Service Fee',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ghostWhite,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: HeaderTextBlack("Cash Wallet"),
      ),
      body: Column(
        children: [
          // Wallet Balance Card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Available Balance",
                  style: regularTextStyle(
                    fontSize: dimen16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "₹ ${totalBalance.toStringAsFixed(2)}",
                  style: boldTextStyle(
                    fontSize: dimen24,
                    color: Colors.black,
                  ),
                ),
                // const SizedBox(height: 16),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     _buildBalanceInfo("Total Credit", totalCredit),
                //     _buildBalanceInfo("Total Debit", totalDebit),
                //   ],
                // ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Transaction History",
                  style:
                  boldTextStyle(fontSize: dimen18, color: Colors.black87),
                ),
              ],
            ),
          ),

          // Transaction List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                final isCredit = transaction['type'] == 'Credit';
                final statusColor = _getStatusColor(transaction['status']);
                final formattedDate = DateFormat('dd MMM yyyy, hh:mm a')
                    .format(transaction['date']);

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isCredit
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                        color: isCredit ? Colors.green : Colors.red,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      transaction['description'],
                      style: mediumTextStyle(
                          fontSize: dimen16, color: Colors.black87),
                    ),
                    subtitle: Text(
                      formattedDate,
                      style: regularTextStyle(
                          fontSize: dimen14, color: Colors.grey[600]),
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "₹ ${transaction['amount'].toStringAsFixed(2)}",
                          style: boldTextStyle(
                            fontSize: dimen16,
                            color: isCredit ? Colors.green : Colors.red,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            transaction['status'],
                            style: mediumTextStyle(
                              fontSize: dimen12,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceInfo(String label, double amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: regularTextStyle(
            fontSize: dimen14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "₹ ${amount.toStringAsFixed(2)}",
          style: mediumTextStyle(
            fontSize: dimen16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
        return const Color(0xff1c5e20);
      case 'pending':
        return const Color(0xfffdbb00);
      case 'failed':
        return const Color(0xfffb0e00);
      default:
        return Colors.grey;
    }
  }
}
