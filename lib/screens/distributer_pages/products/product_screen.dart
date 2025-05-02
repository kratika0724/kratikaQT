import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qt_distributer/screens/distributer_pages/products/product_filter_bottom_sheet.dart';
import 'package:qt_distributer/screens/distributer_pages/products/product_list.dart';
import 'package:qt_distributer/widgets/common_text_widgets.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_textstyles.dart';
import '../../../providers/product_provider.dart';
import '../../../widgets/bottom_add_button.dart';
import '../../../widgets/filter_button.dart';
import '../../../widgets/filter_chips_widget.dart';
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
            FilterButton(
              hasFilters: _hasFilters,
              label: "Products",
              maxWidth: 140,
              onApplyTap: _openFilterBottomSheet,
              onClearTap: _clearFilters,
            ),
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
      bottomNavigationBar: BottomAddButton(
        label: 'Add Product',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddProductScreen(),
            ),
          );
        },
      ),
    );
  }
}
