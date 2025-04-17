import 'package:flutter/material.dart';
import 'package:qt_distributer/constants/app_colors.dart';
import 'package:qt_distributer/screens/allocations/allocations_screen.dart';
import 'package:qt_distributer/screens/products/add_product_screen.dart';
import 'package:qt_distributer/screens/user%20profile/show_userprofile_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_textstyles.dart';
import '../screens/customer/customer_screen.dart';
import '../screens/base main/payments_screen.dart';
import '../screens/help_center.dart';
import '../screens/products/product_screen.dart';
import '../screens/web view/web_view_screen.dart';
import '../widgets/navigators.dart';

class UiUtils {

  Widget menuItem(BuildContext context, String title, IconData icon, {Widget? trailing}) {
    return GestureDetector(
      onTap: () {
        // Handle navigation here
        if(title.toLowerCase() == 'allocations'){
          Navigator.push(context, MaterialPageRoute(builder: (_) => AllocationsScreen()));
        }
        if(title.toLowerCase() == 'my profile'){
          Navigator.push(context, MaterialPageRoute(builder: (_) => ShowUserProfileScreen()));
        }
        if(title.toLowerCase() == 'products'){
          Navigator.push(context, MaterialPageRoute(builder: (_) => ProductScreen()));
        }
        if(title.toLowerCase() == 'payments'){
          Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentsScreen()));
        }
        if(title.toLowerCase() == 'customers'){
          Navigator.push(context, MaterialPageRoute(builder: (_) => CustomerScreen()));
        }
        if(title.toLowerCase()=="contact us")
        {
          showContactBottomSheet(context);
        }
        if(title.toLowerCase()=="terms & conditions")
        {
          CustomNavigators.pushNavigate(
              WebViewScreen(
                url: "https://flutter.dev",
                title: "Terms & Conditions",
              ),
              context);
        }
        if(title.toLowerCase()=="privacy policies")
        {
          CustomNavigators.pushNavigate(
              WebViewScreen(
                url: "https://vosovyapar.com/privacy-policy",
                title: "Privacy Policies",
              ),
              context);
        }
        if(title.toLowerCase()=="about us")
        {
          CustomNavigators.pushNavigate(
              WebViewScreen(
                url: "https://vosovyapar.com/privacy-policy",
                title: "About Us",
              ),
              context);
        }

      },
      child: Card(
        color: Colors.white,
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 1,left: 2,right: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6),),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: regularTextStyle(fontSize: dimen15, color: Colors.black)
            ),
            leading: Icon(icon, color: Colors.black,),
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
      builder: (BuildContext context) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 40),
              padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // const SizedBox(height: 10),
                  Text("Contact Us", style: semiBoldTextStyle(fontSize: dimen18,color: Colors.black)),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.call, color: Colors.black),
                    title: Text(
                      "Call us",
                      style: semiBoldTextStyle(fontSize: dimen15,color: Colors.black),
                    ),
                    subtitle: Text(
                      "To speak with a representative, start an instant call with our support team.",
                      style: regularTextStyle(fontSize: dimen13,color: Colors.black54),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _makePhoneCall(context, '+919876543210');
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Divider(thickness: 0.4, color: Colors.grey.shade300),
                  ),
                  ListTile(
                    leading: const Icon(Icons.email, color: Colors.black),
                    title:Text(
                      "Email us",
                      style: semiBoldTextStyle(fontSize: dimen15,color: Colors.black),
                    ),
                    subtitle: Text(
                      "Send a query to our customer support team via email.",
                      style: regularTextStyle(fontSize: dimen13,color: Colors.black54),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _launchEmail(context, "vososhop@gmail.com");
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),

            // Centered Floating Close Button
            Positioned(
              top: -20,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 22,
                    child: Icon(Icons.close, color: Colors.black87),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Function to launch email
  Future<void> _launchEmail(BuildContext context, String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Support Request&body=Hello,', // Optional pre-filled subject & body
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open email app")),
      );
    }
  }

  // Function to launch call
  Future<void> _makePhoneCall(BuildContext context, String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    _launchUrl(context, phoneUri);
  }

  Future<void> _launchUrl(BuildContext context, Uri uri) async {
    if (await canLaunchUrl(uri)) {
      try {
        await launchUrl(uri);
      } catch (e) {
        debugPrint("Could not launch $uri");
        _showSnackBar(context, "Could not make call.");
      }
    } else {
      _showSnackBar(context, "Could not open the link.");
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

}