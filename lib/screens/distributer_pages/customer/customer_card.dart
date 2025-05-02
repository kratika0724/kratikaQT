import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qt_distributer/constants/app_colors.dart';
import 'package:qt_distributer/constants/app_textstyles.dart';
import '../../../models/response models/customer_response.dart';

class CustomerCard extends StatelessWidget {
  final CustomerData customer;
  final bool isExpanded;
  final VoidCallback onExpandToggle;

  const CustomerCard({
    Key? key,
    required this.customer,
    required this.isExpanded,
    required this.onExpandToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fullName = '${customer.firstName ?? ''} ${customer.middleName ?? ''} ${customer.lastName ?? ''}'.trim();
    final formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.parse(customer.createdAt!));

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: GestureDetector(
        onTap: onExpandToggle,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: Colors.white,
          ),
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(fullName),
              const SizedBox(height: 4),
              _buildSubHeader(customer.email ?? '', customer.mobile ?? ''),
              if (isExpanded) ...[
                const SizedBox(height: 8),
                DottedLine(
                  dashLength: 4.0,
                  dashColor: Colors.grey.shade300,
                  lineThickness: 1,
                ),
                const SizedBox(height: 8),
                _buildInfoRow('Agent', customer.agentName ?? '-'),
                _buildInfoRow('Created At', formattedDate),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String name) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name.toUpperCase(),
                style: semiBoldTextStyle(fontSize: dimen15, color: AppColors.textSecondary),
                overflow: TextOverflow.ellipsis,
              ),

            ],
          ),
        ),
        Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,color: Colors.black54),
      ],
    );
  }

  Widget _buildSubHeader(String email, String contact) {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Mobile no.- " +contact,
            style: regularTextStyle(fontSize: dimen13, color: Colors.black),
          ),
          Text(
            "Email id- " + email,
            style: regularTextStyle(fontSize: dimen14, color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: [Colors.indigo.shade900, Colors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      child: const Icon(Icons.person, size: 40, color: Colors.white),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 6.0, bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: mediumTextStyle(fontSize: dimen13, color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Text(': '),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: mediumTextStyle(fontSize: dimen13, color: Colors.black),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
