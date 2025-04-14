import 'package:flutter/material.dart';
import 'package:qt_distributer/screens/products/product_list.dart';
import 'package:qt_distributer/widgets/common_text_widgets.dart';
import '../../constants/app_colors.dart';
import '../../widgets/add_new_button.dart';
import '../payments/payment_card_list.dart';
import 'add_product_screen.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: HeaderTextThemeSecondary("Products"),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 3,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // List of payment cards
            Expanded(
              child: ProductList(),
            ),
            SizedBox(height: 10,),
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
            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}