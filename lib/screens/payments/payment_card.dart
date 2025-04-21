import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import '../../constants/app_textstyles.dart';
import 'package:intl/intl.dart';
import '../../models/response models/transaction_response.dart'; // Assuming your models are in this path

class TransactionCard extends StatelessWidget {
  final TransactionData transaction;
  final bool isExpanded;
  final VoidCallback onExpandToggle;

  const TransactionCard({
    Key? key,
    required this.transaction,
    required this.isExpanded,
    required this.onExpandToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(transaction.status);
    final bgColorStatus = statusColor.withOpacity(0.2);
    final transactionTypeColor = _getTransactionTypeColor(transaction.walletHistory.transactionType);
    final bgColorTransactionType = transactionTypeColor.withOpacity(0.2);
    final formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(transaction.createdAt);

    return GestureDetector(
      onTap: onExpandToggle,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: isExpanded ? bgColorStatus.withOpacity(0.1) : Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAmountAndStatus(transaction.walletHistory.amount, formattedDate, transaction.status, transaction.walletHistory.transactionType, bgColorStatus, statusColor, bgColorTransactionType, transactionTypeColor),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: DottedLine(dashLength: 4.0, dashColor: Colors.grey, lineThickness: 1),
            ),
            _buildBaseInfoRow(transaction.user.firstName +" " +transaction.user.lastName),
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow("Email", transaction.user.email),
                    _buildInfoRow("Mobile", transaction.user.mobile),
                    _buildInfoRow("Ref ID", "${transaction.referenceNo}"),
                    // _buildInfoRow("Service Charge", transaction.serviceCharge.toStringAsFixed(2)),
                    // _buildInfoRow("Commission", transaction.customerCommission.toStringAsFixed(2)),
                    // _buildInfoRow("Wallet Type", transaction.walletHistory.walletType),
                    // _buildInfoRow("Transaction Type", transaction.walletHistory.transactionType),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Widget _buildAmountAndStatus(double amount, String createdAt, String status, String transactionType, Color bgColorStatus, Color textColorStatus,Color bgColorTransactionType, Color textColorTransactionType) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             "₹${amount.toStringAsFixed(2)}",
  //             overflow: TextOverflow.ellipsis,
  //             maxLines: 1,
  //             style: semiBoldTextStyle(fontSize: dimen16, color: textColorStatus),
  //           ),
  //           Text(
  //             createdAt,
  //             overflow: TextOverflow.ellipsis,
  //             maxLines: 1,
  //             style: thinTextStyle(fontSize: dimen13, color: Colors.black),
  //           ),
  //         ],
  //       ),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.only(right: 8.0),
  //             child: Container(
  //               padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
  //               decoration: BoxDecoration(
  //                 color: bgColorTransactionType,
  //                 borderRadius: BorderRadius.circular(4),
  //               ),
  //               child: Text(
  //                 transactionType,
  //                 overflow: TextOverflow.ellipsis,
  //                 maxLines: 1,
  //                 style: boldTextStyle(fontSize: dimen12, color: textColorTransactionType),
  //               ),
  //             ),
  //           ),
  //
  //           Container(
  //             padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
  //             decoration: BoxDecoration(
  //               color: bgColorStatus,
  //               borderRadius: BorderRadius.circular(4),
  //             ),
  //             child: FittedBox(
  //               fit: BoxFit.scaleDown,
  //               child: Text(
  //                 status,
  //                 overflow: TextOverflow.ellipsis,
  //                 maxLines: 1,
  //                 style: boldTextStyle(fontSize: dimen12, color: textColorStatus),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }
  Widget _buildAmountAndStatus(
      double amount,
      String createdAt,
      String status,
      String transactionType,
      Color bgColorStatus,
      Color textColorStatus,
      Color bgColorTransactionType,
      Color textColorTransactionType,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Amount & Date Column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "₹${amount.toStringAsFixed(2)}",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: semiBoldTextStyle(fontSize: dimen16, color: textColorStatus),
              ),
              Text(
                createdAt,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: thinTextStyle(fontSize: dimen13, color: Colors.black),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        // Status and Type Tags
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Transaction Type Badge
            Container(
              constraints: const BoxConstraints(maxWidth: 100),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: bgColorTransactionType,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                transactionType,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: boldTextStyle(fontSize: dimen12, color: textColorTransactionType),
              ),
            ),
            const SizedBox(width: 8),

            // Status Badge
            Container(
              constraints: const BoxConstraints(maxWidth: 120),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: bgColorStatus,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                status,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: boldTextStyle(fontSize: dimen12, color: textColorStatus),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBaseInfoRow(String refId) {
    return Row(
      children: [
        Expanded(
          child: Text(
            refId,
            style: regularTextStyle(fontSize: dimen15, color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 22),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(label, style: mediumTextStyle(fontSize: dimen13, color: Colors.black))),
          const Text(": "),
          Expanded(flex: 6, child: Text(value, style: mediumTextStyle(fontSize: dimen13, color: Colors.black))),
        ],
      ),
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
  Color _getTransactionTypeColor(String status) {
    switch (status.toLowerCase()) {
      case 'credit':
        return const Color(0xff1c5e20);
      case 'debit':
        return const Color(0xfffb0e00);
      default:
        return Colors.grey;
    }
  }
}
