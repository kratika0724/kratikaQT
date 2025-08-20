import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_textstyles.dart';

class VendorSummaryCard extends StatelessWidget {
  final String title;
  final int count;
  final bool isCurrency;

  const VendorSummaryCard({
    Key? key,
    required this.title,
    required this.count,
    this.isCurrency = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.08),
            AppColors.primary.withOpacity(0.12),
          ],
        ),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(
                  _getIconForTitle(title),
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                isCurrency ? '₹${count.toStringAsFixed(0)}' : count.toString(),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: boldTextStyle(
                  fontSize: dimen22,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: mediumTextStyle(
              fontSize: dimen14,
              color: AppColors.secondary.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    switch (title.toLowerCase()) {
      case 'wallet balance':
        return Icons.account_balance_wallet;
      case 'hold amount':
        return Icons.pause_circle_outline;
      case 'payout balance':
        return Icons.payment;
      default:
        return Icons.attach_money;
    }
  }
}
