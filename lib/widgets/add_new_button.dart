import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_textstyles.dart';

class AddNewButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;

  const AddNewButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.fontSize = 14,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.backgroundColor = AppColors.secondary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: padding,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        label,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: boldTextStyle(fontSize: fontSize, color: Colors.white),
      ),
    );
  }
}
