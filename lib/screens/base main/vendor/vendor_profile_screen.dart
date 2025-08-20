import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qt_distributer/constants/app_colors.dart';
import 'package:qt_distributer/widgets/common_text_widgets.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../utils/ui_utils.dart';
import '../../../widgets/log_out_button.dart';
import '../../../widgets/user_profile_card.dart';
import '../../user profile/show_userprofile_screen.dart';

class VendorProfileScreen extends StatefulWidget {
  const VendorProfileScreen({super.key});

  @override
  State<VendorProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<VendorProfileScreen> {
  bool isWalletExpanded = false;

  @override
  void initState() {
    super.initState();
    // Fetch local data once after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardProvider>(context, listen: false)
          .getCustomerDatafromLocal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (context, provider, child) {
      return Scaffold(
        backgroundColor: AppColors.ghostWhite,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: HeaderTextWhite("User Profile"),
          backgroundColor: AppColors.primary,
          // elevation: 3,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                // User Profile Card
                UserProfileCard(
                  name: provider.fullName,
                  mobile: provider.user_mobile_no ?? '',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ShowUserProfileScreen()),
                  ),
                ),
                const SizedBox(height: 10),
                // Menu Options
                Expanded(
                  child: ListView(
                    children: [
                      // Custom Menu
                      // UiUtils().menuItem(context, "My Profile", Icons.person_outline),
                      // UiUtils().menuItem(
                      //     context, "Products", Icons.payment_outlined),
                      // UiUtils().menuItem(
                      //     context, "Customers", Icons.people_alt_outlined),
                      // UiUtils().menuItem(
                      //     context, "Allocations", Icons.assignment_outlined),
                      UiUtils().VendormenuItem(
                          context, "Contact Us", Icons.connect_without_contact),
                      SizedBox(
                        height: 4,
                      ),
                      UiUtils().VendormenuItem(context, "Terms & Conditions",
                          Icons.description_outlined),
                      SizedBox(
                        height: 4,
                      ),
                      UiUtils().VendormenuItem(context, "Privacy Policies",
                          Icons.privacy_tip_outlined),
                      SizedBox(
                        height: 4,
                      ),
                      UiUtils().VendormenuItem(
                          context, "About Us", Icons.info_outline),
                      const LogoutButton(),
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
