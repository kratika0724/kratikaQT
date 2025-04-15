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
      margin: const EdgeInsets.only(bottom: 6),
      color: AppColors.secondary,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _buildTransactionRow(payment.transactionId),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    payment.amount,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: boldTextStyle(fontSize: dimen14, color: Colors.white),
                  ),
                ),
                Text(
                  payment.transactionId,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: mediumTextStyle(fontSize: dimen14, color: Colors.white),
                ),
              ],
            ),
            // const SizedBox(height: 3),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: DottedLine(dashLength: 4.0, dashColor: Colors.white70,lineThickness: 0.3,),
            ),
            _buildLabelValueRow(payment.name, payment.createdAt, status,bgColor, textColor),
            // _buildLabelValueRow('Email', payment.email),
            // const SizedBox(height: 10),
            // const Divider(thickness: 0.3, color: AppColors.primary),
            // _buildAmountAndStatus(payment.amount, status, bgColor, textColor),
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

  Widget _buildLabelValueRow( String value,String transactionId ,String status,Color bgColor, Color textColor){
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Row(
        children: [
          Text(
            value+', ',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: mediumTextStyle(fontSize: dimen14, color: Colors.white),
          ),
          Text(
              transactionId,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: thinTextStyle(fontSize: dimen12, color: Colors.white)),
          Spacer(),
          Text(
            status,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: boldTextStyle(fontSize: dimen12, color: textColor),
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
