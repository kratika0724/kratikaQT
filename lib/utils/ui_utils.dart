import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qt_distributer/constants/app_colors.dart';

class UiUtils {
  Widget menuItem(BuildContext context, String title, IconData icon,
      {Widget? trailing}) {
    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12,left: 2,right: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(title,
              style: TextStyle(fontSize: 14, color: Colors.black)),
          leading: Icon(icon, color: AppColors.primary,),
          onTap: () {
           // Handle navigation here
          },
        ),
      ),
    );
  }


  Widget menuItemBase(BuildContext context, String title, IconData icon,
      {Widget? trailing}) {
    return GestureDetector(
      onTap: () {
        // Handle navigation here
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey.shade600),
            SizedBox(width: 10),
            Expanded(
              child: Text(title,
                  style: TextStyle(fontSize: 14, color: Colors.black)),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey,size: 20,),

          ],


        ),
      ),
    );
  }
}