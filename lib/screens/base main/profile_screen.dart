import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qt_distributer/constants/app_colors.dart';
import 'package:qt_distributer/screens/login/login_screen.dart';
import 'package:qt_distributer/widgets/common_text_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../services/user_preferences.dart';
import '../../utils/ui_utils.dart';
import '../../constants/app_textstyles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  bool showContactOptions = false;

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


  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<DashboardProvider>(context, listen: false);
      provider.getCustomerDatafromLocal();
    });
    return Consumer<DashboardProvider>(builder: (context, provider, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: HeaderTextThemeSecondary("User Profile"),
          // centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primary,
          elevation: 3,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // User Card
                Card(
                  color: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.indigo.shade900, AppColors.primary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                colors: [Colors.amber, Colors.white],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds);
                            },
                            child: const Icon(
                              Icons.person,
                              size: 90,
                              color: Colors
                                  .white, // This color becomes the base for the gradient
                            ),
                          ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(provider.fullName,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: semiBoldTextStyle(
                                        fontSize: dimen15,
                                        color: Colors.white)),
                                const SizedBox(height: 5,),
                                Text(provider.user_mobile_no ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: regularTextStyle(
                                      fontSize: dimen13,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Menu Options
                Expanded(
                  child: ListView(
                    children: [
                      // Custom Menu
                      UiUtils().menuItem(
                          context, "My Profile", Icons.person_outline),
                      UiUtils().menuItem(
                          context, "Products", Icons.payment_outlined),
                      UiUtils().menuItem(
                          context, "Customers", Icons.people_alt_outlined),
                      UiUtils().menuItem(
                          context, "Allocations", Icons.assignment_outlined),
                      // UiUtils().menuItem(
                      //     context, "Payments", Icons.payment_outlined),

                      // Base Menu
                      const SizedBox(height: 15,),
                      // Card(
                      //   color: Colors.white,
                      //   elevation: 3,
                      //   margin: const EdgeInsets.only(
                      //       bottom: 12, left: 3, right: 3),
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(12),
                      //   ),
                      //   child: Padding(
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 12.0, vertical: 10),
                      //     child: Column(
                      //       children: [
                      //         UiUtils().menuItemBase(context, "Contact Us",
                      //             Icons.headset_mic_outlined),
                      //         Divider(
                      //           thickness: 0.4, color: Colors.grey.shade300,),
                      //         UiUtils().menuItemBase(
                      //             context, "Terms & Conditions",
                      //             Icons.description_outlined),
                      //         Divider(
                      //           thickness: 0.4, color: Colors.grey.shade300,),
                      //         UiUtils().menuItemBase(
                      //             context, "Privacy Policies",
                      //             Icons.privacy_tip_outlined),
                      //         Divider(
                      //           thickness: 0.4, color: Colors.grey.shade300,),
                      //         UiUtils().menuItemBase(
                      //             context, "About Us", Icons.info_outline),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // ... Inside ListView
                      Card(
                        color: Colors.white,
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 12, left: 3, right: 3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  _showContactBottomSheet(context);
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.connect_without_contact_outlined,size: 20,color: Colors.black,),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text("Contact Us",
                                          style: regularTextStyle(fontSize: dimen15, color: Colors.black)),
                                    ),
                                    const Icon(Icons.arrow_forward_ios, color: Colors.black,size: 16,),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5,),
                              Divider(thickness: 0.4, color: Colors.grey.shade300),

                              UiUtils().menuItemBase(context, "Terms & Conditions", Icons.description_outlined),
                              Divider(thickness: 0.4, color: Colors.grey.shade300),
                              UiUtils().menuItemBase(context, "Privacy Policies", Icons.privacy_tip_outlined),
                              Divider(thickness: 0.4, color: Colors.grey.shade300),
                              UiUtils().menuItemBase(context, "About Us", Icons.info_outline),
                            ],
                          ),
                        ),
                      ),


                      //LogOut Button
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    // Ensure you pass the correct BuildContext here
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        // backgroundColor: white,
                                        title: const Text(
                                          "Logging Out!",
                                        ),
                                        content: const Text(
                                          "Are you sure you want to logout?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text(
                                              'NO',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await Provider.of<AuthProvider>(context, listen: false).logout();
                                              await PreferencesServices.clearData();

                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                                                    (route) => false,
                                              );
                                            },
                                            child: const Text(
                                              'YES',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 3,
                                backgroundColor: Theme
                                    .of(context)
                                    .colorScheme
                                    .primary,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(10), // Corner radius
                                ),
                              ),
                              icon: const Icon(
                                  Icons.logout, color: Colors.white),
                              label: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0),
                                child: Text("Logout",
                                    style: boldTextStyle(fontSize: dimen14,
                                        color: Colors.white)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _showContactBottomSheet(BuildContext context) {
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



}
