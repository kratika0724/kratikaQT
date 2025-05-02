import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_textstyles.dart';
import '../../../models/sample models/payment_model.dart';

class VendorPaymentCard extends StatelessWidget {
  final PaymentModel payment;
  final bool isExpanded;
  final VoidCallback onExpandToggle;

  const VendorPaymentCard({
    Key? key,
    required this.payment,
    required this.isExpanded,
    required this.onExpandToggle,
  }) : super(key: key);

  //normal build without expanding animation
  @override
  // Widget build(BuildContext context) {
  //   final statusColor = _getStatusColor(payment.status);
  //   final bgColorStatus = statusColor.withOpacity(0.1);
  //   final transactionTypeColor = _getTransactionTypeColor(payment.transactiontype);
  //   final bgColorTransactionType = transactionTypeColor.withOpacity(0.2);
  //
  //   return GestureDetector(
  //     onTap: onExpandToggle,
  //     child: Container(
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(6),
  //         color: isExpanded ? bgColorStatus.withOpacity(0.1): Colors.white,
  //       ),
  //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
  //       child: Padding(
  //         padding: const EdgeInsets.only(bottom: 0.0),
  //         child: Row(
  //           crossAxisAlignment: isExpanded ? CrossAxisAlignment.start : CrossAxisAlignment.center,
  //           children: [
  //             // 🟢 Circle Avatar for Initials
  //             Container(
  //               width: 40,
  //               height: 40,
  //               decoration: BoxDecoration(
  //                 shape: BoxShape.circle,
  //                 color: AppColors.secondary.withOpacity(0.2),
  //               ),
  //               alignment: Alignment.center,
  //               child: Text(
  //                 payment.name.isNotEmpty ? payment.name[0].toUpperCase() : '',
  //                 style: boldTextStyle(fontSize: dimen18, color: AppColors.secondary),
  //               ),
  //             ),
  //             const SizedBox(width: 10),
  //
  //             // 🟢 Wrap this part in a Flexible widget to avoid layout issues
  //             Flexible(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   _buildAmountRow(
  //                     payment.amount,
  //                     payment.name,
  //                     payment.createdAt,
  //                     payment.status,
  //                     bgColorStatus,
  //                     statusColor,
  //                     bgColorTransactionType,
  //                     transactionTypeColor,
  //                     context,
  //                   ),
  //                   const SizedBox(height: 2),
  //                   _buildStatusRow(
  //                     payment.status,
  //                     bgColorStatus,
  //                     statusColor,
  //
  //                   ),
  //                   // Row(
  //                   //   children: [
  //                   //     Expanded(
  //                   //       child: _buildBaseInfoRow(
  //                   //         payment.name,
  //                   //         payment.status,
  //                   //         payment.transactiontype,
  //                   //         bgColorStatus,
  //                   //         statusColor,
  //                   //         payment.createdAt,
  //                   //       ),
  //                   //     ),
  //                   //   ],
  //                   // ),
  //                   if (isExpanded)
  //                     Padding(
  //                       padding: const EdgeInsets.only(top: 8.0),
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           _buildInfoRow("Email", payment.email),
  //                           _buildInfoRow("Mobile", payment.mobile),
  //                           _buildInfoRow("Quintus ID", "${payment.transactionId}"),
  //                         ],
  //                       ),
  //                     ),
  //
  //
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  //Animated build
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(payment.status);
    final bgColorStatus = statusColor.withOpacity(0.1);
    final transactionTypeColor = _getTransactionTypeColor(payment.transactiontype);
    final bgColorTransactionType = transactionTypeColor.withOpacity(0.2);

    return GestureDetector(
      onTap: onExpandToggle,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: isExpanded ? bgColorStatus.withOpacity(0.1): Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: Row(
              crossAxisAlignment: isExpanded ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                // Avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.secondary.withOpacity(0.2),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    payment.name.isNotEmpty ? payment.name[0].toUpperCase() : '',
                    style: boldTextStyle(fontSize: dimen18, color: AppColors.secondary),
                  ),
                ),
                const SizedBox(width: 10),

                // Content
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAmountRow(
                        payment.amount,
                        payment.name,
                        payment.createdAt,
                        payment.status,
                        bgColorStatus,
                        statusColor,
                        bgColorTransactionType,
                        transactionTypeColor,
                        context,
                      ),
                      const SizedBox(height: 2),
                      _buildStatusRow(
                        payment.status,
                        bgColorStatus,
                        statusColor,
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
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildAmountRow(String transactionAmount, String refId, String formattedDate, String status, Color bgColorStatus, Color textColorStatus, Color bgColorTransactionType , Color textColor, BuildContext context) {
    final isCredit = payment.transactiontype.toLowerCase() == 'credit';
    final prefix = isCredit ? '+' : '-';
    final dateLabel = isCredit ? 'Received on' : 'Paid on';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    refId,
                    style: regularTextStyle(fontSize: dimen15, color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "$prefix ₹$transactionAmount",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: semiBoldTextStyle(fontSize: dimen14, color: textColor),
                  ),
                ],
              ),
              Text(
                "$dateLabel $formattedDate",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: thinTextStyle(fontSize: dimen13, color: Colors.grey),
              ),
            ],
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Text(
            //   "$prefix ₹$transactionAmount",
            //   overflow: TextOverflow.ellipsis,
            //   maxLines: 1,
            //   style: semiBoldTextStyle(fontSize: dimen14, color: textColor),
            // ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Container(
                //   constraints: const BoxConstraints(maxWidth: 120),
                //   padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
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
                // const Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 20),
              ],
            ),

          ],
        ),


        // const Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 22),
      ],

    );
  }

  Widget _buildStatusRow(String status, Color bgColorStatus, Color textColorStatus) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 120),
          padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
          decoration: BoxDecoration(
            color: bgColorStatus,
            // border: Border.all(color: textColorStatus.withOpacity(0.8),width: 0.7),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            status,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: mediumTextStyle(fontSize: dimen12, color: textColorStatus),
          ),
        ),
        Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.black, size: 20),
      ],
    );
  }
  Widget _buildBaseInfoRow(String refId,String status,
      String transactionType,
      Color bgColorStatus,
      Color textColorStatus,
      String formattedDate,
      ) {
    final isCredit = payment.transactiontype.toLowerCase() == 'credit';
    final dateLabel = isCredit ? 'Received on' : 'Paid on';

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                refId,
                style: regularTextStyle(fontSize: dimen15, color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "$dateLabel $formattedDate",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: thinTextStyle(fontSize: dimen13, color: Colors.grey),
              ),
            ],
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
