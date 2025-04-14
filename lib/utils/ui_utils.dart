import 'package:flutter/material.dart';
import 'package:qt_distributer/constants/app_colors.dart';
import 'package:qt_distributer/screens/allocations/allocations_screen.dart';
import 'package:qt_distributer/screens/products/add_product_screen.dart';
import 'package:qt_distributer/screens/user%20profile/edit_profile_screen.dart';
import '../constants/app_textstyles.dart';

class UiUtils {
  Widget menuItem(BuildContext context, String title, IconData icon, {Widget? trailing}) {
    return GestureDetector(
      onTap: () {

        // Handle navigation here
        if(title.toLowerCase() == 'allocations'){
          Navigator.push(context, MaterialPageRoute(builder: (_) => AllocationsScreen()));
        }
        if(title.toLowerCase() == 'my profile'){
          Navigator.push(context, MaterialPageRoute(builder: (_) => EditUserProfileScreen()));
        }
        if(title.toLowerCase() == 'products'){
          Navigator.push(context, MaterialPageRoute(builder: (_) => AddProductScreen()));
        }
      },
      child: Card(
        color: Colors.white,
        elevation: 3,
        margin: const EdgeInsets.only(bottom: 12,left: 2,right: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: regularTextStyle(fontSize: dimen14, color: AppColors.textSecondary)
            ),
            leading: Icon(icon, color: AppColors.secondary,),
          ),
        ),
      ),
    );
  }

  Widget menuItemBase(BuildContext context, String title, IconData icon, {Widget? trailing}) {
    return GestureDetector(
      onTap: () {
        // Handle navigation here
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary,size: 22),
            SizedBox(width: 10),
            Expanded(
              child: Text(title,
                  style: regularTextStyle(fontSize: dimen14, color: AppColors.textPrimary)),
            ),
            const Icon(Icons.arrow_forward_ios, color: AppColors.primary,size: 16,),

          ],


        ),
      ),
    );
  }

  void showErrorSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showSuccessSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showNormalSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.grey[300],
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}