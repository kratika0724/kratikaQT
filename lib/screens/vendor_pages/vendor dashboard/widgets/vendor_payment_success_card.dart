import 'package:flutter/material.dart';
import '../../../../constants/app_textstyles.dart'; // adjust path if needed

class VendorSuccessPaymentCardWidget extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;
  final IconData icon;
  final double value;

  const VendorSuccessPaymentCardWidget({
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
        color: const Color(0xff13c898).withOpacity(0.1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 3,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: boldTextStyle(
                        fontSize: dimen16,
                        color: Colors.green.shade900,
                        latterSpace: 1.5,
                      ),
                    ),
                    Text(
                      amount,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: semiBoldTextStyle(
                        fontSize: dimen18,
                        color: Colors.green.shade900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    Icon(
                      icon,
                      color: const Color(0xff1c5e20),
                      size: 34,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
