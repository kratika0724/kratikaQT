import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qt_distributer/screens/products/product_card.dart';
import '../../models/response models/product_response.dart';
import '../../providers/product_provider.dart';
import '../../utils/device_utils.dart';

class ProductList extends StatefulWidget {
  final List<ProductModel> products;
  final String? filterName;
  final String? filterCode;

  const ProductList({
    required this.products,
    this.filterName,
    this.filterCode,
    super.key,
  });

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    final isWide = DeviceUtils.getDeviceWidth(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final filteredProducts = productProvider.FilteredProducts;

    if (filteredProducts.isEmpty) {
      return const Center(child: Text("No products found."));
    }

    return isWide
        ? _buildGridView(filteredProducts)
        : _buildListView(filteredProducts);
  }

  Widget _buildGridView(List<ProductModel> products) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: products.length + 1,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        // mainAxisExtent: 110,
        childAspectRatio: 3.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) => ProductCard(
          product: products[index]
      ),
    );
  }

  Widget _buildListView(List<ProductModel> products) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10),
      itemCount: products.length,
        itemBuilder: (context, index) => ProductCard(
            product: products[index]
        ),
    );
  }
}

