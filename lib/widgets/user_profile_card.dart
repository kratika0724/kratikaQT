// widgets/user_profile_card.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_textstyles.dart';

class UserProfileCard extends StatelessWidget {
  final String name;
  final String mobile;
  final VoidCallback? onTap;
  final bool showArrow;

  const UserProfileCard({
    super.key,
    required this.name,
    required this.mobile,
    this.onTap,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, Colors.indigo.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.account_circle_sharp,
                  size: 90,
                  color: Colors.white,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: semiBoldTextStyle(
                            fontSize: dimen15,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          mobile,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: regularTextStyle(
                            fontSize: dimen15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (showArrow)
                  const Icon(Icons.arrow_forward_ios, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
