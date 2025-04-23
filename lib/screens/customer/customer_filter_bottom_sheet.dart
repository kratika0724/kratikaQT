import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_textstyles.dart';
import '../../providers/customer_provider.dart';

class CustomerFilterBottomSheet extends StatefulWidget {
  final String? initialName;
  final String? initialEmail;
  final Function(String?, String?) onApply;
  final VoidCallback onClear;

  const CustomerFilterBottomSheet({
    super.key,
    required this.initialName,
    required this.initialEmail,
    required this.onApply,
    required this.onClear,
  });

  @override
  State<CustomerFilterBottomSheet> createState() => _CustomerFilterBottomSheetState();
}

class _CustomerFilterBottomSheetState extends State<CustomerFilterBottomSheet> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  List<String> _nameSuggestions = [];
  List<String> _emailSuggestions = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _updateSuggestions(String query, bool isEmail) {
    if (query.length < 3) {
      setState(() {
        if (isEmail) {
          _emailSuggestions.clear();
        } else {
          _nameSuggestions.clear();
        }
      });
      return;
    }

    final provider = Provider.of<CustomerProvider>(context, listen: false);
    final suggestions = provider.customers
        .map((e) => isEmail ? (e.email ?? '') : (e.firstName ?? ''))
        .where((val) => val.toLowerCase().contains(query.toLowerCase()))
        .toSet()
        .toList();

    setState(() {
      if (isEmail) {
        _emailSuggestions = suggestions;
      } else {
        _nameSuggestions = suggestions;
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
              _nameSuggestions.clear();
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Filter Customers", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),

            // Name Field
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
              onChanged: (val) => _updateSuggestions(val, false),
            ),
            ..._nameSuggestions.map((e) => _buildSuggestion(e, _nameController, false)),
            const SizedBox(height: 16),

            // Email Field
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
              onChanged: (val) => _updateSuggestions(val, true),
            ),
            ..._emailSuggestions.map((e) => _buildSuggestion(e, _emailController, true)),
            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApply(
                        _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : null,
                        _emailController.text.trim().isNotEmpty ? _emailController.text.trim() : null,
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
