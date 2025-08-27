import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_textstyles.dart';
import '../../../models/response models/pending_bills_response.dart';
import '../../../providers/pending_bills_provider.dart';

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
            borderRadius: BorderRadius.circular(6),
            color: isExpanded ? bgColorStatus.withOpacity(0.1) : Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: Row(
              crossAxisAlignment: isExpanded
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
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
                    pendingBill.fullName.isNotEmpty
                        ? pendingBill.fullName[0].toUpperCase()
                        : '',
                    style: boldTextStyle(
                        fontSize: dimen18, color: AppColors.secondary),
                  ),
                ),
                const SizedBox(width: 10),

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
                      const SizedBox(height: 2),
                      _buildStatusRow(
                        'Pending',
                        bgColorStatus,
                        statusColor,
                      ),
                      if (isExpanded)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
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
                              const SizedBox(height: 12),
                              _buildSendPaymentLinkButton(context),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: regularTextStyle(
                        fontSize: dimen15, color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "$prefix ₹${balance.abs().toStringAsFixed(2)}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: semiBoldTextStyle(
                        fontSize: dimen14, color: textColorStatus),
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

  Widget _buildStatusRow(
      String status, Color bgColorStatus, Color textColorStatus) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 120),
          padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
          decoration: BoxDecoration(
            color: bgColorStatus,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            status,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: mediumTextStyle(fontSize: dimen12, color: textColorStatus),
          ),
        ),
        Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: Colors.black, size: 20),
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

  Widget _buildSendPaymentLinkButton(BuildContext context) {
    return Consumer<PendingBillsProvider>(
      builder: (context, provider, child) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: provider.isInitiatingPayment
                ? null
                : () => _handleSendPaymentLink(context, provider),
            icon: provider.isInitiatingPayment
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(
                    Icons.payment,
                    size: 18,
                    color: AppColors.ghostWhite,
                  ),
            label: Text(
              provider.isInitiatingPayment ? 'Sending...' : 'Send Payment Link',
              style: mediumTextStyle(
                  fontSize: dimen14, color: AppColors.ghostWhite),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.yellow,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
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
