import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_textstyles.dart';

class VendorPaymentFilterBottomSheet extends StatefulWidget {
  final String? initialQuintusId;
  final String? initialEmail;
  final String? initialStatus;
  final String? initialType;
  final DateTime? filterStartDate;
  final DateTime? filterEndDate;
  final Function(
      String?,
      String?,
      String?,
      String?,
      DateTime? startDate,
      DateTime? endDate,
      ) onApply;
  final VoidCallback onClear;

  const VendorPaymentFilterBottomSheet({
    super.key,
     this.initialQuintusId,
     this.initialEmail,
     this.initialStatus,
     this.initialType,
     this.filterStartDate,
     this.filterEndDate,
    required this.onApply,
    required this.onClear,
  });

  @override
  State<VendorPaymentFilterBottomSheet> createState() =>
      _VendorPaymentFilterBottomSheetState();
}

class _VendorPaymentFilterBottomSheetState
    extends State<VendorPaymentFilterBottomSheet> {
  late TextEditingController _quintusIdController;
  late TextEditingController _emailController;
  late String? _selectedStatus;
  late String? _selectedType;
  late DateTime? _startDate;
  late DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _quintusIdController =
        TextEditingController(text: widget.initialQuintusId ?? '');
    _emailController =
        TextEditingController(text: widget.initialEmail ?? '');
    _selectedStatus = widget.initialStatus;
    _selectedType = widget.initialType;
    _startDate = widget.filterStartDate;
    _endDate = widget.filterEndDate;
  }

  List<Widget> buildChoiceChips({
    required List<String> options,
    required String? selected,
    required ValueChanged<String> onSelected,
  }) {
    return options.map((option) {
      return ChoiceChip(
        label: Text(option),
        backgroundColor: Colors.grey.shade100,
        selectedColor: AppColors.primary,
        selected: selected == option,
        onSelected: (_) => onSelected(option),
        checkmarkColor: Colors.white,
        labelStyle: mediumTextStyle(
          fontSize: dimen13,
          color: selected == option ? Colors.white : Colors.black,
        ),
        side: BorderSide(
          color: selected == option ? Colors.transparent : Colors.white,
        ),
      );
    }).toList();
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
            Center(
              child: const Text(
                "Filter Payments",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // Quintus ID
            TextField(
              controller: _quintusIdController,
              decoration: const InputDecoration(
                labelText: 'Quintus ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Email
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Payment Status
            Text(
              "Payment Status",
              style: semiBoldTextStyle(fontSize: dimen14, color: Colors.black),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: buildChoiceChips(
                options: ['Success', 'Pending', 'Failed'],
                selected: _selectedStatus,
                onSelected: (val) => setState(() => _selectedStatus = val),
              ),
            ),
            const SizedBox(height: 16),

            // Transaction Type
            Text(
              "Transaction Type",
              style: semiBoldTextStyle(fontSize: dimen14, color: Colors.black),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: buildChoiceChips(
                options: ['Credit', 'Debit'],
                selected: _selectedType,
                onSelected: (val) => setState(() => _selectedType = val),
              ),
            ),
            const SizedBox(height: 16),

            // Date Range
            ListTile(
              title: Text(
                'Select Date Range',
                style: semiBoldTextStyle(fontSize: dimen14, color: Colors.black),
              ),
              subtitle: _startDate != null && _endDate != null
                  ? Text(
                "${DateFormat('dd MMM yyyy').format(_startDate!)} - ${DateFormat('dd MMM yyyy').format(_endDate!)}",
                style: mediumTextStyle(
                    fontSize: dimen14, color: Colors.black),
              )
                  : Text(
                'No date range selected',
                style: mediumTextStyle(
                    fontSize: dimen14, color: Colors.black),
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2023),
                  lastDate: DateTime.now(),
                  initialDateRange: _startDate != null && _endDate != null
                      ? DateTimeRange(start: _startDate!, end: _endDate!)
                      : null,
                );

                if (picked != null) {
                  setState(() {
                    _startDate = picked.start;
                    _endDate = picked.end;
                  });
                }
              },
            ),

            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApply(
                        _quintusIdController.text.trim().isNotEmpty
                            ? _quintusIdController.text.trim()
                            : null,
                        _emailController.text.trim().isNotEmpty
                            ? _emailController.text.trim()
                            : null,
                        _selectedStatus,
                        _selectedType,
                        _startDate,
                        _endDate,
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
                      backgroundColor: Colors.white,
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
