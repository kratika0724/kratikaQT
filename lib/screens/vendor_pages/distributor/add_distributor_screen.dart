import 'package:flutter/material.dart';
import '../../../constants/app_textstyles.dart';
import '../../../widgets/common_text_widgets.dart';
import '../../../widgets/common_form_widgets.dart';

class AddDistributorScreen extends StatefulWidget {
  const AddDistributorScreen({super.key});

  @override
  State<AddDistributorScreen> createState() => _AddDistributorScreenState();
}

class _AddDistributorScreenState extends State<AddDistributorScreen> {
  String? selectedGender;
  DateTime? selectedDOB;

  String? selectedAssignedPinCode;
  String? selectedAssignedArea;

  final firstnameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final pinCodeController = TextEditingController();
  final assignedPinCodeController = TextEditingController();
  final assignedAreaController = TextEditingController();

  final assignedPinCodeFocusNode = FocusNode();
  final assignedAreaFocusNode = FocusNode();

  final List<String> pincodeList = ['123456', '654321', '789012'];
  final List<String> areaList = ['Area 1', 'Area 2', 'Area 3'];

  @override
  void dispose() {
    assignedPinCodeFocusNode.dispose();
    assignedAreaFocusNode.dispose();

    assignedPinCodeController.dispose();
    assignedAreaController.dispose();
    pinCodeController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    emailController.dispose();
    mobileController.dispose();
    firstnameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: HeaderTextBlack("Register Distributor"),
        elevation: 0,
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
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 0),
                              child: Column(
                                children: [
                                  buildTextField('First Name', controller: firstnameController),
                                  buildTextField('Middle Name (Optional)', controller: middleNameController),
                                  buildTextField('Last Name', controller: lastNameController),
                                  buildTextField('Email', controller: emailController),
                                  buildTextField('Mobile No', controller: mobileController),
                                  buildCalendarTextField(
                                    context,
                                    'Date of Birth',
                                    hint: 'dd/mm/yyyy',
                                    selectedDate: selectedDOB,
                                    onDateSelected: (date) {
                                      setState(() {
                                        selectedDOB = date;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  buildTextField('Address', controller: addressController),
                                  buildTextField('Pincode', controller: pinCodeController),
                                  buildTextField('City', controller: cityController),
                                  buildTextField('State', controller: stateController),
                                  buildGenderSelector(
                                    selectedGender: selectedGender,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedGender = value;
                                      });
                                    },
                                  ),
                                  buildTypableDropdown(
                                    labelText: 'Assigned Pincode',
                                    controller: assignedPinCodeController,
                                    focusNode: assignedPinCodeFocusNode,
                                    options: pincodeList,
                                    onSelected: (value) {
                                      setState(() {
                                        selectedAssignedPinCode = value;
                                        selectedAssignedArea = null;
                                        pinCodeController.text = value ?? '';
                                        assignedAreaController.clear();
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  buildTypableDropdown(
                                    labelText: 'Assigned Area',
                                    controller: assignedAreaController,
                                    focusNode: assignedAreaFocusNode,
                                    options: areaList,
                                    onSelected: (value) {
                                      setState(() {
                                        selectedAssignedArea = value;
                                        assignedAreaController.text = value ?? '';
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ),
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: FormActionButtons(
            onSubmit: () {
              // No backend logic here
            },
            onCancel: () => Navigator.pop(context),
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
            .where((option) => option
            .toLowerCase()
            .contains(textEditingValue.text.toLowerCase()))
            .toList();
      },
      onSelected: onSelected,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          style: regularTextStyle(fontSize: dimen14, color: Colors.black),
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle:
            regularTextStyle(fontSize: dimen14, color: Colors.grey),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            child: Container(
              width: MediaQuery.of(context).size.width - 24,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
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
