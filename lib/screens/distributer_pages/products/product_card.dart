import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_textstyles.dart';
import '../../../constants/app_colors.dart';
import '../../../models/response models/product_response.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopRow(context),
          const SizedBox(height: 8),
          _buildCreatedAtText(),
        ],
      ),
    );
  }

  Widget _buildTopRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            flex: 3,
            child: _buildNameAndCode(),
        ),
        Expanded(
          flex: 1,
            child: _buildAmountText(),
        ),
      ],
    );
  }

  Widget _buildNameAndCode() {
    final productName = product.productName ?? "N/A";
    final productCode = product.productCode != null ? "#${product.productCode}" : "N/A";

    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            productName,
            style: semiBoldTextStyle(
              fontSize: dimen14,
              color: Colors.black,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            productCode,
            style: mediumTextStyle(
              fontSize: dimen13,
              color: Colors.grey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAmountText() {
    final productAmount = product.productAmount != null
        ? "₹${product.productAmount}"
        : "N/A";

    return Text(
      productAmount,
      style: boldTextStyle(
        fontSize: dimen14,
        color: AppColors.secondary,
      ),
      textAlign: TextAlign.end,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildCreatedAtText() {
    return Text(
      "Created at: ${_formatFullDate(product.createdAt)}",
      style: mediumTextStyle(
        fontSize: dimen13,
        color: Colors.black54,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  String _formatFullDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('dd MMM, yyyy hh:mm a').format(date.toLocal());
  }
}
