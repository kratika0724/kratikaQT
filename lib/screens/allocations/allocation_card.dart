import 'package:flutter/material.dart';
import 'package:qt_distributer/constants/app_colors.dart';
import 'package:qt_distributer/constants/app_textstyles.dart';
import '../../models/allocation_model.dart';

class AllocationCard extends StatelessWidget {
  final AllocationModel allocation;

  const AllocationCard({super.key, required this.allocation});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _labelValue('Pincode', allocation.allocationPincode),
            _labelValue('Area', allocation.allocationArea),
            _labelValue('Actions', allocation.actions),
            _labelValue('Created At', allocation.createdAt),
          ],
        ),
      ),
    );
  }

  Widget _labelValue(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text('$label:', style: regularTextStyle(fontSize: dimen13, color: Colors.black54)),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: mediumTextStyle(fontSize: dimen13, color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
