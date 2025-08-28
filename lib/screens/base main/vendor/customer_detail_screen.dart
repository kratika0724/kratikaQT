import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_textstyles.dart';
import '../../../models/response models/customer_response.dart';

class CustomerDetailScreen extends StatelessWidget {
  final CustomerData customer;

  const CustomerDetailScreen({
    Key? key,
    required this.customer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fullName =
        '${customer.firstName ?? ''} ${customer.middleName ?? ''} ${customer.lastName ?? ''}'
            .trim();
    final formattedCreatedDate = DateFormat('dd MMM yyyy, hh:mm a')
        .format(DateTime.parse(customer.createdAt));
    final formattedUpdatedDate = DateFormat('dd MMM yyyy, hh:mm a')
        .format(DateTime.parse(customer.updatedAt));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Customer Details',
          style: semiBoldTextStyle(fontSize: dimen18, color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(fullName),
            const SizedBox(height: 16),
            _buildInfoSection('Personal Information', [
              _buildInfoRow('Full Name', fullName),
              _buildInfoRow('Mobile Number', customer.mobile),
              _buildInfoRow('Email Address', customer.email),
              _buildInfoRow(
                  'Address',
                  customer.address.isNotEmpty
                      ? customer.address
                      : 'Not provided'),
              _buildInfoRow('Created At', formattedCreatedDate),
            ]),
            const SizedBox(height: 16),
            _buildInfoSection('Associated Information', [
              _buildInfoRow(
                  'Agent',
                  customer.agentName.isNotEmpty
                      ? customer.agentName
                      : 'Not assigned'),
              _buildInfoRow(
                  'Distributer',
                  customer.topVendorName.isNotEmpty
                      ? customer.topVendorName
                      : 'Not assigned'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(String fullName) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary,
            child: Text(
              fullName.isNotEmpty ? fullName[0].toUpperCase() : 'C',
              style: semiBoldTextStyle(fontSize: dimen24, color: Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            fullName.isNotEmpty ? fullName.toUpperCase() : 'Customer',
            style: semiBoldTextStyle(
                fontSize: dimen18, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Customer',
            style: regularTextStyle(fontSize: dimen14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: semiBoldTextStyle(
                fontSize: dimen16, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style:
                  mediumTextStyle(fontSize: dimen14, color: Colors.grey[700]),
            ),
          ),
          const Text(': '),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: regularTextStyle(fontSize: dimen14, color: Colors.black87),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
