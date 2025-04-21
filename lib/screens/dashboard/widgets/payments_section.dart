import 'package:flutter/material.dart';
import 'package:qt_distributer/screens/dashboard/widgets/payment_card.dart';
import 'package:qt_distributer/screens/dashboard/widgets/payment_success_card.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_textstyles.dart';

class PaymentsSection extends StatelessWidget {
  const PaymentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Payments",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:  boldTextStyle(
                      fontSize: dimen18,
                      color: Colors.black,
                      latterSpace: 1.0,
                    ),
                  ),

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0,horizontal: 8),
              child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: SuccessPaymentCardWidget(
                    title: "Payment Successful",
                    amount: "₹5009.00",
                    color: Colors.green,
                    icon: Icons.check_circle,
                    value: 60.0,
                  ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8.0,top:6),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 1.9,
                children: [
                  PaymentCardWidget(
                    title: "Pending",
                    amount: "₹ 7261.00",
                    color: Color(0xfff59d1b),
                    icon: Icons.error,
                    value: 60.0,
                  ),
                  PaymentCardWidget(
                    title: "Failed",
                    amount: "₹ 4025.00",
                    color: Color(0xfffd6363),
                    icon: Icons.cancel,
                    value: 60.0,
                  ),

                ],
              ),
            ),
            SizedBox(height: 5,),
          ],
        ),
      ),
    );
  }
}
