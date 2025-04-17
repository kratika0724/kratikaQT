import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_textstyles.dart';

class FilterChipsWidget extends StatelessWidget {
  final Map<String, String?> filters;
  final VoidCallback onClear;

  const FilterChipsWidget({
    super.key,
    required this.filters,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> chips = [];

    filters.forEach((label, value) {
      if (value != null && value.isNotEmpty) {
        chips.add(_buildChip("$label: $value"));
      }
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (chips.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: chips.map((chip) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: chip,
                )).toList(),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildClearButton(),
            ],
          ), // always in separate row
        ],
      ),
    );
  }

  Widget _buildClearButton() {
    return ElevatedButton(
      onPressed: onClear,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        visualDensity: VisualDensity.comfortable,
        elevation: 3,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Clear Filters",
            style: mediumTextStyle(fontSize: dimen13, color: Colors.white),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.clear, size: 16, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Chip(
      label: Text(label, style: regularTextStyle(fontSize: dimen13, color: Colors.black)),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: const BorderSide(color: AppColors.secondary, width: 0.8),
      ),
      visualDensity: VisualDensity.comfortable,
    );
  }
}
