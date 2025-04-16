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
  if (label.toLowerCase().contains('first name') || label.toLowerCase().contains('last name') || label.toLowerCase().contains('middle name (optional)')) {
    inputFormatters.add(LengthLimitingTextInputFormatter(30));
  }
  if (label.toLowerCase().contains('pincode')) {
    inputFormatters.add(LengthLimitingTextInputFormatter(6));
  }
  if (label.toLowerCase().contains('mobile no') ) {
    inputFormatters.add(LengthLimitingTextInputFormatter(10));
  }

  final _controller = controller ?? TextEditingController();

  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(
      controller: _controller,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      style: regularTextStyle(fontSize: dimen14, color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: regularTextStyle(fontSize: dimen13, color: Colors.black54),
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
      style: regularTextStyle(fontSize: dimen14, color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: regularTextStyle(fontSize: dimen13, color: Colors.black54),
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


Widget buildCalenderTextField(
    BuildContext context,
    String label, {
      String? hint,
      TextEditingController? controller,
    }) {

  bool isDateField = label.toLowerCase().contains('date');
  final _controller = controller ?? TextEditingController();

  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextField(
      controller: _controller,
      keyboardType: TextInputType.none,
      readOnly: isDateField,
      onTap: isDateField
          ? () async {
        final pickedDate = await showDatePicker(
          context: context, // Use passed-in context here
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          _controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        }
      }
          : null,
      style: regularTextStyle(fontSize: dimen14, color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: regularTextStyle(fontSize: dimen13, color: Colors.black54),
        floatingLabelStyle: regularTextStyle(fontSize: dimen16, color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.ghostWhite,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: isDateField
            ? const Icon(Icons.calendar_today_rounded, size: 20, color: Colors.black54)
            : null,
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
      style: regularTextStyle(fontSize: dimen14, color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: regularTextStyle(fontSize: dimen14, color: Colors.black54),
        filled: true,
        fillColor: AppColors.ghostWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dropdownColor: Colors.white, // Dropdown menu background color
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
            style: regularTextStyle(fontSize: dimen14, color: Colors.black)),
        Theme(
          data: ThemeData(
            unselectedWidgetColor: Colors.black54, // border color
            radioTheme: RadioThemeData(
              fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.selected)) {
                  return AppColors.secondary; // selected = secondary
                }
                return Colors.black54; // unselected = primary
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
            Text('Male',style: regularTextStyle(fontSize: dimen14, color: Colors.black)),
            Radio<String>(
                value: 'Female',
                groupValue: selectedGender,
                onChanged: onChanged
            ),
            Text('Female',style: regularTextStyle(fontSize: dimen14, color: Colors.black)),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: onSubmit,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14.0,horizontal: 50.0),
                  child: Center(
                    child: Text(
                      submitText,
                      style: semiBoldTextStyle(fontSize: dimen16, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),

          ElevatedButton(
            onPressed: onCancel,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(side: BorderSide(color: AppColors.primary),borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(vertical: 14.0,horizontal: 50.0),
            ),
            child: Text(
              cancelText,
              style: semiBoldTextStyle(fontSize: dimen16, color: AppColors.primary),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

