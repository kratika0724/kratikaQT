import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qt_distributer/screens/products/product_card.dart';
import 'package:qt_distributer/screens/products/product_filter_bottom_sheet.dart';
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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Use WidgetsBinding to ensure the context is available after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      provider.currentPage_product = 1;
      provider.getProductData();

      _scrollController.addListener(() {
        if (_scrollController.position.extentAfter < 300 &&
            !provider.isFetchingMore &&
            provider.hasMoreData) {
          provider.getProductData(loadMore: true);
        }
      });
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
        preferredSize: const Size.fromHeight(90),
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
                        onTap: _openFilterBottomSheet,
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
          if (provider.isLoading && provider.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null && provider.products.isEmpty) {
            return const Center(child: Text("Oops! Something went wrong"));
          }

          final filteredProducts = provider.products.where((product) {
            final matchesName = filterName == null || product.productName?.contains(filterName!) == true;
            final matchesCode = filterCode == null || product.productCode?.toLowerCase().contains(filterCode!.toLowerCase()) == true;
            return matchesName && matchesCode;
          }).toList();

          if (filteredProducts.isEmpty) {
            return const Center(child: Text("No matching products found."));
          }

          final isWide = DeviceUtils.getDeviceWidth(context);
          final scrollableList = isWide
              ? GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: filteredProducts.length + 1,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 100,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              if (index == filteredProducts.length) {
                final isFiltering = filterName != null || filterCode != null;
                if (!isFiltering && provider.hasMoreData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return const SizedBox.shrink();
                }
              }
              return ProductCard(product: filteredProducts[index]);
            },
          )
              : ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.only(top: 10),
            itemCount: filteredProducts.length + 1,
            itemBuilder: (context, index) {
              if (index == filteredProducts.length) {
                final isFiltering = filterName != null || filterCode != null;
                if (!isFiltering && provider.hasMoreData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return const SizedBox.shrink();
                }
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ProductCard(product: filteredProducts[index]),
              );
            },
          );

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
              Expanded(child: scrollableList),
            ],
          );
        },
      ),
    );
  }
}


// class _ProductScreenState extends State<ProductScreen> {
//   String? filterName;
//   String? filterCode;
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     // Future.microtask(() {
//     //   Provider.of<ProductProvider>(context, listen: false).getProductData(loadMore: true);
//     // });
//     final provider = Provider.of<ProductProvider>(context, listen: false);
//     provider.currentPage_product = 1;
//     provider.getProductData();
//     _scrollController.addListener(() {
//       if (_scrollController.position.extentAfter < 300 &&
//           !provider.isFetchingMore &&
//           provider.hasMoreData) {
//         provider.getProductData(loadMore: true);
//       }
//     });
//
//   }
//
//   void _openFilterBottomSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (_) => ProductFilterBottomSheet(
//         initialName: filterName,
//         initialCode: filterCode,
//         onApply: (productName, productCode) {
//           setState(() {
//             filterName = productName;
//             filterCode = productCode;
//           });
//         },
//         onClear: () {
//           setState(() {
//             filterName = null;
//             filterCode = null;
//           });
//         },
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.ghostWhite,
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(90), // 👈 Increase height
//         child: AppBar(
//           backgroundColor: Colors.white,
//           foregroundColor: Colors.black,
//           elevation: 0,
//           title: HeaderTextBlack("Products"),
//           automaticallyImplyLeading: true,
//           flexibleSpace: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   const SizedBox(height: 40),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (_) => const AddProductScreen()),
//                           );
//                         },
//                         child: Container(
//                           height: 30,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(9),
//                             color: AppColors.primary.withOpacity(0.1),
//                             border: Border.all(color: AppColors.secondary),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "Add Products ",
//                                   overflow: TextOverflow.ellipsis,
//                                   maxLines: 1,
//                                   style: mediumTextStyle(fontSize: dimen13, color: Colors.black),
//                                 ),
//                                 const Icon(Icons.add, size: 16, color: Colors.black),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       GestureDetector(
//                         onTap: () => _openFilterBottomSheet(),
//                         child: Container(
//                           height: 30,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(9),
//                             color: AppColors.primary.withOpacity(0.1),
//                             border: Border.all(color: AppColors.secondary),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "Filter ",
//                                   overflow: TextOverflow.ellipsis,
//                                   maxLines: 1,
//                                   style: mediumTextStyle(fontSize: dimen13, color: Colors.black),
//                                 ),
//                                 const Icon(Icons.filter_list, size: 16, color: Colors.black),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//
//       body: Consumer<ProductProvider>(
//         builder: (context, provider, _) {
//           if (provider.isLoading && provider.products.isEmpty) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (provider.errorMessage != null && provider.products.isEmpty) {
//             return const Center(child: Text("Oops! Something went wrong"));
//           }
//
//           final filteredProducts = provider.products.where((product) {
//             final matchesName = filterName == null || product.productName?.contains(filterName!) == true;
//             final matchesCode = filterCode == null || product.productCode?.toLowerCase().contains(filterCode!.toLowerCase()) == true;
//             return matchesName && matchesCode;
//           }).toList();
//
//           if (filteredProducts.isEmpty) {
//             return const Center(child: Text("No matching products found."));
//           }
//
//           final isWide = DeviceUtils.getDeviceWidth(context);
//           final scrollableList = isWide
//               ? GridView.builder(
//             controller: _scrollController,
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             itemCount: filteredProducts.length + 1, // +1 for loader
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               mainAxisExtent: 100,
//               crossAxisSpacing: 12,
//               mainAxisSpacing: 12,
//             ),
//             itemBuilder: (context, index) {
//               if (index == filteredProducts.length) {
//                 return provider.hasMoreData
//                     ? const Center(child: CircularProgressIndicator())
//                     : const SizedBox.shrink();
//               }
//               return ProductCard(product: filteredProducts[index]);
//             },
//           )
//               : ListView.builder(
//             controller: _scrollController,
//             padding: const EdgeInsets.only(top: 10),
//             itemCount: filteredProducts.length + 1,
//             itemBuilder: (context, index) {
//               if (index == filteredProducts.length) {
//                 return provider.hasMoreData
//                     ? const Center(child: CircularProgressIndicator())
//                     : const SizedBox.shrink();
//               }
//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                 child: ProductCard(product: filteredProducts[index]),
//               );
//             },
//           );
//
//           return Column(
//             children: [
//               if (filterName != null || filterCode != null)
//                 FilterChipsWidget(
//                   filters: {
//                     'Name': filterName,
//                     'Code': filterCode,
//                   },
//                   onClear: () => setState(() {
//                     filterCode = null;
//                     filterName = null;
//                   }),
//                 ),
//               Expanded(child: scrollableList),
//             ],
//           );
//         },
//       ),
//
//     );
//   }
// }
