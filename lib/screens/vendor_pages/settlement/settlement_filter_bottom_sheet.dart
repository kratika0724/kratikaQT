import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_textstyles.dart';

class SettlementFilterBottomSheet extends StatefulWidget {
  final String? initialQuintusId;
  final String? initialEmail;
  final DateTime? filterStartDate;
  final DateTime? filterEndDate;
  final Function(String?, String?, DateTime? startDate, DateTime? endDate) onApply;
  final VoidCallback onClear;

  const SettlementFilterBottomSheet({
    super.key,
     this.initialQuintusId,
     this.initialEmail,
     this.filterStartDate,
     this.filterEndDate,
     required this.onApply,
     required this.onClear,
  });

  @override
  State<SettlementFilterBottomSheet> createState() => _SettlementFilterBottomSheetState();
}

class _SettlementFilterBottomSheetState extends State<SettlementFilterBottomSheet> {
  late TextEditingController _quintusIdController;
  late TextEditingController _emailController;
  late DateTime? StartDate;
  late DateTime? EndDate;

  List<String> _idSuggestions = [];
  List<String> _emailSuggestions = [];

  @override
  void initState() {
    super.initState();
    _quintusIdController = TextEditingController(text: widget.initialQuintusId ?? '');
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
    StartDate = widget.filterStartDate;
    EndDate = widget.filterEndDate;
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

    // Mock dummy suggestions (since backend logic removed)
    final dummySuggestions = List.generate(3, (index) => '$query Suggestion $index');

    setState(() {
      if (isEmail) {
        _emailSuggestions = dummySuggestions;
      } else {
        _idSuggestions = dummySuggestions;
      }
    });
  }

  Widget _buildSuggestion(String value, TextEditingController controller, bool isEmail) {
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
            const Center(
              child: Text(
                "Filter Settlement Requests",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
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

            // Email text field
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
              onChanged: (val) => _updateSuggestions(val, true),
            ),
            ..._emailSuggestions.map((e) => _buildSuggestion(e, _emailController, true)),
            const SizedBox(height: 16),

            // Date range selector
            ListTile(
              title: Text(
                'Select Date Range',
                style: semiBoldTextStyle(fontSize: dimen14, color: Colors.black),
              ),
              subtitle: StartDate != null && EndDate != null
                  ? Text(
                "${DateFormat('dd MMM yyyy').format(StartDate!)} - ${DateFormat('dd MMM yyyy').format(EndDate!)}",
                style: mediumTextStyle(fontSize: dimen14, color: Colors.black),
              )
                  : Text(
                'No date range selected',
                style: mediumTextStyle(fontSize: dimen14, color: Colors.black),
              ),
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
