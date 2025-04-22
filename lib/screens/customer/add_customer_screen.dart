import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qt_distributer/constants/app_colors.dart';
import 'package:qt_distributer/widgets/common_text_widgets.dart';
import '../../providers/customer_provider.dart';
import '../../widgets/common_form_widgets.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  // Text controllers
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final cityController = TextEditingController();
  final pincodeController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: HeaderTextThemeSecondary("Add Customer"),
        foregroundColor: AppColors.textSecondary,
        elevation: 3,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap:() {
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
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                              child: Column(
                                children: [
                                  buildTextField('Name',controller: nameController),
                                  buildTextField('Mobile',controller: mobileController),
                                  buildTextField('Email',controller: emailController),
                                  buildTextField('City', controller: cityController),
                                  buildTextField('Pincode', controller: pincodeController),
                                  buildTextField('State', controller: stateController),
                                  buildTextField('Country', controller: countryController),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        FormActionButtons(
                          onSubmit: () {
                            provider.createCustomer(
                                context,
                                nameController,
                                mobileController,
                                emailController,
                                cityController,
                                pincodeController,
                                stateController,
                                countryController,
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
}
