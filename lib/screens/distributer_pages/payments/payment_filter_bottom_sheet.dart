import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_textstyles.dart';
import '../../../providers/transaction_provider.dart';

class PaymentFilterBottomSheet extends StatefulWidget {
  final String? initialQuintusId;
  final String? initialEmail;
  final String? initialStatus; // "Success", "Pending", "Failed"
  final String? initialType; // "Credit", "Debit"
  final DateTime? filterStartDate;
  final DateTime? filterEndDate;
  final Function(String?, String?, String?, String?, DateTime? startDate,
      DateTime? endDate,) onApply;
  final VoidCallback onClear;

  const PaymentFilterBottomSheet({
    super.key,
    required this.initialQuintusId,
    required this.initialEmail,
    required this.initialStatus,
    required this.initialType,
    required this.filterStartDate,
    required this.filterEndDate,
    required this.onApply,
    required this.onClear,
  });

  @override
  State<PaymentFilterBottomSheet> createState() => _PaymentFilterBottomSheetState();
}

class _PaymentFilterBottomSheetState extends State<PaymentFilterBottomSheet> {
  late TextEditingController _quintusIdController;
  late TextEditingController _emailController;
  late String? _selectedStatus;
  late String? _selectedType;
  late DateTime? StartDate;
  late DateTime? EndDate;

  List<String> _idSuggestions = [];
  List<String> _emailSuggestions = [];

  @override
  void initState() {
    super.initState();
    _quintusIdController = TextEditingController(text: widget.initialQuintusId ?? '');
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
    _selectedStatus = widget.initialStatus;
    _selectedType = widget.initialType;
    StartDate = widget.filterStartDate;
    EndDate = widget.filterEndDate;
  }

  @override
  void dispose() {
    _quintusIdController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _updateSuggestions(String query, bool isEmail) {
    if (query.length < 3) {
      setState(() {
        if (isEmail) {
          _emailSuggestions.clear();
        } else {
          _idSuggestions.clear();
        }
      });
      return;
    }

    final provider = Provider.of<TransactionProvider>(context, listen: false);
    final suggestions = provider.transactions
        .map((e) =>isEmail ? (e.user.email ?? '') : (e.quintusTransactionId ?? '') )
        .where((val) => val.toLowerCase().contains(query.toLowerCase()))
        .toSet()
        .toList();

    setState(() {
      if (isEmail) {
        _emailSuggestions = suggestions;
      } else {
        _idSuggestions = suggestions;
      }
    });
  }

  Widget _buildSuggestion(String value,TextEditingController controller, bool isEmail) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: AppColors.grey100,
      ),
      child: ListTile(
        dense: true,
        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
        minVerticalPadding: 0,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        title: Text(value, style: regularTextStyle(fontSize: dimen13, color: Colors.black)),
        onTap: () {
          controller.text = value;
          setState(() {
            if (isEmail) {
              _emailSuggestions.clear();
            } else {
              _idSuggestions.clear();
            }
          });
        },
      ),
    );
  }

  List<Widget> buildChoiceChips({
    required List<String> options,
    required String? selected,
    required ValueChanged<String> onSelected,
  }) {
    return options.map((option) {
      return ChoiceChip(
        label: Text(option),
        backgroundColor: Colors.grey.shade100, // grey background when not selected
        selectedColor: AppColors.primary,
        selected: selected == option,
        onSelected: (_) => onSelected(option),
        checkmarkColor: Colors.white,
        labelStyle: mediumTextStyle(fontSize: dimen13, color: selected == option ? Colors.white : Colors.black),
        side: BorderSide(color: selected == option ? Colors.transparent : Colors.white),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Filter Payments", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),

            // Quintus ID field
            TextField(
              controller: _quintusIdController,
              decoration: const InputDecoration(labelText: 'Quintus ID', border: OutlineInputBorder()),
              onChanged: (val) => _updateSuggestions(val, false),
            ),
            ..._idSuggestions.map((e) => _buildSuggestion(e, _quintusIdController, false)),
            const SizedBox(height: 16),

            //Email text field
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
              onChanged: (val) => _updateSuggestions(val, true),
            ),
            ..._emailSuggestions.map((e) => _buildSuggestion(e, _emailController, true)),
            const SizedBox(height: 16),

            // Payment Status filter
            Text("Payment Status", style: semiBoldTextStyle(fontSize: dimen14, color: Colors.black)),
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

            // Transaction Type filter
            Text("Transaction Type", style: semiBoldTextStyle(fontSize: dimen14, color: Colors.black)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: buildChoiceChips(
                options: ['Credit', 'Debit'],
                selected: _selectedType,
                onSelected: (val) => setState(() => _selectedType = val),
              ),
            ),

            ListTile(
              title: Text('Select Date Range',style: semiBoldTextStyle(fontSize: dimen14, color: Colors.black)),
              subtitle: StartDate != null && EndDate != null
                  ? Text("${DateFormat('dd MMM yyyy').format(StartDate!)} - ${DateFormat('dd MMM yyyy').format(EndDate!)}",style: mediumTextStyle(fontSize: dimen14, color: Colors.black))
                  : Text('No date range selected',style: mediumTextStyle(fontSize: dimen14, color: Colors.black)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2023),
                  lastDate: DateTime.now(),
                  initialDateRange: StartDate != null && EndDate != null
                      ? DateTimeRange(start: StartDate!, end: EndDate!)
                      : null,
                );

                if (picked != null) {
                  setState(() {
                    StartDate = picked.start;
                    EndDate = picked.end;
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
                        _quintusIdController.text.trim().isNotEmpty ? _quintusIdController.text.trim() : null,
                        _emailController.text.trim().isNotEmpty ? _emailController.text.trim() : null,
                        _selectedStatus,
                        _selectedType,
                        StartDate,
                        EndDate,
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
