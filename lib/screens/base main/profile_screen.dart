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
import '../../widgets/app_theme_button.dart';
import '../user profile/show_userprofile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  bool showContactOptions = false;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<DashboardProvider>(context, listen: false);
      provider.getCustomerDatafromLocal();
    });
    return Consumer<DashboardProvider>(builder: (context, provider, child) {
      return Scaffold(
        backgroundColor: AppColors.ghostWhite.withOpacity(0.7),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: HeaderTextBlack("User Profile"),
          // centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primary,
          // elevation: 3,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                // User Card
                GestureDetector(
                  onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_) => ShowUserProfileScreen())),
                  child: Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary,
                            Colors.indigo.withOpacity(0.8),],
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
                            Icon(
                              Icons.account_circle_sharp,
                              size: 90,
                              color: Colors.white, // This color becomes the base for the gradient
                            ),

                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left:8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          fontSize: dimen15,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Icon(Icons.arrow_forward_ios,color: Colors.white),
                          ],
                        ),
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
                      // UiUtils().menuItem(context, "My Profile", Icons.person_outline),
                      UiUtils().menuItem(context, "Products", Icons.payment_outlined),
                      UiUtils().menuItem(context, "Customers", Icons.people_alt_outlined),
                      UiUtils().menuItem(context, "Allocations", Icons.assignment_outlined),
                      UiUtils().menuItem(context, "Contact Us", Icons.connect_without_contact),
                      UiUtils().menuItem(context, "Terms & Conditions", Icons.description_outlined),
                      UiUtils().menuItem(context, "Privacy Policies", Icons.privacy_tip_outlined),
                      UiUtils().menuItem(context, "About Us", Icons.info_outline),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 26.0,vertical: 30),
                        child: AppThemeButton(label: 'Log Out', onPressed: () {
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
                        },),
                      ),
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
}
