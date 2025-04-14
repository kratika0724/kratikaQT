import 'package:flutter/material.dart';
import 'package:qt_distributer/constants/app_colors.dart';
import 'package:qt_distributer/widgets/common_text_widgets.dart';
import '../../widgets/add_new_button.dart';
import '../customer/add_customer_screen.dart';
import '../customer/customer_card_list.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: HeaderTextThemeSecondary("Customers"),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 3,
      ),
      body: SafeArea(
        child: Column(
          children: [
            //List
            Expanded(child: CustomerList()),
            // Divider(thickness: 1, color: Colors.grey.shade200),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AddNewButton(
                    label: 'Add New Customer',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddCustomerScreen()),
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

