import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:qt_distributer/constants/app_assets.dart';
import 'package:qt_distributer/widgets/common_text_widgets.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../../constants/app_colors.dart';
import '../../../providers/allocation_provider.dart';
import '../../../widgets/common_form_widgets.dart';

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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        foregroundColor: AppColors.secondary,
        title: HeaderTextThemeSecondary("Add Allocation"),
        elevation: 3,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Manual Entry Section
              _buildSectionHeader("Manual Entry"),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      buildTextField(
                        'Pincode',
                        controller: pincodeController,
                      ),
                      const SizedBox(height: 16),
                      buildTextField(
                        'Area',
                        controller: areaController,
                      ),
                      const SizedBox(height: 16),
                      FormActionButtons(
                        onSubmit: () {
                          if (pincodeController.text.isEmpty ||
                              areaController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please fill all fields')),
                            );
                            return;
                          }
                          provider.createAllocation(
                            context,
                            pincodeController,
                            areaController,
                          );
                        },
                        onCancel: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Excel Upload Section
              _buildSectionHeader("Bulk Upload via Excel"),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Upload your Excel file containing allocation data',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () async {
                          provider.select_excelFile(context);
                        },
                        icon: const Icon(Icons.upload_file),
                        label: const Text('Choose Excel File'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade50,
                          foregroundColor: Colors.blue,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        provider.selectedFileName ?? 'No file chosen',
                        style: TextStyle(
                          color: provider.selectedFileName != null
                              ? AppColors.textGreen
                              : AppColors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Sample File Options',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton.icon(
                                onPressed: () async {
                                  try {
                                    final ByteData data = await rootBundle
                                        .load(AppAssets.sampleFile);
                                    final buffer = data.buffer;
                                    final downloadsDirectory = Directory(
                                        '/storage/emulated/0/Download');
                                    final file = File(
                                        '${downloadsDirectory.path}/sample_file.xlsx');

                                    await file.writeAsBytes(
                                      buffer.asUint8List(data.offsetInBytes,
                                          data.lengthInBytes),
                                    );

                                    if (mounted) {
                                      final result =
                                          await OpenFile.open(file.path);
                                      Fluttertoast.showToast(msg: 'OpenFile result: ${result.message}');
                                      print('OpenFile result: ${result.message}');
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      SnackBar(
                                          content:
                                              Text('Error opening file: $e'));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('Error opening file: $e')),
                                      );
                                    }
                                  }
                                },
                                icon: const Icon(Icons.open_in_new),
                                label: const Text('Open Sample'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 16),
                              TextButton.icon(
                                onPressed: () async {
                                  try {
                                    final ByteData data = await rootBundle
                                        .load(AppAssets.sampleFile);
                                    final buffer = data.buffer;
                                    final downloadsDirectory = Directory(
                                        '/storage/emulated/0/Download');
                                    final file = File(
                                        '${downloadsDirectory.path}/sample_file.xlsx');

                                    await file.writeAsBytes(
                                      buffer.asUint8List(data.offsetInBytes,
                                          data.lengthInBytes),
                                    );
                                    if (mounted) {
                                      // Share the file
                                      await Share.shareXFiles(
                                        [XFile(file.path)],
                                        text: 'Sample Allocation File',
                                      );
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      print('Error sharing file: $e');
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('Error sharing file: $e')),
                                      );
                                    }
                                  }
                                },
                                icon: const Icon(Icons.share),
                                label: const Text('Share Sample'),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.textGreen,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.secondary,
        ),
      ),
    );
  }
}
