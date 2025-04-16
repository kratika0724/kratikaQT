import 'package:flutter/material.dart';
import 'package:qt_distributer/constants/app_textstyles.dart';
import '../../models/allocation_model.dart';
import '../../models/allocation_reponse_model.dart';

class AllocationCard extends StatelessWidget {
  final AllocationModel allocation;

  const AllocationCard({
    Key? key,
    required this.allocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("Pincode", allocation.allocationPincode ?? "N/A"),
          _buildInfoRow("Area", allocation.allocationArea ?? "N/A"),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     Text(
          //       "Created At " +_formatDate(allocation.createdAt),
          //       style: mediumTextStyle(fontSize: dimen13, color: Colors.black54),
          //       overflow: TextOverflow.ellipsis,
          //     ),
          //   ],
          // ),
          _buildInfoRow("Created At", _formatDate(allocation.createdAt)),
          // _buildInfoRow("Created By", allocation.createdBy ?? "N/A"),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: mediumTextStyle(fontSize: dimen13, color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: mediumTextStyle(fontSize: dimen13, color: Colors.black54),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return date.toLocal().toString().split(' ')[0];
  }
}
