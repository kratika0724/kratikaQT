import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_textstyles.dart';

class DistributorFilterBottomSheet extends StatefulWidget {
  final String? initialName;
  final String? initialEmail;
  final bool? initialIsActive;
  final Function(String?, String?, bool?) onApply;
  final VoidCallback onClear;

  const DistributorFilterBottomSheet({
    super.key,
    required this.initialName,
    required this.initialEmail,
    required this.onApply,
    required this.onClear,
    this.initialIsActive,
  });

  @override
  State<DistributorFilterBottomSheet> createState() => _DistributorFilterBottomSheetState();
}

class _DistributorFilterBottomSheetState extends State<DistributorFilterBottomSheet> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late bool? _isActive;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
    _isActive = widget.initialIsActive ?? true; // default to active
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Filter Distributors", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),

            // Name field
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),

            // Email field
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),

            // Status filter
            Wrap(
              spacing: 8,
              children: [
                {'label': 'Active', 'value': true},
                {'label': 'Inactive', 'value': false},
              ].map((item) {
                return ChoiceChip(
                  backgroundColor: AppColors.grey100,
                  selectedColor: AppColors.primary,
                  checkmarkColor: AppColors.textWhite,
                  label: Text(item['label'] as String),
                  labelStyle: mediumTextStyle(
                    fontSize: dimen13,
                    color: _isActive == item['value'] ? AppColors.textWhite : AppColors.textBlack,
                  ),
                  selected: _isActive == item['value'],
                  onSelected: (_) {
                    setState(() {
                      _isActive = item['value'] as bool;
                    });
                  },
                  side: BorderSide(
                    color: _isActive == item['value'] ? Colors.transparent : AppColors.textWhite,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApply(
                        _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : null,
                        _emailController.text.trim().isNotEmpty ? _emailController.text.trim() : null,
                        _isActive,
                      );
                      Navigator.pop(context);
                    },
                    child: const Text("Apply Filters"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.textWhite,
                      foregroundColor: AppColors.primary,
                    ),
                    onPressed: () {
                      widget.onClear();
                      Navigator.pop(context);
                    },
                    child: const Text("Clear Filters"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
