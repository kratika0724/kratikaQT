import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_textstyles.dart';
import '../../../../providers/allocation_provider.dart';

class AllocationFilterBottomSheet extends StatefulWidget {
  final String? initialPincode;
  final String? initialArea;
  final Function(String?, String?) onApply;
  final VoidCallback onClear;

  const AllocationFilterBottomSheet({
    super.key,
    required this.initialPincode,
    required this.initialArea,
    required this.onApply,
    required this.onClear,
  });

  @override
  State<AllocationFilterBottomSheet> createState() => _AllocationFilterBottomSheetState();
}

class _AllocationFilterBottomSheetState extends State<AllocationFilterBottomSheet> {
  late TextEditingController _pincodeController;
  late TextEditingController _areaController;
  List<String> _pincodeSuggestions = [];
  List<String> _areaSuggestions = [];

  @override
  void initState() {
    super.initState();
    _pincodeController = TextEditingController(text: widget.initialPincode ?? '');
    _areaController = TextEditingController(text: widget.initialArea ?? '');
  }

  void _updateSuggestions(String query, bool isPincode) {
    if (query.length < 3) {
      setState(() {
        if (isPincode) {
          _pincodeSuggestions.clear();
        } else {
          _areaSuggestions.clear();
        }
      });
      return;
    }

    final provider = Provider.of<AllocationProvider>(context, listen: false);
    final suggestions = provider.allocations
        .map((e) => isPincode ? (e.allocationPincode ?? '') : (e.allocationArea ?? ''))
        .where((val) => val.toLowerCase().contains(query.toLowerCase()))
        .toSet()
        .toList();

    setState(() {
      if (isPincode) {
        _pincodeSuggestions = suggestions;
      } else {
        _areaSuggestions = suggestions;
      }
    });
  }

  Widget _buildSuggestion(String value, TextEditingController controller, bool isPincode) {
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
            if (isPincode) {
              _pincodeSuggestions.clear();
            } else {
              _areaSuggestions.clear();
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
          children: [
            const Text("Filter Allocations", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: _pincodeController,
              decoration: const InputDecoration(labelText: 'Pincode', border: OutlineInputBorder(),),
              keyboardType: TextInputType.number,
              maxLength: 6,
              onChanged: (val) => _updateSuggestions(val, true),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            ..._pincodeSuggestions.map((e) => _buildSuggestion(e, _pincodeController, true)),
            const SizedBox(height: 16),
            TextField(
              controller: _areaController,
              decoration: const InputDecoration(labelText: 'Area', border: OutlineInputBorder()),
              onChanged: (val) => _updateSuggestions(val, false),
            ),
            ..._areaSuggestions.map((e) => _buildSuggestion(e, _areaController, false)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApply(
                        _pincodeController.text.trim().isNotEmpty ? _pincodeController.text.trim() : null,
                        _areaController.text.trim().isNotEmpty ? _areaController.text.trim() : null,
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
