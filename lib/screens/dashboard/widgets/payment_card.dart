import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_textstyles.dart'; // adjust path if needed

class PaymentCardWidget extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;
  final IconData icon;
  final double value;

  const PaymentCardWidget({
    super.key,
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: color.withOpacity(0.2),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6), // Rounded corners
                      ),
                    ),
                    Icon(
                      icon,
                      color: color,
                      size: 23,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          amount,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: semiBoldTextStyle(
                            fontSize: dimen18,
                            color: AppColors.secondary,
                          ),
                        ),
                        Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: semiBoldTextStyle(
                              fontSize: dimen16,
                              color: AppColors.secondary,
                              // latterSpace: 1.5
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              // SizedBox(height: 10,),
            ],
          ),
        ));
  }
}
