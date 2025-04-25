import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_textstyles.dart';
import '../../models/sample models/distributor_model.dart';

class DistributorCard extends StatelessWidget {
  final DistributorModel distributor;
  final bool isExpanded;
  final VoidCallback onExpandToggle;

  const DistributorCard({
    Key? key,
    required this.distributor,
    required this.isExpanded,
    required this.onExpandToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(distributor.createdAt);

    return GestureDetector(
      onTap: onExpandToggle,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: isExpanded ? AppColors.primary.withOpacity(0.05) : Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  distributor.name,
                  style: semiBoldTextStyle(fontSize: dimen16, color: Colors.black),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.black),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              formattedDate,
              style: thinTextStyle(fontSize: dimen13, color: Colors.black),
            ),
            if (isExpanded) ...[
              const SizedBox(height: 8),
              _buildInfoRow("Email", distributor.email),
              _buildInfoRow("Contact", distributor.contact),
            ]
          ],
        ),
      ),
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
                  style: mediumTextStyle(fontSize: dimen13, color: Colors.black))),
          const Text(": "),
          Expanded(
              flex: 6,
              child: Text(value,
                  style: mediumTextStyle(fontSize: dimen13, color: Colors.black))),
        ],
      ),
    );
  }
}

