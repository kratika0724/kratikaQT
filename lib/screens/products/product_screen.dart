import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qt_distributer/screens/products/product_filter_bottom_sheet.dart';
import 'package:qt_distributer/screens/products/product_list.dart';
import 'package:qt_distributer/widgets/common_text_widgets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_textstyles.dart';
import '../../models/response models/product_response.dart';
import '../../providers/product_provider.dart';
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

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ProductProvider>(context, listen: false).getProductData();
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
          });
        },
        onClear: () {
          setState(() {
            filterName = null;
            filterCode = null;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ghostWhite,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90), // 👈 Increase height
        child: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          title: HeaderTextBlack("Products"),
          automaticallyImplyLeading: true,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AddProductScreen()),
                          );
                        },
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            color: AppColors.primary.withOpacity(0.1),
                            border: Border.all(color: AppColors.secondary),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Add Products ",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: mediumTextStyle(fontSize: dimen13, color: Colors.black),
                                ),
                                const Icon(Icons.add, size: 16, color: Colors.black),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => _openFilterBottomSheet(),
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            color: AppColors.primary.withOpacity(0.1),
                            border: Border.all(color: AppColors.secondary),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Filter ",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: mediumTextStyle(fontSize: dimen13, color: Colors.black),
                                ),
                                const Icon(Icons.filter_list, size: 16, color: Colors.black),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      body: Consumer<ProductProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) return const Center(child: CircularProgressIndicator());
          if (provider.errorMessage != null) return const Center(child: Text("Oops! Something went wrong"));

          return Column(
            children: [
              if (filterName != null || filterCode != null)
                FilterChipsWidget(
                  filters: {
                    'Name': filterName,
                    'Code': filterCode,
                  },
                  onClear: () => setState(() {
                    filterCode = null;
                    filterName = null;
                  }),
                ),

                Expanded(
                  child: ProductList(
                    products: provider.products,
                    filterName: filterName,
                    filterCode: filterCode,
                  ),
                ),
              const SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }
}
