import 'package:flutter/material.dart';

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
        title: const Text('User Profile'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const Text(
                  //   'Profile Information',
                  //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  // ),
                  Center(
                    child:ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return  LinearGradient(
                          colors: [Colors.indigo.shade900, Colors.blue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds);
                      },
                      child: const Icon(
                        Icons.person,
                        size: 100,
                        color: Colors.white, // This color becomes the base for the gradient
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  buildTextField('First Name', firstNameController),
                  buildTextField('Last Name', lastNameController),
                  buildTextField('Contact Number', contactController, keyboardType: TextInputType.phone),
                  buildTextField('Email ID', emailController, keyboardType: TextInputType.emailAddress),
                  buildTextField('Age', ageController, keyboardType: TextInputType.number),
                  buildGenderSelector(),

                  const SizedBox(height: 24),
                  Row(
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
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Save', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }

  Widget buildGenderSelector() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Gender', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Row(
            children: [
              Radio<String>(
                value: 'Male',
                groupValue: gender,
                onChanged: (value) => setState(() => gender = value),
              ),
              const Text('Male'),
              Radio<String>(
                value: 'Female',
                groupValue: gender,
                onChanged: (value) => setState(() => gender = value),
              ),
              const Text('Female'),
            ],
          ),
        ],
      ),
    );
  }
}
