import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_textstyles.dart';

class AppThemeButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;

  const AppThemeButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.fontSize = 14,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
    this.backgroundColor = AppColors.secondary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient:  LinearGradient(
          colors: [AppColors.primary, Colors.indigo.withOpacity(0.8)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: padding,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(
          label,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: boldTextStyle(fontSize: fontSize, color: Colors.white),
        ),
      ),
    );
  }
}
