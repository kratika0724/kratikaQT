import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qt_distributer/screens/distributer_pages/products/product_card.dart';
import '../../../models/response models/product_response.dart';
import '../../../providers/product_provider.dart';
import '../../../utils/device_utils.dart';

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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
          !Provider.of<ProductProvider>(context, listen: false).isFetchingMore) {
        Provider.of<ProductProvider>(context, listen: false)
            .getProductData(context, loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
    final isOdd = products.length.isOdd;
    final totalItems = isOdd ? products.length + 1 : products.length;

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: totalItems,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        if (index >= products.length) {
          // Return an empty widget to balance the grid layout
          return const SizedBox();
        }

        return ProductCard(
          product: products[index],
        );
      },
    );
  }

  Widget _buildListView(List<ProductModel> products) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(top: 5),
      itemCount: products.length,
        itemBuilder: (context, index) => ProductCard(
            product: products[index]
        ),
    );
  }
}

