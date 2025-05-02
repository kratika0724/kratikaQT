import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qt_distributer/widgets/common_text_widgets.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_lists.dart';
import '../../../constants/app_textstyles.dart';
import '../../../providers/agent_provider.dart';
import '../../../providers/allocation_provider.dart';
import '../../../widgets/common_form_widgets.dart';

class AddAgentScreen extends StatefulWidget {
  const AddAgentScreen({super.key});

  @override
  State<AddAgentScreen> createState() => _AddAgentScreenState();
}

class _AddAgentScreenState extends State<AddAgentScreen> {
  String? selectedGender;
  DateTime? selectedDOB;
  // String? selectedAllocationId;

  String? selectedAssignedPinCode;
  String? selectedAssignedArea;

  // Text controllers
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
  final stateFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AllocationProvider>(context, listen: false)
          .getAllocationData(context); // ✅ also safe
    });

    assignedPinCodeController.addListener(() {
      setState(() {});
    });

    assignedAreaController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    assignedPinCodeFocusNode.dispose();
    assignedAreaFocusNode.dispose();
    stateFocusNode.dispose();

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
    final agentProvider = Provider.of<AgentProvider>(context);
    final allocationProvider = Provider.of<AllocationProvider>(context);

    final pincodeList = allocationProvider.getPincodeList();

    List<String> areaList = selectedAssignedPinCode != null
        ? allocationProvider.getAreaList(selectedAssignedPinCode!)
        : [];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        foregroundColor: AppColors.textBlack,
        title: HeaderTextBlack("Register Agent"),
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
                                  buildTextField('First Name',
                                      controller: firstnameController),
                                  buildTextField('Middle Name (Optional)',
                                      controller: middleNameController),
                                  buildTextField('Last Name',
                                      controller: lastNameController),
                                  buildTextField('Email',
                                      controller: emailController),
                                  buildTextField('Mobile No',
                                      controller: mobileController),
                                  buildCalendarTextField(
                                    context,
                                    'Date of Birth',
                                    hint: 'dd/mm/yyyy',
                                    selectedDate:
                                        selectedDOB, // ✅ Maintain state
                                    onDateSelected: (date) {
                                      setState(() {
                                        selectedDOB = date;
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  buildTextField('Address',
                                      controller: addressController),
                                  buildTextField('Pincode',
                                      controller: pinCodeController),
                                  buildTextField('City',
                                      controller: cityController),
                                  // buildTextField('State',
                                  //     controller: stateController),
                                  buildTypableDropdown(
                                    labelText: 'Select State',
                                    controller: stateController,
                                    focusNode: stateFocusNode,
                                    options: IndianStates.states,
                                    onSelected: (value) {
                                      setState(() {
                                        stateController.text = value ?? '';
                                      });
                                    },
                                  ),
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
                                    }, // Add controller here
                                  ),
                                  const SizedBox(height: 16),
                                  buildTypableDropdown(
                                    labelText: 'Assigned Area',
                                    controller: assignedAreaController,
                                    focusNode: assignedAreaFocusNode,
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
                                        selectedAssignedArea = value;
                                        assignedAreaController.text =
                                            value ?? '';
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 36),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 90),
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
          color: AppColors.surface,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: FormActionButtons(
            onSubmit: () {
              agentProvider.createAgent(
                context,
                firstnameController,
                middleNameController,
                lastNameController,
                emailController,
                mobileController,
                cityController,
                stateController,
                countryController,
                pinCodeController,
                assignedPinCodeController,
                assignedAreaController,
                gender: selectedGender?.toLowerCase(),
                dob: selectedDOB,
              );
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
          style: regularTextStyle(fontSize: dimen14, color: AppColors.textBlack),
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.arrow_drop_down),
            labelText: labelText,
            labelStyle:
                regularTextStyle(fontSize: dimen13, color: AppColors.textBlack54),
            floatingLabelStyle: regularTextStyle(
                fontSize: dimen16, color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.ghostWhite,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        final itemHeight = 48.0; // Approximate height for each ListTile
        final containerHeight = (options.length * itemHeight).clamp(0.0, 200.0);


        if(options.isEmpty){
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4,
              child: Container(
                // width: 310,
                height: containerHeight,
                color: AppColors.background,
                child: Center(
                  child: Text(
                    'No data available',
                    style: regularTextStyle(
                        fontSize: dimen14, color: AppColors.textBlack54),
                  ),
                ),
              ),
            ),
          );
        }


        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(right: 28.0),
            child: Material(
              elevation: 4,
              child: Container(
                width: double.infinity,
                height: containerHeight,
                color: AppColors.background,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final option = options.toList()[
                    index]; // Use options directly, no need to convert to list
                    // return ListTile(
                    //   title: Text(option),
                    //   onTap: () => onSelected(option),
                    // );
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
                      child: GestureDetector(
                        onTap: () => onSelected(option),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                  option,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
