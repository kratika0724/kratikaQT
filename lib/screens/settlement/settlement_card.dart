import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_textstyles.dart';
import '../../models/sample models/payment_model.dart'; // Assuming your models are in this path

class SettlementCard extends StatelessWidget {
  final PaymentModel payment;
  final bool isExpanded;
  final VoidCallback onExpandToggle;

  const SettlementCard({
    Key? key,
    required this.payment,
    required this.isExpanded,
    required this.onExpandToggle,
  }) : super(key: key);



  // void _showActionPopup(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Payment request Action'),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           ListTile(
  //             leading: const Icon(Icons.check_circle, color: Colors.green),
  //             title: const Text('Accept'),
  //             onTap: () {
  //               Navigator.pop(context);
  //               // TODO: Implement accept action
  //             },
  //           ),
  //           ListTile(
  //             leading: const Icon(Icons.cancel, color: Colors.red),
  //             title: const Text('Reject'),
  //             onTap: () {
  //               Navigator.pop(context);
  //               // TODO: Implement reject action
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  void _showActionPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Confirm Payment',
              textAlign: TextAlign.center,
              style: mediumTextStyle(fontSize: dimen20, color: Colors.black),
            ),
            const SizedBox(height: 12),
            Text(
              "Tap Accept to confirm and complete this payment.",
              textAlign: TextAlign.center,
              style: mediumTextStyle(fontSize: dimen15, color: Colors.grey[600]!),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Payment Confirmed!")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green,
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        // side: const BorderSide(color: Colors.green),
                      ),
                    ),
                    icon: const Icon(Icons.check_circle, color: Colors.green),
                    label: const Text('Accept'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Implement reject action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red,
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        // side: const BorderSide(color: Colors.red),
                      ),
                    ),
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    label: const Text('Reject'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


// Inside your class...

  // void _showActionPopup(BuildContext context) {
  //   final GlobalKey<SlideActionState> _sliderKey = GlobalKey();
  //
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //       title: const Text('Confirm Payment'),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           const Text("Slide to confirm this payment", textAlign: TextAlign.center,),
  //           const SizedBox(height: 20),
  //           SlideAction(
  //             key: _sliderKey,
  //             innerColor: AppColors.secondary,
  //             outerColor: Colors.white,
  //             sliderButtonIcon: const Icon(Icons.arrow_forward, color: Colors.white),
  //             text: "  Slide to Pay",
  //             textStyle: boldTextStyle(fontSize: dimen14, color: Colors.black87),
  //             onSubmit: () {
  //               Navigator.pop(context);
  //
  //               // TODO: Trigger your payment logic here
  //
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 const SnackBar(content: Text("Payment Confirmed!")),
  //               );
  //             },
  //           ),
  //           const SizedBox(height: 10),
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Text("Cancel", style: mediumTextStyle(fontSize: dimen16, color: Colors.grey)),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(payment.status);
    final bgColorStatus = statusColor.withOpacity(0.1);
    final transactionTypeColor =
        _getTransactionTypeColor(payment.transactiontype);
    final bgColorTransactionType = transactionTypeColor.withOpacity(0.2);

    return GestureDetector(
      onTap: onExpandToggle,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: isExpanded ? AppColors.secondary.withOpacity(0.05) : Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildAmountRow(payment.amount , payment.createdAt, transactionTypeColor, context),
              Padding(
                padding: EdgeInsets.only(top: 2, bottom:4),
                child: DottedLine(
                    dashLength: 4.0, dashColor: Colors.grey.shade400, lineThickness: 0.5),
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildBaseInfoRow(payment.name,payment.status,
                      payment.transactiontype,
                      bgColorStatus,
                      statusColor,),
                  ),
                  SizedBox(
                    width: 2,
                  ),

                ],
              ),

              if (isExpanded)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow("Email", payment.email),
                      _buildInfoRow("Mobile", payment.mobile),
                      _buildInfoRow("Quintus ID", "${payment.transactionId}"),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildAmountRow(String transactionAmount, String formattedDate, Color textColor, BuildContext context) {
    final isCredit = payment.transactiontype.toLowerCase() == 'credit';
    final prefix = isCredit ? '+' : '-';
    final dateLabel = isCredit ? 'Received on' : 'Paid on';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "₹$transactionAmount",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: semiBoldTextStyle(fontSize: dimen16, color: AppColors.secondary),
                ),
                Text(
                  "$formattedDate",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: thinTextStyle(fontSize: dimen13, color: Colors.grey),
                ),
              ],
            ),
        ),
        ElevatedButton(
          onPressed: () => _showActionPopup(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: Colors.white,
            elevation: 0,
            shadowColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)) ,
          ),
          child: Text('Take Action',style: regularTextStyle(fontSize: dimen13, color: Colors.white), overflow: TextOverflow.ellipsis,),
        ),
      ],
    );
  }

  Widget _buildBaseInfoRow(String refId,String status,
      String transactionType,
      Color bgColorStatus,
      Color textColorStatus,) {
    return Row(
      children: [
        Expanded(
          child: Text(
            refId,
            style: regularTextStyle(fontSize: dimen15, color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Status Badge
        // Container(
        //   height: 15,
        //   width: 15,
        //   decoration: BoxDecoration(
        //     shape: BoxShape.circle,
        //     color: bgColorStatus,
        //   ),
        //   child: Padding(
        //     padding: const EdgeInsets.all(4.0),
        //     child: Container(
        //       decoration: BoxDecoration(
        //         shape: BoxShape.circle,
        //         color: textColorStatus,
        //       ),
        //     ),
        //   ),
        // ),
        // Container(
        //   constraints: const BoxConstraints(maxWidth: 120),
        //   padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 6),
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     // border: Border.all(color: textColorStatus.withOpacity(0.8),width: 0.7),
        //     borderRadius: BorderRadius.circular(6),
        //   ),
        //   child: Text(
        //     status,
        //     overflow: TextOverflow.ellipsis,
        //     maxLines: 1,
        //     style: mediumTextStyle(fontSize: dimen12, color: textColorStatus),
        //   ),
        // ),
        const Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 22),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text(label,
                  style:
                      mediumTextStyle(fontSize: dimen13, color: Colors.black))),
          const Text(": "),
          Expanded(
              flex: 6,
              child: Text(value,
                  style:
                      mediumTextStyle(fontSize: dimen13, color: Colors.black))),
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


