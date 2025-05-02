// import 'package:flutter/material.dart';
// import 'package:qt_distributer/constants/app_textstyles.dart';
// import '../../models/response models/allocation_response.dart';
//
// class AllocationCard extends StatelessWidget {
//   final AllocationModel allocation;
//
//   const AllocationCard({
//     Key? key,
//     required this.allocation,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 2),
//       padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(6.0),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.textBlack.withOpacity(0.03),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           )
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildInfoRow("Pincode", allocation.allocationPincode ?? "N/A"),
//           _buildInfoRow("Area", allocation.allocationArea ?? "N/A"),
//           // Row(
//           //   mainAxisAlignment: MainAxisAlignment.end,
//           //   children: [
//           //     Text(
//           //       "Created At " +_formatDate(allocation.createdAt),
//           //       style: mediumTextStyle(fontSize: dimen13, color: AppColors.textBlack54),
//           //       overflow: TextOverflow.ellipsis,
//           //     ),
//           //   ],
//           // ),
//           _buildInfoRow("Created At", _formatDate(allocation.createdAt)),
//           // _buildInfoRow("Created By", allocation.createdBy ?? "N/A"),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 0.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 100,
//             child: Text(
//               label,
//               style: mediumTextStyle(fontSize: dimen13, color: AppColors.textBlack),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           const Text(': '),
//           Expanded(
//             child: Text(
//               value,
//               style: mediumTextStyle(fontSize: dimen13, color: AppColors.textBlack54),
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _formatDate(DateTime? date) {
//     if (date == null) return 'N/A';
//     return date.toLocal().toString().split(' ')[0];
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qt_distributer/constants/app_textstyles.dart';
import '../../../constants/app_colors.dart';
import '../../../models/response models/allocation_response.dart';

class AllocationCard extends StatelessWidget {
  final AllocationModel allocation;

  const AllocationCard({
    Key? key,
    required this.allocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 8.0),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.grey100),
        boxShadow: [
          BoxShadow(
            color: AppColors.textBlack.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Top: Pincode and Area in a row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex:2,
                  child: _buildLabelValuePincode("Pincode", allocation.allocationPincode ?? "N/A"),
              ),
              Expanded(
                  flex: 3 ,
                  child: _buildLabelValueArea("Area", allocation.allocationArea ?? "N/A")
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Single line Created At
          Row(
            children: [
              Flexible(
                child: Text(
                  "Created At: ",
                  style: mediumTextStyle(fontSize: dimen13, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Expanded(
                // flex: 3,
                child: Text(
                  _formatFullDate(allocation.createdAt),
                  style: mediumTextStyle(fontSize: dimen13, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabelValuePincode(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: semiBoldTextStyle(fontSize: dimen13, color: AppColors.textBlack),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        // const SizedBox(height: 2),
        Text(
          value,
          style: mediumTextStyle(fontSize: dimen14, color: AppColors.textBlack),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }

  Widget _buildLabelValueArea(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            label,
            style: semiBoldTextStyle(fontSize: dimen13, color: AppColors.textBlack),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: mediumTextStyle(fontSize: dimen14, color: AppColors.textBlack),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  String _formatFullDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('dd MMM, yyyy hh:mm a').format(date.toLocal());
  }
}
