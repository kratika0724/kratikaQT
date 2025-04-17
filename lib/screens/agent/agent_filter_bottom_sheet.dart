import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_textstyles.dart';
import '../../providers/agent_provider.dart';
import '../../providers/product_provider.dart';

class AgentFilterBottomSheet extends StatefulWidget {
  final String? initialName;
  final String? initialEmail;
  // final String? initialStatus;
  final Function(String?, String?) onApply;
  final VoidCallback onClear;


  const AgentFilterBottomSheet({
    super.key,
    required this.initialName,
    required this.initialEmail,
    required this.onApply,
    required this.onClear,
    // required this.initialStatus,
  });

  @override
  State<AgentFilterBottomSheet> createState() => _AgentFilterBottomSheetState();
}

class _AgentFilterBottomSheetState extends State<AgentFilterBottomSheet> {
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

    final provider = Provider.of<AgentProvider>(context, listen: false);
    final suggestions = provider.agents
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
          children: [
            const Text("Filter Agents", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
              onChanged: (val) => _updateSuggestions(val, false),
            ),
            ..._nameSuggestions.map((e) => _buildSuggestion(e, _nameController, false)),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
              onChanged: (val) => _updateSuggestions(val, true),
            ),
            ..._emailSuggestions.map((e) => _buildSuggestion(e, _emailController, true)),
            const SizedBox(height: 24),
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
