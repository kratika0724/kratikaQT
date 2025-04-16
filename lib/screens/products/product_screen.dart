import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qt_distributer/widgets/common_text_widgets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_textstyles.dart';
import '../../models/product_response.dart';
import '../../providers/product_provider.dart';
import '../../widgets/add_new_button.dart';
import '../../widgets/app_theme_button.dart';
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
    final provider = Provider.of<ProductProvider>(context, listen: false);
    final nameController = TextEditingController(text: filterName ?? '');
    final codeController = TextEditingController(text: filterCode ?? '');

    List<String> nameSuggestions = [];
    List<String> codeSuggestions = [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            void updateNameSuggestions(String input) {
              if (input.trim().isEmpty) {
                setModalState(() => nameSuggestions = []);
                return;
              }

              final matches = provider.products
                  .map((e) => e.productName)
                  .where((name) =>
                  name.toLowerCase().contains(input.toLowerCase()))
                  .toSet()
                  .toList();

              matches.sort((a, b) =>
              a.toLowerCase().indexOf(input.toLowerCase()) -
                  b.toLowerCase().indexOf(input.toLowerCase()));

              setModalState(() => nameSuggestions = matches);
            }

            void updateCodeSuggestions(String input) {
              if (input.trim().isEmpty) {
                setModalState(() => codeSuggestions = []);
                return;
              }

              final matches = provider.products
                  .map((e) => e.productCode)
                  .where((code) =>
                  code.toLowerCase().contains(input.toLowerCase()))
                  .toSet()
                  .toList();

              matches.sort((a, b) =>
              a.toLowerCase().indexOf(input.toLowerCase()) -
                  b.toLowerCase().indexOf(input.toLowerCase()));

              setModalState(() => codeSuggestions = matches);
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Product Name',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: updateNameSuggestions,
                    ),
                    if (nameSuggestions.isNotEmpty)
                      ...nameSuggestions.map(
                            (name) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                color: AppColors.ghostWhite,
                              ),
                              child: ListTile(
                                dense: true,
                                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                                minVerticalPadding: 0,
                                contentPadding: EdgeInsets.only(left: 8.0,right: 8.0),
                                title: Text(name,style: regularTextStyle(fontSize: dimen13, color: Colors.black),),
                                onTap: () {
                                  nameController.text = name;
                                  setModalState(() => nameSuggestions.clear());
                                  },
                              ),
                            ),
                      ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: codeController,
                      decoration: const InputDecoration(
                        labelText: 'Product Code',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: updateCodeSuggestions,
                    ),
                    if (codeSuggestions.isNotEmpty)
                      ...codeSuggestions.map(
                            (code) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                color: AppColors.ghostWhite,
                              ),
                              child: ListTile(
                                dense: true,
                                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                                minVerticalPadding: 0,
                                contentPadding: EdgeInsets.only(left: 8.0,right: 8.0),
                                title: Text(code,style: regularTextStyle(fontSize: dimen13, color: Colors.black),),

                                onTap: () {
                            codeController.text = code;
                            setModalState(() => codeSuggestions.clear());
                          },
                        ),
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
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                            ),
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
              ),
            );
          },
        );
      },
    );
  }



  // void openFilterBottomSheet(BuildContext context) {
  //   final nameController = TextEditingController(text: filterName ?? '');
  //   final codeController = TextEditingController(text: filterCode ?? '');
  //
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //     ),
  //     builder: (_) {
  //       return Padding(
  //         padding: EdgeInsets.only(
  //           left: 16,
  //           right: 16,
  //           top: 24,
  //           bottom: MediaQuery.of(context).viewInsets.bottom + 24,
  //         ),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             TextField(
  //               controller: nameController,
  //               decoration: const InputDecoration(
  //                 labelText: 'Product Name',
  //                 border: OutlineInputBorder(),
  //               ),
  //             ),
  //             const SizedBox(height: 16),
  //             TextField(
  //               controller: codeController,
  //               decoration: const InputDecoration(
  //                 labelText: 'Product Code',
  //                 border: OutlineInputBorder(),
  //               ),
  //             ),
  //             const SizedBox(height: 24),
  //             Row(
  //               children: [
  //                 Expanded(
  //                   child: ElevatedButton(
  //                     onPressed: () {
  //                       setState(() {
  //                         filterName = nameController.text.trim().isNotEmpty
  //                             ? nameController.text.trim()
  //                             : null;
  //                         filterCode = codeController.text.trim().isNotEmpty
  //                             ? codeController.text.trim()
  //                             : null;
  //                       });
  //                       Navigator.pop(context);
  //                     },
  //                     child: const Text("Apply Filters"),
  //                   ),
  //                 ),
  //                 const SizedBox(width: 12),
  //                 Expanded(
  //                   child: OutlinedButton(
  //                     onPressed: () {
  //                       setState(() {
  //                         filterName = null;
  //                         filterCode = null;
  //                       });
  //                       Navigator.pop(context);
  //                     },
  //                     child: const Text("Clear Filters"),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

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
            return Center(child: Text("Oops! Something went wrong"));
          }

          final filteredProducts = _applyFilters(provider.products);

          return Stack(
            children: [
              Column(
                children: [
                  if (filterName != null || filterCode != null)
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (filterName != null || filterCode != null)
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: [
                                  if (filterName != null)
                                    Chip(
                                      label: Text(
                                        "Name: $filterName",
                                        style: const TextStyle(
                                          color: AppColors.secondary,
                                          fontSize: 12,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 1,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        side: const BorderSide(color: AppColors.secondary,width: 0.7),
                                      ),
                                      backgroundColor: Colors.white,
                                      visualDensity: VisualDensity.compact,
                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  if (filterCode != null)
                                    Chip(
                                      label: Text(
                                        "Code: $filterCode",
                                        style: const TextStyle(
                                          color: AppColors.secondary,
                                          fontSize: 12,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 1,
                                      ),

                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        side: const BorderSide(color: AppColors.secondary,width: 0.7),
                                      ),
                                      backgroundColor: Colors.white,
                                      visualDensity: VisualDensity.compact,
                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                ],
                              ),

                            if (filterName != null || filterCode != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          filterName = null;
                                          filterCode = null;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(4),
                                          color: AppColors.ghostWhite,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical:5,horizontal: 9.0),
                                          child:  Text(
                                            "Clear Filters",
                                            style: regularTextStyle(fontSize: dimen13,color: Colors.black),
                                          ),
                                        ),
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
                  const SizedBox(height: 10),
                ],
              ),
              Positioned(
                bottom: 40,
                right: 20,
                child: FloatingCircularAddButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddProductScreen()));
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
