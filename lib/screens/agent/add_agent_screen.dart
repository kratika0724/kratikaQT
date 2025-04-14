import 'package:flutter/material.dart';
import 'package:qt_distributer/widgets/common_text_widgets.dart';
import '../../constants/app_colors.dart';
import '../../widgets/common_form_widgets.dart';

class AddAgentScreen extends StatefulWidget {
  const AddAgentScreen({super.key});

  @override
  State<AddAgentScreen> createState() => _AddAgentScreenState();
}

class _AddAgentScreenState extends State<AddAgentScreen> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: AppColors.secondary,
        title: HeaderTextThemeSecondary("Register Agent"),
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
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                            child: Column(
                              children: [
                                buildTextField('First Name'),
                                buildTextField('Middle Name (Optional)'),
                                buildTextField('Last Name'),
                                buildTextField('Email'),
                                buildTextField('Mobile No'),
                                buildTextField('CRM ID'),
                                buildCalenderTextField(context, 'Date of Birth', hint: 'dd/mm/yyyy'),
                                buildTextField('Address'),
                                buildTextField('Pincode'),
                                buildTextField('State'),
                                buildGenderSelector(
                                  selectedGender: selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value;
                                    });
                                  },
                                ),
                                buildDropdown(
                                  'Select Services',
                                  null,
                                  ['Loan Recovery', 'Payment Collection'],
                                      (_) {},
                                ),
                                buildTextField('Assigned Pincode'),
                                buildTextField('Assigned Area'),
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

      // body: Column(
      //   children: [
      //     Expanded(
      //       child: SingleChildScrollView(
      //         padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
      //         child: Card(
      //           elevation: 4,
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(12),
      //           ),
      //           child: Padding(
      //             padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      //             child: Column(
      //               children: [
      //                 buildTextField('First Name'),
      //                 buildTextField('Middle Name (Optional)'),
      //                 buildTextField('Last Name'),
      //                 buildTextField('Email'),
      //                 buildTextField('Mobile No'),
      //                 buildTextField('CRM ID'),
      //                 buildCalenderTextField(context,'Date of Birth', hint: 'dd/mm/yyyy'),
      //                 buildTextField('Address'),
      //                 buildTextField('Pincode'),
      //                 buildTextField('State'),
      //                 buildGenderSelector(
      //                   selectedGender: selectedGender,
      //                   onChanged: (value) {
      //                     setState(() {
      //                       selectedGender = value;
      //                     });
      //                   },
      //                 ),
      //                 buildDropdown(
      //                   'Select Services',
      //                   null,
      //                   ['Loan Recovery', 'Payment Collection'],
      //                       (_) {},
      //                 ),
      //                 buildTextField('Assigned Pincode'),
      //                 buildTextField('Assigned Area'),
      //                 buildTextField('City'),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      //       child: FormActionButtons(
      //         onSubmit: () {
      //           Navigator.pop(context);
      //         },
      //         onCancel: () {
      //           Navigator.pop(context);
      //         },
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
