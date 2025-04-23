import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qt_distributer/constants/app_colors.dart';
import 'package:qt_distributer/widgets/common_text_widgets.dart';
import '../../constants/app_textstyles.dart';
import '../../providers/agent_provider.dart';
import '../../providers/customer_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/allocation_provider.dart'; // import AllocationProvider
import '../../widgets/common_form_widgets.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  bool agentFetchCompleted = false;


  String? selectedGender;
  DateTime? selectedDOB;


  String? selectedProduct;
  String? selectedPincode;
  String? selectedArea;
  String? selectedAgent;

  String? selectedAgentId;
  String? selectedProductId;


  // Text controllers
  final firstnameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();

  final productController = TextEditingController();
  final pinCodeController = TextEditingController();
  final areaController = TextEditingController();
  final agentController = TextEditingController();

  // Add these focus nodes for pincode and area fields
  final productFocusNode = FocusNode();
  final pinCodeFocusNode = FocusNode();
  final areaFocusNode = FocusNode();
  final agentFocusNode = FocusNode();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).getProductData(); // ✅ also safe
      Provider.of<AllocationProvider>(context, listen: false).getAllocationData(); // ✅ also safe
    });

    pinCodeController.addListener(() {
      setState(() {});
    });

    areaController.addListener(() {
      setState(() {});
    });

    productController.addListener(() {
      setState(() {});
    });

    agentController.addListener(() {
      setState(() {});
    });

  }

  @override
  void dispose() {

    pinCodeFocusNode.dispose();
    areaFocusNode.dispose();
    productFocusNode.dispose();
    agentFocusNode.dispose();

    pinCodeController.dispose();
    areaController.dispose();
    productController.dispose();
    agentController.dispose();

    firstnameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    mobileController.dispose();
    emailController.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final allocationProvider = Provider.of<AllocationProvider>(context);

    final productList = productProvider.getProductNames();

    final pincodeList = allocationProvider.getPincodeList();

    List<String> areaList = selectedPincode != null
        ? allocationProvider.getAreaList(selectedPincode!)
        : [];


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: HeaderTextThemeSecondary("Add Customer"),
        foregroundColor: AppColors.textSecondary,
        elevation: 3,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
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
                              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                              child: Column(
                                children: [
                                  buildTextField('First Name', controller: firstnameController),
                                  buildTextField('Middle Name (Optional)', controller: middleNameController),
                                  buildTextField('Last Name', controller: lastNameController),
                                  buildTextField('Mobile', controller: mobileController),
                                  buildTextField('Email', controller: emailController),
                                  buildCalendarTextField(
                                    context,
                                    'Date of Birth',
                                    hint: 'dd/mm/yyyy',
                                    selectedDate: selectedDOB, // ✅ Maintain state
                                    onDateSelected: (date) {
                                      setState(() {
                                        selectedDOB = date;
                                      });
                                    },
                                  ),

                                  const SizedBox(height: 16,),
                                  buildGenderSelector(
                                    selectedGender: selectedGender,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedGender = value;
                                      });
                                    },
                                  ),
                                  buildTypableDropdown(
                                    labelText: 'Select Product',
                                    controller: productController,
                                    focusNode: productFocusNode,
                                    options: productList,
                                    // onSelected: (value) {
                                    //   setState(() {
                                    //     selectedProduct = value;
                                    //     productController.text = value ?? '';
                                    //   });
                                    // },
                                    onSelected: (value) {
                                      setState(() {
                                        selectedProduct = value;
                                        productController.text = value ?? '';

                                        // Find and store the corresponding productId
                                        final matchedProduct = productProvider.products.firstWhere(
                                              (p) => p.productName == value,
                                        );

                                        selectedProductId = matchedProduct?.id?.toString(); // Assuming productId is int or String
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  buildTextField('Address'),
                                  buildTextField('State', controller: stateController),

                                  buildTypableDropdown(
                                    labelText: 'Select Pincode',
                                    controller: pinCodeController,
                                    focusNode: pinCodeFocusNode,
                                    options: pincodeList,
                                    onSelected: (value) {
                                      setState(() {
                                        selectedPincode = value;
                                        selectedArea = null;
                                        pinCodeController.text = value ?? '';
                                        areaController.clear();
                                      });
                                    }, // Add controller here
                                  ),
                                  const SizedBox(height: 16),
                                  buildTypableDropdown(
                                    labelText: 'Select Area',
                                    controller: areaController,
                                    focusNode: areaFocusNode,
                                    options: areaList,
                                    // onSelected: (value) async {
                                    //   setState(() {
                                    //     selectedArea = value;
                                    //     areaController.text = value ?? '';
                                    //     agentController.clear();
                                    //     selectedAgentId = null;
                                    //   });
                                    //
                                    //   if (value != null) {
                                    //     await Provider.of<AgentProvider>(context, listen: false).getAgentDataByArea(value);
                                    //   }
                                    // },

                                    onSelected: (value) async {
                                      setState(() {
                                        selectedArea = value;
                                        areaController.text = value ?? '';
                                        agentController.clear();
                                        selectedAgentId = null;
                                        agentFetchCompleted = false; // Reset before fetching
                                      });

                                      if (value != null) {
                                        await Provider.of<AgentProvider>(context, listen: false).getAgentDataByArea(value);
                                        setState(() {
                                          agentFetchCompleted = true; // Set true after fetch
                                        });
                                      }
                                    },

                                  ),

                                  const SizedBox(height: 16),

                                  Consumer<AgentProvider>(
                                    builder: (context, agentProvider, _) {
                                      final agentList = agentProvider.getAgentNamesByArea();

                                      // After area selection and API call, if no agents found => disable
                                      if (agentFetchCompleted && agentList.isEmpty) {
                                        return TextField(
                                          controller: agentController,
                                          focusNode: agentFocusNode,
                                          enabled: false,
                                          style: regularTextStyle(fontSize: dimen14, color: Colors.black),
                                          decoration: InputDecoration(
                                            // labelText: 'Select Agent',
                                            // labelStyle: regularTextStyle(fontSize: dimen13, color: Colors.black54),
                                            // floatingLabelStyle: regularTextStyle(fontSize: dimen16, color: AppColors.textSecondary),
                                            filled: true,
                                            fillColor: AppColors.ghostWhite,
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                            hintText: 'No agents available',
                                          ),
                                        );
                                      }

                                      // Show regular dropdown when agents are available or before area is selected
                                      return buildTypableDropdown(
                                        labelText: 'Select Agent',
                                        controller: agentController,
                                        focusNode: agentFocusNode,
                                        options: agentList,
                                        onSelected: (value) {
                                          setState(() {
                                            selectedAgent = value;
                                            agentController.text = value ?? '';

                                            final matchedAgent = agentProvider.agentsbyArea.firstWhere(
                                                  (a) => a.firstName == value,
                                            );

                                            selectedAgentId = matchedAgent.id?.toString();
                                          });
                                        },
                                      );
                                    },
                                  ),

                                  // Consumer<AgentProvider>(
                                  //   builder: (context, agentProvider, _) {
                                  //     final agentList = agentProvider.getAgentNamesByArea();
                                  //     return buildTypableDropdown(
                                  //       labelText: 'Select Agent',
                                  //       controller: agentController,
                                  //       focusNode: agentFocusNode,
                                  //       options: agentList,
                                  //       onSelected: (value) {
                                  //         setState(() {
                                  //           selectedAgent = value;
                                  //           agentController.text = value ?? '';
                                  //
                                  //           final matchedAgent = agentProvider.agentsbyArea.firstWhere(
                                  //                 (a) => a.firstName == value,
                                  //           );
                                  //
                                  //           selectedAgentId = matchedAgent.id?.toString();
                                  //         });
                                  //       },
                                  //     );
                                  //   },
                                  // ),

                                  const SizedBox(height: 16),

                                  buildTextField('City', controller: cityController),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        FormActionButtons(
                            onSubmit: () {
                              customerProvider.createCustomer(
                                context,
                                firstnameController,
                                middleNameController,
                                lastNameController,
                                mobileController,
                                emailController,
                                cityController,
                                pinCodeController,
                                stateController,
                                countryController,
                                gender: selectedGender,
                                productId: selectedProductId,
                                area: selectedArea,
                                agentId: selectedAgentId,
                                dob: selectedDOB,
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

  Widget buildTypableDropdown({
    required String labelText,
    required TextEditingController controller,
    required FocusNode focusNode,
    required List<String> options,
    required void Function(String?) onSelected,
  }) {
    focusNode.addListener(() {
      if (focusNode.hasFocus && controller.text.isEmpty) {
        // Trigger dropdown open with a dummy space and clear it safely later
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (controller.text.isEmpty) {
            controller.text = ' ';
            Future.delayed(Duration(milliseconds: 100), () {
              controller.clear();
            });
          }
        });
      }
    });

    return RawAutocomplete<String>(
      textEditingController: controller,
      focusNode: focusNode,
      optionsBuilder: (TextEditingValue textEditingValue) {
        return options
            .where((option) => option.toLowerCase().contains(textEditingValue.text.toLowerCase()))
            .toList();
      },
      onSelected: onSelected,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          style: regularTextStyle(fontSize: dimen14, color: Colors.black),
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.arrow_drop_down),
            labelText: labelText,
            labelStyle: regularTextStyle(fontSize: dimen13, color: Colors.black54),
            floatingLabelStyle: regularTextStyle(fontSize: dimen16, color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.ghostWhite,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        final itemHeight = 48.0; // Approximate height for each ListTile
        final containerHeight = (options.length * itemHeight).clamp(0.0, 200.0);

        // Check if no options are available
        if (options.isEmpty) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4,
              child: Container(
                height: 200,
                color: Colors.white,
                child: Center(
                  child: Text(
                    'No agents available',
                    style: regularTextStyle(fontSize: dimen14, color: Colors.black54),
                  ),
                ),
              ),
            ),
          );
        }

        // If options are available, show the list as usual
        return Align(
          alignment: Alignment.topCenter,
          child: Material(
            elevation: 4,
            child: Container(
              width: 310,
              height: containerHeight,
              color: Colors.white,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final option = options.toList()[index]; // Use options directly, no need to convert to list
                  return ListTile(
                    title: Text(option),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }



}

//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:qt_distributer/constants/app_colors.dart';
// import 'package:qt_distributer/widgets/common_text_widgets.dart';
// import '../../constants/app_textstyles.dart';
// import '../../providers/agent_provider.dart';
// import '../../providers/customer_provider.dart';
// import '../../providers/product_provider.dart';
// import '../../providers/allocation_provider.dart'; // import AllocationProvider
// import '../../widgets/common_form_widgets.dart';
//
// class AddCustomerScreen extends StatefulWidget {
//   const AddCustomerScreen({super.key});
//
//   @override
//   State<AddCustomerScreen> createState() => _AddCustomerScreenState();
// }
//
// class _AddCustomerScreenState extends State<AddCustomerScreen> {
//   String? selectedGender;
//   String? selectedProduct;
//   String? selectedAgent;
//   String? selectedPincode;
//   String? selectedArea;
//
//   // Text controllers
//   final firstnameController = TextEditingController();
//   final mobileController = TextEditingController();
//   final emailController = TextEditingController();
//   final cityController = TextEditingController();
//   final stateController = TextEditingController();
//   final countryController = TextEditingController();
//   final pinCodeController = TextEditingController();
//   final areaController = TextEditingController();
//   final productController = TextEditingController();
//   final productFocusNode = FocusNode();
//
//
//
//   // Add these focus nodes for pincode and area fields
//   final pinCodeFocusNode = FocusNode();
//   final areaFocusNode = FocusNode();
//
//
//   @override
//   void initState() {
//     super.initState();
//       Future.microtask(() {
//         Provider.of<ProductProvider>(context, listen: false).getProductData(); // ✅ also safe
//         Provider.of<AllocationProvider>(context, listen: false).getAllocationData(); // ✅ also safe
//       });
//
//   }
//
//   @override
//   void dispose() {
//     pinCodeFocusNode.dispose();
//     areaFocusNode.dispose();
//     productFocusNode.dispose();
//     productController.dispose();
//     super.dispose();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final customerProvider = Provider.of<CustomerProvider>(context);
//     final productProvider = Provider.of<ProductProvider>(context);
//     final allocationProvider = Provider.of<AllocationProvider>(context);
//
//
//
//     final productList = productProvider.products
//         .where((p) => p.productName != null && p.productName!.trim().isNotEmpty)
//         .map((p) => p.productName!)
//         .toList();
//
//     final pincodeList = allocationProvider.allocations
//         .map((a) => a.allocationPincode)
//         .whereType<String>()
//         .toSet()
//         .toList();
//
//     final areaList = allocationProvider.allocations
//         .where((a) => a.allocationPincode == selectedPincode)
//         .map((a) => a.allocationArea)
//         .whereType<String>()
//         .toSet()
//         .toList();
//
//
// // Typable Pincode Dropdown
//     Widget buildTypablePincodeDropdown({
//       required String? selectedValue,
//       required List<String> options,
//       required void Function(String?) onSelected,
//     }) {
//       return RawAutocomplete<String>(
//         textEditingController: pinCodeController,
//         focusNode: pinCodeFocusNode,  // Pass focusNode here
//         optionsBuilder: (TextEditingValue textEditingValue) {
//           return options
//               .where((option) => option.toLowerCase().contains(textEditingValue.text.toLowerCase()))
//               .toList();
//         },
//         onSelected: onSelected,
//         fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
//           return TextField(
//             controller: controller,
//             focusNode: focusNode,  // Make sure the focusNode is passed here too
//             decoration: const InputDecoration(
//               labelText: 'Select Pincode',
//               border: OutlineInputBorder(),
//             ),
//             keyboardType: TextInputType.number,
//             maxLength: 6,
//           );
//         },
//         optionsViewBuilder: (context, onSelected, options) {
//           return Align(
//             alignment: Alignment.topLeft,
//             child: Material(
//               elevation: 4,
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 shrinkWrap: true,
//                 itemCount: options.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   final option = options.elementAt(index);
//                   return ListTile(
//                     title: Text(option),
//                     onTap: () => onSelected(option),
//                   );
//                 },
//               ),
//             ),
//           );
//         },
//       );
//     }
//
// // Typable Area Dropdown
//     Widget buildTypableAreaDropdown({
//       required String? selectedValue,
//       required List<String> options,
//       required void Function(String?) onSelected,
//     }) {
//       return RawAutocomplete<String>(
//         textEditingController: areaController,
//         focusNode: areaFocusNode,  // Pass focusNode here
//         optionsBuilder: (TextEditingValue textEditingValue) {
//           return options
//               .where((option) => option.toLowerCase().contains(textEditingValue.text.toLowerCase()))
//               .toList();
//         },
//         onSelected: onSelected,
//         fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
//           return TextField(
//             controller: controller,
//             focusNode: focusNode,  // Make sure the focusNode is passed here too
//             decoration: const InputDecoration(
//               labelText: 'Select Area',
//               border: OutlineInputBorder(),
//             ),
//           );
//         },
//         optionsViewBuilder: (context, onSelected, options) {
//           return Align(
//             alignment: Alignment.topLeft,
//             child: Material(
//               elevation: 4,
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 shrinkWrap: true,
//                 itemCount: options.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   final option = options.elementAt(index);
//                   return ListTile(
//                     title: Text(option),
//                     onTap: () => onSelected(option),
//                   );
//                 },
//               ),
//             ),
//           );
//         },
//       );
//     }
//
//
//     Widget buildTypableProductDropdown({
//       required String? selectedValue,
//       required List<String> options,
//       required void Function(String?) onSelected,
//     }) {
//       return RawAutocomplete<String>(
//         textEditingController: productController,
//         focusNode: productFocusNode,
//         optionsBuilder: (TextEditingValue textEditingValue) {
//           return options
//               .where((option) => option.toLowerCase().contains(textEditingValue.text.toLowerCase()))
//               .toList();
//         },
//         onSelected: onSelected,
//         fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
//           return TextField(
//             controller: controller,
//             focusNode: focusNode,
//             decoration: const InputDecoration(
//               labelText: 'Select Product',
//               border: OutlineInputBorder(),
//             ),
//           );
//         },
//         optionsViewBuilder: (context, onSelected, options) {
//           return Align(
//             alignment: Alignment.topLeft,
//             child: Material(
//               elevation: 4,
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 shrinkWrap: true,
//                 itemCount: options.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   final option = options.elementAt(index);
//                   return ListTile(
//                     title: Text(option),
//                     onTap: () => onSelected(option),
//                   );
//                 },
//               ),
//             ),
//           );
//         },
//       );
//     }
//
//
//
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: HeaderTextThemeSecondary("Add Customer"),
//         foregroundColor: AppColors.textSecondary,
//         elevation: 3,
//       ),
//       body: SafeArea(
//         child: GestureDetector(
//           onTap: () => FocusScope.of(context).unfocus(),
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               return SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(minHeight: constraints.maxHeight),
//                   child: IntrinsicHeight(
//                     child: Column(
//                       children: [
//                         Expanded(
//                           child: Card(
//                             elevation: 4,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
//                               child: Column(
//                                 children: [
//                                   buildTextField('First Name', controller: firstnameController),
//                                   buildTextField('Middle Name (Optional)'),
//                                   buildTextField('Last Name'),
//                                   buildTextField('Mobile', controller: mobileController),
//                                   buildTextField('Email', controller: emailController),
//                                   buildCalenderTextField(context, 'Date of Birth', hint: 'dd/mm/yyyy'),
//                                   buildGenderSelector(
//                                     selectedGender: selectedGender,
//                                     onChanged: (value) {
//                                       setState(() {
//                                         selectedGender = value;
//                                       });
//                                     },
//                                   ),
//                                   // buildDropdown(
//                                   //   'Select Product',
//                                   //   selectedProduct,
//                                   //   productList,
//                                   //       (value) {
//                                   //     setState(() {
//                                   //       selectedProduct = value;
//                                   //     });
//                                   //   },
//                                   // ),
//                                   buildTypableProductDropdown(
//                                     selectedValue: selectedProduct,
//                                     options: productList,
//                                     onSelected: (value) {
//                                       setState(() {
//                                         selectedProduct = value;
//                                         productController.text = value ?? '';
//                                       });
//                                     },
//                                   ),
//
//                                   buildTextField('Address'),
//                                   buildTextField('State', controller: stateController),
//
//                                   // Replace pincode dropdown
//                                   buildTypablePincodeDropdown(
//                                     selectedValue: selectedPincode,
//                                     options: pincodeList,
//                                     onSelected: (value) {
//                                       setState(() {
//                                         selectedPincode = value;
//                                         pinCodeController.text = value ?? '';
//                                         selectedArea = null;
//                                       });
//                                     },
//                                   ),
//
// // Replace area dropdown
//                                   buildTypableAreaDropdown(
//                                     selectedValue: selectedArea,
//                                     options: areaList,
//                                     onSelected: (value) async {
//                                       setState(() {
//                                         selectedArea = value;
//                                         areaController.text = value ?? '';
//                                         selectedAgent = null;
//                                       });
//
//                                       if (value != null) {
//                                         await Provider.of<AgentProvider>(context, listen: false)
//                                             .getAgentDataByArea(value);
//                                       }
//                                     },
//                                   ),
//
//
//                                   // // ✅ Select Pincode
//                                   // buildDropdown(
//                                   //   'Select Pincode',
//                                   //   selectedPincode,
//                                   //   pincodeList,
//                                   //       (value) {
//                                   //     setState(() {
//                                   //       selectedPincode = value;
//                                   //       selectedArea = null; // reset area when pincode changes
//                                   //     });
//                                   //   },
//                                   // ),
//                                   //
//                                   // // ✅ Select Area (filtered by selectedPincode)
//                                   // // buildDropdown(
//                                   // //   'Select Area',
//                                   // //   selectedArea,
//                                   // //   areaList,
//                                   // //       (value) {
//                                   // //     setState(() {
//                                   // //       selectedArea = value;
//                                   // //     });
//                                   // //   },
//                                   // // ),
//                                   // buildDropdown(
//                                   //   'Select Area',
//                                   //   selectedArea,
//                                   //   areaList,
//                                   //       (value) async {
//                                   //     setState(() {
//                                   //       selectedArea = value;
//                                   //       selectedAgent = null; // Reset selected agent
//                                   //     });
//                                   //
//                                   //     if (value != null) {
//                                   //       await Provider.of<AgentProvider>(context, listen: false)
//                                   //           .getAgentDataByArea(value);
//                                   //       debugPrint(value);
//                                   //     }
//                                   //   },
//                                   // ),
//
//                                   buildDropdown('Select Agent', selectedAgent, ['Agent A', 'Agent B', 'Agent C'],
//                                           (value) {
//                                         setState(() {
//                                           selectedAgent = value;
//                                         });
//                                       }),
//
//                                   buildTextField('City', controller: cityController),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         FormActionButtons(
//                           onSubmit: () {
//                             customerProvider.createCustomer(
//                               context,
//                               firstnameController,
//                               mobileController,
//                               emailController,
//                               cityController,
//                               pinCodeController,
//                               stateController,
//                               countryController,
//                             );
//                           },
//                           onCancel: () {
//                             Navigator.pop(context);
//                           },
//                         ),
//                         const SizedBox(height: 20),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
