import 'package:flutter/material.dart';
import 'package:qt_distributer/constants/app_colors.dart';
import 'package:qt_distributer/widgets/common_text_widgets.dart';
import '../../widgets/common_form_widgets.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  String? selectedGender;
  String? selectedAgent;

  final agents = ['Agent A', 'Agent B', 'Agent C'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: HeaderTextThemeSecondary("Add Customer"),
        foregroundColor: AppColors.textSecondary,
        elevation: 3,
      ),
      body: SafeArea(
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
                                buildTextField('First Name'),
                                buildTextField('Middle Name (Optional)'),
                                buildTextField('Last Name'),
                                buildTextField('Email'),
                                buildCalenderTextField(context,'Date of Birth', hint: 'dd/mm/yyyy'),
                                buildGenderSelector(
                                  selectedGender: selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value;
                                    });
                                  },
                                ),
                                buildDropdown('Select Agent', selectedAgent, agents,
                                        (value) {
                                      setState(() {
                                        selectedAgent = value;
                                      });
                                    }),
                                buildTextField('Address'),
                                buildTextField('Pincode'),
                                buildTextField('State'),
                                buildTextField('City'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FormActionButtons(
                        onSubmit: () {
                          Navigator.pop(context);
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
    );
  }
}
