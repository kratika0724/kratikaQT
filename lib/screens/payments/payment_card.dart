import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:qt_distributer/models/payment_model.dart';
import '../../constants/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dotted_line/dotted_line.dart';
import '../../constants/app_textstyles.dart';
import '../../models/transaction_response_model.dart'; // Assuming your models are in this path

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
    final bgColor = statusColor.withOpacity(0.2);
    final formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(transaction.createdAt);

    return GestureDetector(
      onTap: onExpandToggle,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: isExpanded ? bgColor.withOpacity(0.1) : Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAmountAndStatus(transaction.transactionAmount, formattedDate, transaction.status, bgColor, statusColor),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: DottedLine(dashLength: 4.0, dashColor: Colors.grey, lineThickness: 1),
            ),
            _buildReferenceRow(transaction.referenceNo),
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow("User", "${transaction.user.firstName} ${transaction.user.lastName}"),
                    _buildInfoRow("Email", transaction.user.email),
                    _buildInfoRow("Mobile", transaction.user.mobile),
                    _buildInfoRow("Service Charge", transaction.serviceCharge.toStringAsFixed(2)),
                    _buildInfoRow("Commission", transaction.customerCommission.toStringAsFixed(2)),
                    _buildInfoRow("Wallet Type", transaction.walletHistory.walletType),
                    _buildInfoRow("Transaction Type", transaction.walletHistory.transactionType),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountAndStatus(double amount, String createdAt, String status, Color bgColor, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "₹${amount.toStringAsFixed(2)}",
              style: semiBoldTextStyle(fontSize: dimen16, color: textColor),
            ),
            Text(
              createdAt,
              style: thinTextStyle(fontSize: dimen13, color: Colors.black),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            status,
            style: boldTextStyle(fontSize: dimen12, color: textColor),
          ),
        ),
      ],
    );
  }

  Widget _buildReferenceRow(String refId) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "Ref ID: $refId",
            style: regularTextStyle(fontSize: dimen14, color: Colors.black),
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
}
