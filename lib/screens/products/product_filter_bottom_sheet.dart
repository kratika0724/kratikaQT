import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_textstyles.dart';
import '../../providers/product_provider.dart';

class ProductFilterBottomSheet extends StatefulWidget {
  final String? initialName;
  final String? initialCode;
  final Function(String?, String?) onApply;
  final VoidCallback onClear;


  const ProductFilterBottomSheet({
    super.key,
    required this.initialName,
    required this.initialCode,
    required this.onApply,
    required this.onClear,
  });

  @override
  State<ProductFilterBottomSheet> createState() => _ProductFilterBottomSheetState();
}

class _ProductFilterBottomSheetState extends State<ProductFilterBottomSheet> {
  late TextEditingController _nameController;
  late TextEditingController _codeController;

  List<String> _nameSuggestions = [];
  List<String> _codeSuggestions = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _codeController = TextEditingController(text: widget.initialCode ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _updateSuggestions(String query, bool isCode) {
    if (query.length < 3) {
      setState(() {
        if (isCode) {
          _codeSuggestions.clear();
        } else {
          _nameSuggestions.clear();
        }
      });
      return;
    }

    final provider = Provider.of<ProductProvider>(context, listen: false);
    final suggestions = provider.products
        .map((e) => isCode ? (e.productCode ?? '') : (e.productName ?? ''))
        .where((val) => val.toLowerCase().contains(query.toLowerCase()))
        .toSet()
        .toList();

    setState(() {
      if (isCode) {
        _codeSuggestions = suggestions;
      } else {
        _nameSuggestions = suggestions;
      }
    });
  }

  Widget _buildSuggestion(String value, TextEditingController controller, bool isCode) {
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
            if (isCode) {
              _codeSuggestions.clear();
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
          children: [
            const Text("Filter Products", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
              onChanged: (val) => _updateSuggestions(val, false),
            ),
            ..._nameSuggestions.map((e) => _buildSuggestion(e, _nameController, false)),
            const SizedBox(height: 16),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: 'Code', border: OutlineInputBorder()),
              onChanged: (val) => _updateSuggestions(val, true),
            ),
            ..._codeSuggestions.map((e) => _buildSuggestion(e, _codeController, true)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApply(
                        _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : null,
                        _codeController.text.trim().isNotEmpty ? _codeController.text.trim() : null,
                      );
                      final provider = Provider.of<ProductProvider>(context, listen: false);
                      provider.refreshProductData();

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
