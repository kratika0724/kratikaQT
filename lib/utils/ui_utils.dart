import 'package:flutter/material.dart';
import 'package:qt_distributer/constants/app_colors.dart';
import 'package:qt_distributer/screens/user%20profile/show_userprofile_screen.dart';
import '../constants/app_textstyles.dart';
import '../screens/web view/web_view_screen.dart';
import '../widgets/contact_bottom_sheet.dart';
import '../widgets/navigators.dart';

class UiUtils {
  Widget menuItem(BuildContext context, String title, IconData icon,
      {Widget? trailing}) {
    return GestureDetector(
      onTap: () {
        // // Handle navigation here
        // if(title.toLowerCase() == 'allocations'){
        //   Navigator.push(context, MaterialPageRoute(builder: (_) => AllocationsScreen()));
        // }
        // if(title.toLowerCase() == 'my profile'){
        //   Navigator.push(context, MaterialPageRoute(builder: (_) => ShowUserProfileScreen()));
        // }
        // if(title.toLowerCase() == 'products'){
        //   Navigator.push(context, MaterialPageRoute(builder: (_) => ProductScreen()));
        // }
        // if(title.toLowerCase() == 'payments'){
        //   Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentsScreen()));
        // }
        // if(title.toLowerCase() == 'customers'){
        //   Navigator.push(context, MaterialPageRoute(builder: (_) => CustomerScreen()));
        // }
        // if(title.toLowerCase()=="contact us")
        // {
        //   showContactBottomSheet(context);
        // }
        // if(title.toLowerCase()=="terms & conditions")
        // {
        //   CustomNavigators.pushNavigate(
        //       WebViewScreen(
        //         url: "https://flutter.dev",
        //         title: "Terms & Conditions",
        //       ),
        //       context);
        // }
        // if(title.toLowerCase()=="privacy policies")
        // {
        //   CustomNavigators.pushNavigate(
        //       WebViewScreen(
        //         url: "https://vosovyapar.com/privacy-policy",
        //         title: "Privacy Policies",
        //       ),
        //       context);
        // }
        // if(title.toLowerCase()=="about us")
        // {
        //   CustomNavigators.pushNavigate(
        //       WebViewScreen(
        //         url: "https://vosovyapar.com/privacy-policy",
        //         title: "About Us",
        //       ),
        //       context);
        // }
      },
      child: Card(
        color: Colors.white,
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 1, left: 2, right: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style:
                    regularTextStyle(fontSize: dimen15, color: Colors.black)),
            leading: Icon(
              icon,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget VendormenuItem(BuildContext context, String title, IconData icon,
      {Widget? trailing}) {
    return GestureDetector(
      onTap: () {
        // Handle navigation here
        if (title.toLowerCase() == 'user wallets') {
          // Navigator.push(context, MaterialPageRoute(builder: (_) => AllocationsScreen()));
        }
        if (title.toLowerCase() == 'my profile') {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => ShowUserProfileScreen()));
        }
        if (title.toLowerCase() == 'products') {
          // Navigator.push(context, MaterialPageRoute(builder: (_) => ProductScreen()));
        }
        if (title.toLowerCase() == 'payments') {
          // Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentsScreen()));
        }
        if (title.toLowerCase() == 'customers') {
          // Navigator.push(context, MaterialPageRoute(builder: (_) => CustomerScreen()));
        }
        if (title.toLowerCase() == "contact us") {
          showContactBottomSheet(context);
        }
        if (title.toLowerCase() == "terms & conditions") {
          CustomNavigators.pushNavigate(
              WebViewScreen(
                url: "https://qtcollector.com/terms-and-conditions",
                title: "Terms & Conditions",
              ),
              context);
        }
        if (title.toLowerCase() == "privacy policies") {
          CustomNavigators.pushNavigate(
              WebViewScreen(
                url: "https://qtcollector.com/privacy-policy",
                title: "Privacy Policies",
              ),
              context);
        }
        if (title.toLowerCase() == "about us") {
          CustomNavigators.pushNavigate(
              WebViewScreen(
                url: "https://qtcollector.com/about",
                title: "About Us",
              ),
              context);
        }
      },
      child: Card(
        color: Colors.white,
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 1, left: 2, right: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style:
                    regularTextStyle(fontSize: dimen15, color: Colors.black)),
            leading: Icon(
              icon,
              color: AppColors.primary,
            ),
          ),
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

  void showContactBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => const ContactBottomSheet(),
    );
  }
}
