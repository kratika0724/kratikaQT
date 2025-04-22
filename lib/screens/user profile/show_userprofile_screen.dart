import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_textstyles.dart';
import '../../providers/dashboard_provider.dart';

class ShowUserProfileScreen extends StatefulWidget {
  const ShowUserProfileScreen({super.key});

  @override
  State<ShowUserProfileScreen> createState() => _ShowUserProfileScreenState();
}

class _ShowUserProfileScreenState extends State<ShowUserProfileScreen> {
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
          automaticallyImplyLeading: true,
          // title: const Text("Profile"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Card(
              color: AppColors.primary.withOpacity(0.02),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side:BorderSide(color: AppColors.primary, width: 0.5),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [ // Pushes content towards center vertically
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: provider.user_profile_img != null && provider.user_profile_img!.isNotEmpty
                            ? Image.network(
                          provider.user_profile_img!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 40, color: Colors.black),
                        )
                            : const Icon(Icons.person, size: 40, color: Colors.black),
                      ),
                    ),

                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          provider.fullName,
                          style: boldTextStyle(
                            fontSize: dimen22,
                            color: Colors.black,
                            latterSpace: 1.0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                    _buildProfileTile(Icons.person_outline, "Role", provider.user_role_name ?? ''),
                    // _buildProfileTile(Icons.work_outline, "Role ID", provider.user_role ?? ''),
                    _buildProfileTile(Icons.document_scanner_outlined, "Customer ID", provider.user_customer_id ?? ''),
                    // _buildProfileTile(Icons.document_scanner_outlined, "User ID", provider.user_id ?? ''),
                    _buildProfileTile(Icons.wifi_calling_3_outlined, "Mobile No.", provider.user_mobile_no ?? ''),
                    _buildProfileTile(Icons.email_outlined, "Email ", provider.user_email_id ?? ''),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildProfileTile(IconData icon, String label, String value) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(icon, color: AppColors.primary),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text("$label - ",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: semiBoldTextStyle(fontSize: dimen14, color: Colors.black)),
                      ),
                    ),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          value,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: semiBoldTextStyle(fontSize: dimen14, color: Colors.black),
                        ),
                      ),
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
