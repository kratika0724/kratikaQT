import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_textstyles.dart';

class FilterButton extends StatelessWidget {
  final bool hasFilters;
  final String label;
  final double maxWidth;
  final VoidCallback onApplyTap;
  final VoidCallback onClearTap;

  const FilterButton({
    super.key,
    required this.hasFilters,
    required this.label,
    required this.maxWidth,
    required this.onApplyTap,
    required this.onClearTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = hasFilters
        ? AppColors.secondary
        : AppColors.primary.withOpacity(0.08);
    final Color textColor = hasFilters ? Colors.white : AppColors.secondary;
    final Color iconColor = textColor;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () => hasFilters ? onClearTap() : onApplyTap(),
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 34,
          constraints: BoxConstraints(maxWidth: maxWidth),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
            // border: Border.all(color: AppColors.secondary),
            boxShadow: [
              if (hasFilters)
                BoxShadow(
                  color: AppColors.secondary.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  hasFilters ? "Clear $label" : "Filter $label",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: semiBoldTextStyle(fontSize: dimen13, color: textColor),
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                hasFilters ? Icons.clear : Icons.filter_list,
                size: 18,
                color: iconColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
