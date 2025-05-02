import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qt_distributer/constants/app_textstyles.dart';
import '../constants/app_colors.dart';
import 'package:flutter/services.dart';

Widget buildTextField(
    String label, {
      String? hint,
      TextEditingController? controller,
    }) {
  TextInputType keyboardType = TextInputType.text;

  if (label.toLowerCase().contains('email')) {
    keyboardType = TextInputType.emailAddress;
  }
  else if (label.toLowerCase().contains('mobile')) {
    keyboardType = TextInputType.phone;
  }
  else if (label.toLowerCase().contains('pincode')) {
    keyboardType = TextInputType.number;
  }


  List<TextInputFormatter> inputFormatters = [];
  if (label.toLowerCase().contains('first name') || label.toLowerCase().contains('last name') || label.toLowerCase().contains('middle name (optional)') || label.toLowerCase().contains('email')) {
    inputFormatters.add(LengthLimitingTextInputFormatter(30));
  }
  if (label.toLowerCase().contains('pincode')) {
    inputFormatters.add(LengthLimitingTextInputFormatter(6));
  }
  if (label.toLowerCase().contains('mobile') ) {
    inputFormatters.add(LengthLimitingTextInputFormatter(10));
  }

  final _controller = controller ?? TextEditingController();

  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(
      controller: _controller,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      style: regularTextStyle(fontSize: dimen14, color: AppColors.textBlack),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: regularTextStyle(fontSize: dimen13, color: AppColors.textBlack54),
        floatingLabelStyle: regularTextStyle(fontSize: dimen16, color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.ghostWhite,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}

Widget buildProductTextField(
    String label, {
      String? hint,
      TextEditingController? controller,
    }) {
  TextInputType keyboardType = TextInputType.text;

  if (label.toLowerCase().contains('product amount')) {
    keyboardType = TextInputType.number;
  }

  List<TextInputFormatter> inputFormatters = [];
  if (label.toLowerCase().contains('product name') || label.toLowerCase().contains('product code')) {
    inputFormatters.add(LengthLimitingTextInputFormatter(50));
  }

  final _controller = controller ?? TextEditingController();

  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextField(
      controller: _controller,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      style: regularTextStyle(fontSize: dimen14, color: AppColors.textBlack),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: regularTextStyle(fontSize: dimen13, color: AppColors.textBlack54),
        floatingLabelStyle: regularTextStyle(fontSize: dimen16, color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.ghostWhite,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.secondary,
          ),
        ),

      ),
    ),
  );
}


Widget buildCalendarTextField(
    BuildContext context,
    String label, {
      required String hint,
      required Function(DateTime) onDateSelected,
      DateTime? selectedDate,
    }) {
  return GestureDetector(
    onTap: () async {
      final picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
      );

      if (picked != null) {
        onDateSelected(picked);
      }
    },
    child: AbsorbPointer(
      child: TextField(
        controller: TextEditingController(
          text: selectedDate != null ? "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}" : "",
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: regularTextStyle(fontSize: dimen14, color: AppColors.textBlack54),
          hintText: hint,
          filled: true,
          fillColor: AppColors.ghostWhite,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        style: regularTextStyle(fontSize: dimen14, color: AppColors.textBlack),
      ),
    ),
  );
}


Widget buildDropdown(
    String label,
    String? value,
    List<String> items,
    void Function(String?) onChanged,
    ) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: DropdownButtonFormField<String>(
      value: value,
      style: regularTextStyle(fontSize: dimen14, color: AppColors.textBlack),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: regularTextStyle(fontSize: dimen14, color: AppColors.textBlack54),
        filled: true,
        fillColor: AppColors.ghostWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dropdownColor: AppColors.textWhite, // Dropdown menu background color
      borderRadius: BorderRadius.circular(12), // Rounded dropdown corners
      items: items
          .map((item) => DropdownMenuItem(
        value: item,
        child: Text(item),
      ))
          .toList(),
      onChanged: onChanged,
    ),
  );
}


Widget buildGenderSelector({String? selectedGender, required Null Function(dynamic value) onChanged}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            'Gender',
            style: regularTextStyle(fontSize: dimen14, color: AppColors.textBlack)),
        Theme(
          data: ThemeData(
            unselectedWidgetColor: AppColors.textBlack54, // border color
            radioTheme: RadioThemeData(
              fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.selected)) {
                  return AppColors.secondary; // selected = secondary
                }
                return AppColors.textBlack54; // unselected = primary
              }),
            ),
          ),
          child: Row(
          children: [
            Radio<String>(
              value: 'Male',
              groupValue: selectedGender,
              onChanged: onChanged,
            ),
            Text('Male',style: regularTextStyle(fontSize: dimen14, color: AppColors.textBlack)),
            Radio<String>(
                value: 'Female',
                groupValue: selectedGender,
                onChanged: onChanged
            ),
            Text('Female',style: regularTextStyle(fontSize: dimen14, color: AppColors.textBlack)),
          ],
        ),
        )
      ],
    ),
  );
}

class FormActionButtons extends StatelessWidget {
  final VoidCallback onSubmit;
  final VoidCallback onCancel;
  final String submitText;
  final String cancelText;

  const FormActionButtons({
    Key? key,
    required this.onSubmit,
    required this.onCancel,
    this.submitText = 'Submit',
    this.cancelText = 'Cancel',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  colors: [
                    AppColors.primary,
                    Colors.indigo.withOpacity(0.8),
                  ],
                ),
                border: Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: onSubmit,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                    child: Center(
                      child: Text(
                        submitText,
                        style: semiBoldTextStyle(fontSize: dimen16, color: AppColors.textWhite),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Container(
              decoration: BoxDecoration(
                // gradient: LinearGradient(
                //   colors: [AppColors.primary, AppColors.primary.withOpacity(0.3)],
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                // ),
                color: AppColors.background,
                border: Border.all(color: AppColors.primary),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Material(
                // elevation: 3,
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: onCancel,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                    child: Center(
                      child: Text(
                        cancelText,
                        style: semiBoldTextStyle(fontSize: dimen16, color: AppColors.primary),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

