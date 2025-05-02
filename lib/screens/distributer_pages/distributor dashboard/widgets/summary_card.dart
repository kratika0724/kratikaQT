import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_textstyles.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final int count;

  const SummaryCard({
    Key? key,
    required this.title,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: AppColors.primary.withOpacity(0.1),
      ),
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Text(
            '$count',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: semiBoldTextStyle(
                fontSize: dimen20, color: AppColors.secondary),
          ),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style:
                mediumTextStyle(fontSize: dimen14, color: AppColors.secondary),
          ),
        ],
      ),
    );
  }
}
