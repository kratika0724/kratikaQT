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
    final bgColor = _getStatusColor(status).withOpacity(0.2);
    final textColor = _getStatusColor(status);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           _buildAmountAndStatus(payment.amount, payment.createdAt, payment.status, bgColor, textColor),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: DottedLine(dashLength: 4.0, dashColor: Colors.grey.shade400,lineThickness: 1,),
            ),
            _buildTransactionRow(payment.transactionId),
           ],
        ),
      ),
    );
  }

  Widget _buildTransactionRow(String transactionId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Text("Transaction ID: ", style: regularTextStyle(fontSize: dimen14, color: Colors.black)),
        Flexible(
          flex: 4,
          child: Text(
            "Transaction ID: "+ transactionId,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: regularTextStyle(fontSize: dimen14, color: Colors.black),
          ),
        ),
        Spacer(),
        const Icon(
          Icons.keyboard_arrow_down,
          color: Colors.black,size: 22,
        ),
      ],
    );
  }

  Widget _buildAmountAndStatus(String amount, String createdAt, String status, Color bgColor, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                amount,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: semiBoldTextStyle(fontSize: dimen16, color: textColor),
            ),
            Text(
              createdAt,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: thinTextStyle(fontSize: dimen13, color: Colors.black),
            ),

          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
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
        return Color(0xff1c5e20);
      case 'Pending':
        return Color(0xfffdbb00);
      case 'Failed':
        return Color(0xfffb0e00);
      default:
        return Colors.grey;
    }
  }
}
