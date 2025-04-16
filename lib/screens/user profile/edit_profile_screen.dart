import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_textstyles.dart';
import '../../widgets/common_text_widgets.dart';

class EditUserProfileScreen extends StatefulWidget {
  const EditUserProfileScreen({super.key});

  @override
  State<EditUserProfileScreen> createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  String? gender;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    contactController.dispose();
    emailController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: HeaderTextBlack("User Profile"),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 6),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.3)],
                begin: Alignment.topLeft,
                end: Alignment.topRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 8),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: const Icon(
                        Icons.account_circle_sharp,
                        size: 100,
                        color: Colors.white, // This color becomes the base for the gradient
                      ),
                    ),
                    const SizedBox(height: 40),

                    buildTextField('First Name', firstNameController),
                    buildTextField('Last Name', lastNameController),
                    buildTextField('Contact Number', contactController, keyboardType: TextInputType.phone),
                    buildTextField('Email ID', emailController, keyboardType: TextInputType.emailAddress),
                    buildTextField('Age', ageController, keyboardType: TextInputType.number),
                    buildGenderSelector(),

                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Profile Saved')),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Text('Save', style: boldTextStyle(fontSize: dimen16,color: AppColors.primary)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          labelText: label,
          labelStyle: regularTextStyle(fontSize:dimen15, color: Colors.black,),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          )
        ),
        validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }

  Widget buildGenderSelector() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16,top:5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Gender', style: semiBoldTextStyle(fontSize: dimen16, color: Colors.white)),
          Row(
            children: [
              Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor: Colors.white, // Unselected color
                ),
                child: Radio<String>(
                  value: 'Male',
                  groupValue: gender,
                  onChanged: (value) => setState(() => gender = value),
                  fillColor: MaterialStateProperty.all(Colors.white), // Selected color
                  visualDensity: VisualDensity.compact,
                ),
              ),
              Text('Male', style: mediumTextStyle(fontSize: dimen16, color: Colors.white)),
              Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor: Colors.white,
                ),
                child: Radio<String>(
                  value: 'Female',
                  groupValue: gender,
                  onChanged: (value) => setState(() => gender = value),
                  fillColor: MaterialStateProperty.all(Colors.white),
                  visualDensity: VisualDensity.compact,
                ),
              ),
              Text('Female', style: mediumTextStyle(fontSize: dimen16, color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

}
