import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UiUtils {
  Widget menuItem(BuildContext context, String title, IconData icon,
      {Widget? trailing}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title,
          style: TextStyle(fontSize: 14, color: Colors.black)),
      leading: Icon(icon, color: Colors.black,),
      onTap: () {
       // Handle navigation here
      },
    );
  }
}