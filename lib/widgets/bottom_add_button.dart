import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_textstyles.dart';

class BottomAddButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData icon;

  const BottomAddButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.add,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 8),
          child: SizedBox(
            height: 45,
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              onPressed: onPressed,
              icon: Icon(icon, size: 18, color: Colors.white),
              label: Text(
                label,
                style: mediumTextStyle(fontSize: dimen15, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
