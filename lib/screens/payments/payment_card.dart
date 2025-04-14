import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:qt_distributer/models/payment_model.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_textstyles.dart';

class PaymentCard extends StatelessWidget {
  final PaymentModel payment;

  const PaymentCard({Key? key, required this.payment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = payment.status;
    final bgColor = _getStatusColor(status).withOpacity(0.3);
    final textColor = _getStatusColor(status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.secondary,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _buildTransactionRow(payment.transactionId),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    payment.transactionId,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: semiBoldTextStyle(fontSize: dimen14, color: Colors.white),
                  ),
                ),
                Text(
                  payment.createdAt,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: thinTextStyle(fontSize: dimen12, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 3),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: DottedLine(dashLength: 6.0, dashColor: Colors.white70),
            ),
            _buildLabelValueRow('Name', payment.name),
            _buildLabelValueRow('Email', payment.email),
            const SizedBox(height: 10),
            const Divider(thickness: 0.3, color: AppColors.primary),
            _buildAmountAndStatus(payment.amount, status, bgColor, textColor),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionRow(String transactionId) {
    return Row(
      children: [
        Text("Transaction ID: ", style: regularTextStyle(fontSize: dimen14, color: Colors.white)),
        Flexible(
          child: Text(
            transactionId,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: semiBoldTextStyle(fontSize: dimen14, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildLabelValueRow(String label, String value){
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              '$label:',
              style: regularTextStyle(fontSize: dimen13, color: Colors.white),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: semiBoldTextStyle(fontSize: dimen13, color: Colors.white),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountAndStatus(String amount, String status, Color bgColor, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
            amount,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: semiBoldTextStyle(fontSize: dimen16, color: Colors.white)),
        Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
          child: Text(
            status,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: boldTextStyle(fontSize: dimen12, color: textColor),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Success':
        return Colors.green;
      case 'Pending':
        return Colors.yellow.shade700;
      case 'Failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
