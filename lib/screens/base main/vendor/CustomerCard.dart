import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qt_distributer/constants/app_colors.dart';
import 'package:qt_distributer/constants/app_textstyles.dart';
import '../../../models/response models/customer_response.dart';
import 'customer_detail_screen.dart';

class CustomerCard extends StatelessWidget {
  final CustomerData customer;

  const CustomerCard({
    Key? key,
    required this.customer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fullName =
        '${customer.firstName ?? ''} ${customer.middleName ?? ''} ${customer.lastName ?? ''}'
            .trim();
    final formattedDate = DateFormat('dd MMM yyyy, hh:mm a')
        .format(DateTime.parse(customer.createdAt));

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomerDetailScreen(customer: customer),
          ),
        );
      },
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
            _buildSubHeader(customer.email, customer.mobile),
            _buildInfoRow('Created At', formattedDate),
          ],
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
                style: semiBoldTextStyle(
                    fontSize: dimen15, color: AppColors.textSecondary),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Icon(Icons.arrow_forward_ios, color: Colors.black54, size: 16),
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
            "Mobile no.- " + contact,
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label + "- " + value,
              style: mediumTextStyle(fontSize: dimen13, color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
