import 'package:flutter/material.dart';
import 'package:qt_distributer/models/response%20models/product_response.dart';
import 'package:qt_distributer/screens/products/product_card.dart';

import '../../utils/device_utils.dart';

class ProductList extends StatelessWidget {
  final List<ProductModel> products;
  final String? filterName;
  final String? filterCode;

  const ProductList({
    super.key,
    required this.products,
    this.filterName,
    this.filterCode,
  });

  @override
  Widget build(BuildContext context) {
    final filteredProducts = products.where((product) {
      final matchesName = filterName == null || product.productName?.contains(filterName!) == true;
      final matchesCode = filterCode == null || product.productCode?.toLowerCase().contains(filterCode!.toLowerCase()) == true;
      return matchesName && matchesCode;
    }).toList();

    if (filteredProducts.isEmpty) {
      return const Center(child: Text("No matching products found."));
    }

    final isWide = DeviceUtils.getDeviceWidth(context);

    return isWide
        ? GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: filteredProducts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 100, // Adjust height as needed
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        return ProductCard(product: filteredProducts[index]);
      },
    ) : ListView.builder(
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: ProductCard(product: filteredProducts[index]),
        );
      },
    );
  }
}
