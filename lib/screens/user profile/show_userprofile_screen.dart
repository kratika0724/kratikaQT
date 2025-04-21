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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 275,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary.withOpacity(0.65),
                      Colors.indigo.withOpacity(0.95),
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                ),
                padding: const EdgeInsets.only(top: 35),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(), // Pushes content towards center vertically
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
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
                            fontSize: dimen24,
                            color: Colors.white,
                            latterSpace: 1.0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildProfileTile(Icons.account_circle, "Role", provider.user_role_name ?? ''),
              // _buildProfileTile(Icons.work_outline, "Role ID", provider.user_role ?? ''),
              _buildProfileTile(Icons.document_scanner_outlined, "Customer ID", provider.user_customer_id ?? ''),
              // _buildProfileTile(Icons.document_scanner_outlined, "User ID", provider.user_id ?? ''),
              _buildProfileTile(Icons.wifi_calling_3, "Mobile No.", provider.user_mobile_no ?? ''),
              _buildProfileTile(Icons.email_outlined, "Email ", provider.user_email_id ?? ''),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildProfileTile(IconData icon, String label, String value) {
    return Card(
      elevation: 0,
      color: AppColors.primary.withOpacity(0.06),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(icon, color: AppColors.primary),
                )),
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
                            style: mediumTextStyle(fontSize: dimen15, color: Colors.black)),
                      ),
                    ),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          value,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: mediumTextStyle(fontSize: dimen15, color: Colors.black),
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
