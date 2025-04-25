import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qt_distributer/screens/products/product_card.dart';
import 'package:qt_distributer/screens/products/product_filter_bottom_sheet.dart';
import 'package:qt_distributer/screens/products/product_list.dart';
import 'package:qt_distributer/widgets/common_text_widgets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_textstyles.dart';
import '../../models/response models/product_response.dart';
import '../../providers/product_provider.dart';
import '../../utils/device_utils.dart';
import '../../widgets/add_new_button.dart';
import '../../widgets/app_theme_button.dart';
import '../../widgets/filter_chips_widget.dart';
import 'add_product_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String? filterName;
  String? filterCode;

  bool get _hasFilters => filterName != null || filterCode != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyFilters();
      Provider.of<ProductProvider>(context, listen: false).getProductData(context);
    });
  }

  void _applyFilters() {
    Provider.of<ProductProvider>(context, listen: false).setFilters(
      name: filterName,
      code: filterCode,
    );
  }

  void _clearFilters() {
    setState(() {
      filterName = null;
      filterCode = null;
      _applyFilters();
    });
  }

  void _openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ProductFilterBottomSheet(
        initialName: filterName,
        initialCode: filterCode,
        onApply: (productName, productCode) {
          setState(() {
            filterName = productName;
            filterCode = productCode;
            _applyFilters();
          });
        },
        onClear: _clearFilters
      ),
    );
  }

  Widget _buildFilterButton() {
    return GestureDetector(
      onTap: () => _hasFilters ? _clearFilters() : _openFilterBottomSheet(),
      child: Container(
        height: 33,
        constraints: const BoxConstraints(maxWidth: 130),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: _hasFilters
              ? AppColors.secondary
              : AppColors.primary.withOpacity(0.1),
          border: Border.all(color: AppColors.secondary),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                _hasFilters ? "Clear Filters" : "Filter Products",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: mediumTextStyle(
                  fontSize: dimen14,
                  color: _hasFilters ? Colors.white : Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              _hasFilters ? Icons.clear : Icons.filter_list,
              size: 16,
              color: _hasFilters ? Colors.white : Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ghostWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back)),
            SizedBox(
              width: 20,
            ),
            HeaderTextBlack("Products"),
            Spacer(),
            // Filter or Clear Filter Button
            _buildFilterButton(),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null && provider.products.isEmpty) {
            return const Center(child: Text("Oops! Something went wrong"));
          }
          if (provider.products.isEmpty) {
            return const Center(child: Text("No Data Found!"));
          }

          return Column(
            children: [
              if (_hasFilters)
                FilterChipsWidget(
                  filters: {
                    'Name': filterName,
                    'Code': filterCode,
                  },
                  onClear: _clearFilters,
                ),

              Expanded(
                child: ProductList(
                    products: provider.products,
                    filterName: filterName,
                    filterCode: filterCode
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 8),
            child: SizedBox(
              height: 45,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddProductScreen()),
                  );
                },
                icon: const Icon(Icons.add, size: 18, color: Colors.white),
                label: Text(
                  'Add Product',
                  style:
                      mediumTextStyle(fontSize: dimen15, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
