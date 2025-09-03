import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_textstyles.dart';
import '../../../models/response models/pending_bills_response.dart';
import '../../../providers/pending_bills_provider.dart';
import '../../../widgets/cash_payment_bottom_sheet.dart';

class PendingBillCard extends StatelessWidget {
  final PendingBillData pendingBill;
  final bool isExpanded;
  final VoidCallback onExpandToggle;

  const PendingBillCard({
    Key? key,
    required this.pendingBill,
    required this.isExpanded,
    required this.onExpandToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor('pending');
    final bgColorStatus = statusColor.withOpacity(0.1);

    return GestureDetector(
      onTap: onExpandToggle,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isExpanded ? bgColorStatus.withOpacity(0.1) : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: Row(
              crossAxisAlignment: isExpanded
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                // Avatar
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(0.1),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    pendingBill.fullName.isNotEmpty
                        ? pendingBill.fullName[0].toUpperCase()
                        : '',
                    style: boldTextStyle(
                        fontSize: dimen16, color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 12),

                // Content
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAmountRow(
                        pendingBill.balance,
                        pendingBill.fullName,
                        pendingBill.walletHistory.isNotEmpty
                            ? _formatDate(
                                pendingBill.walletHistory.first.createdAt)
                            : 'N/A',
                        bgColorStatus,
                        statusColor,
                        context,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        child: Row(
                          children: [
                            _buildSendPaymentLinkButton(context),
                            _buildCashPaymentButton(context),
                          ],
                        ),
                      ),
                      if (isExpanded)
                        Container(
                          margin: const EdgeInsets.only(top: 12.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow("Email", pendingBill.email),
                              _buildInfoRow("Mobile", pendingBill.mobile),
                              _buildInfoRow("Balance",
                                  "₹${pendingBill.balance.toStringAsFixed(2)}"),
                              _buildInfoRow(
                                  "Last Paid Amount",
                                  "₹" +
                                      pendingBill.walletHistory.last.amount
                                          .toString()),
                              _buildInfoRow(
                                  "Last Paid Date",
                                  _formatDate(pendingBill
                                      .walletHistory.last.createdAt)),
                              _buildInfoRow("Last Paid Mode", "Cash"),
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

  Widget _buildAmountRow(double balance, String name, String formattedDate,
      Color bgColorStatus, Color textColorStatus, BuildContext context) {
    final isNegative = balance < 0;
    final prefix = isNegative ? '' : '';
    final dateLabel = 'Last updated on';

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
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      name,
                      style: regularTextStyle(
                          fontSize: dimen15, color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: textColorStatus.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border:
                            Border.all(color: textColorStatus.withOpacity(0.3)),
                      ),
                      child: Text(
                        "$prefix ₹${balance.abs().toStringAsFixed(2)}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: boldTextStyle(
                            fontSize: dimen13, color: textColorStatus),
                      ),
                    ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Empty for now, can add additional info if needed
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text(label,
                  style: mediumTextStyle(
                      fontSize: dimen13, color: Colors.grey[700]))),
          const Text(": "),
          Expanded(
              flex: 6,
              child: Text(value,
                  style: semiBoldTextStyle(
                      fontSize: dimen13, color: Colors.black87))),
        ],
      ),
    );
  }

  Widget _buildSendPaymentLinkButton(BuildContext context) {
    return Consumer<PendingBillsProvider>(
      builder: (context, provider, child) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 6),
            child: ElevatedButton.icon(
              onPressed: provider.isInitiatingPayment
                  ? null
                  : () => _handleSendPaymentLink(context, provider),
              icon: provider.isInitiatingPayment
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(
                      Icons.link,
                      size: 16,
                      color: Colors.white,
                    ),
              label: Text(
                provider.isInitiatingPayment ? 'Sending...' : 'Payment Link',
                style: mediumTextStyle(fontSize: dimen12, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
                shadowColor: AppColors.primary.withOpacity(0.3),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCashPaymentButton(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(left: 6),
        child: ElevatedButton.icon(
          onPressed: () => _showCashPaymentBottomSheet(context),
          icon: const Icon(
            Icons.payment,
            size: 16,
            color: Colors.white,
          ),
          label: Text(
            'Cash Payment',
            style: mediumTextStyle(fontSize: dimen12, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.yellow,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
            shadowColor: AppColors.yellow.withOpacity(0.3),
          ),
        ),
      ),
    );
  }

  void _showCashPaymentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return CashPaymentBottomSheet(
          customerEmail: pendingBill.email,
          customerName: pendingBill.fullName,
        );
      },
    );
  }

  Future<void> _handleSendPaymentLink(
      BuildContext context, PendingBillsProvider provider) async {
    try {
      final success = await provider.initiatePaymentLink(
        context,
        pendingBill,
        pendingBill.balance.abs(),
      );

      if (success) {
        Fluttertoast.showToast(
          msg: "Payment link sent successfully!",
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to send payment link. Please try again.",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error sending payment link: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
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

  String _formatDate(DateTime date) {
    return "${date.day} ${_getMonthName(date.month)}, ${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}
