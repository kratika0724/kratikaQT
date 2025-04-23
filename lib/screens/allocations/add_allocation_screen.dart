import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qt_distributer/widgets/common_text_widgets.dart';
import '../../constants/app_colors.dart';
import '../../providers/allocation_provider.dart';
import '../../widgets/common_form_widgets.dart';
class AddAllocationScreen extends StatefulWidget {
  const AddAllocationScreen({super.key});

  @override
  State<AddAllocationScreen> createState() => _AddAllocationScreenState();
}

class _AddAllocationScreenState extends State<AddAllocationScreen> {

  final pincodeController = TextEditingController();
  final areaController = TextEditingController();

  @override
  void dispose() {
    pincodeController.dispose();
    areaController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AllocationProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: AppColors.secondary,
        title: HeaderTextThemeSecondary("Add allocation"),
        elevation: 3,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child:  Column(
                children: [
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal:12),
                      child: Column(
                        children: [
                          buildTextField('Allocation Pincode', controller: pincodeController),
                          buildTextField('Allocation Area',controller: areaController),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: FormActionButtons(
                      onSubmit: () {
                        provider.createAllocation(
                            context,
                            pincodeController,
                            areaController
                        );
                      },
                      onCancel: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  // Upload Excel Section
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'UPLOAD YOUR EXCEL HERE',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),

                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // File picker logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.black,
                      elevation: 0,
                    ),
                    child: const Text('Choose file'),
                  ),
                  const SizedBox(height: 5),
                  const Text('No file chosen'),
                  const SizedBox(height: 50),

                  // Download Sample Section
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Download Sample File From Here : ',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Download sample logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text('Click Here'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
