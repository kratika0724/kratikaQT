import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qt_distributer/providers/product_provider.dart';
import '../../../constants/app_assets.dart';
import '../../../constants/app_colors.dart';
import '../../../widgets/common_form_widgets.dart';
import '../../../widgets/common_text_widgets.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {

  final nameController = TextEditingController();
  final codeController = TextEditingController();
  final amountController = TextEditingController();
  final quarterDiscountController = TextEditingController();
  final halfYearDiscountController = TextEditingController();
  final yearlyDiscountController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    codeController.dispose();
    amountController.dispose();
    quarterDiscountController.dispose();
    halfYearDiscountController.dispose();
    yearlyDiscountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: HeaderTextBlack("Add new product"),
        elevation: 0,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 6),
                              child: Column(
                                children: [
                                  _buildProductImage(),
                                  const SizedBox(height: 60,),
                                  buildProductTextField('Product Name', controller: nameController),
                                  buildProductTextField('Product Code', controller: codeController),
                                  buildProductTextField('Product Amount', controller: amountController),
                                  buildProductTextField('Quarter Discount', controller: quarterDiscountController),
                                  buildProductTextField('Half-year Discount', controller: halfYearDiscountController),
                                  buildProductTextField('Yearly Discount', controller: yearlyDiscountController),

                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        FormActionButtons(
                          onSubmit: () {
                            provider.createProduct(
                                context,
                                nameController,
                                codeController,
                                amountController,
                                quarterDiscountController,
                                halfYearDiscountController,
                                yearlyDiscountController
                            );

                          },
                          onCancel: () {
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  Widget _buildProductImage() {
    return ColorFiltered(
      colorFilter: const ColorFilter.mode(
        AppColors.secondary, // Or any color
        BlendMode.srcIn,
      ),
      child: Image.asset(
        AppAssets.sampleProduct,
        width: 120,
        height: 120,
      ),
    );
  }
}

