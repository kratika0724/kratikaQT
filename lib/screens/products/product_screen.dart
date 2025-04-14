import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qt_distributer/widgets/common_text_widgets.dart';
import '../../constants/app_colors.dart';
import '../../models/product_response.dart';
import '../../providers/product_provider.dart';
import '../../widgets/add_new_button.dart';
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

  void openFilterBottomSheet(BuildContext context) {
    final nameController = TextEditingController(text: filterName ?? '');
    final codeController = TextEditingController(text: filterCode ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: codeController,
                decoration: const InputDecoration(
                  labelText: 'Product Code',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          filterName = nameController.text.trim().isNotEmpty
                              ? nameController.text.trim()
                              : null;
                          filterCode = codeController.text.trim().isNotEmpty
                              ? codeController.text.trim()
                              : null;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("Apply Filters"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          filterName = null;
                          filterCode = null;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("Clear Filters"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  List<ProductModel> _applyFilters(List<ProductModel> products) {
    return products.where((product) {
      final nameMatch = filterName == null ||
          product.productName.toLowerCase().contains(filterName!.toLowerCase());
      final codeMatch = filterCode == null ||
          product.productCode.toLowerCase().contains(filterCode!.toLowerCase());
      return nameMatch && codeMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: HeaderTextThemeSecondary("Products"),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.secondary,
        elevation: 3,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.secondary),
            onPressed: () => openFilterBottomSheet(context),
          )
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }

          final filteredProducts = _applyFilters(provider.products);

          return Column(
            children: [
              if (filterName != null || filterCode != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (filterName != null || filterCode != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                if (filterName != null)
                                  Chip(
                                    label: Text(
                                      "Name: $filterName",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 1,
                                    ),
                                    backgroundColor: AppColors.secondary,
                                    visualDensity: VisualDensity.compact,
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                if (filterCode != null)
                                  Chip(
                                    label: Text(
                                      "Code: $filterCode",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 1,
                                    ),
                                    backgroundColor: AppColors.secondary,
                                    visualDensity: VisualDensity.compact,
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      if (filterName != null || filterCode != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.grey[200],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                onPressed: () {
                                  setState(() {
                                    filterName = null;
                                    filterCode = null;
                                  });
                                },
                                child: const Text(
                                  "Clear Filters",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  )


                ),
              if (filteredProducts.isEmpty)
                const Expanded(
                  child: Center(child: Text("No products found")),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Name: ${product.productName}", style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text("Code: ${product.productCode}"),
                              Text("Amount: ₹${product.productAmount}"),
                              Text("Created at: ${product.createdAt.toLocal()}"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AddNewButton(
                      label: 'Add New Product',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AddProductScreen()),
                        );
                      },
                    ),
                  ],
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
