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
        body: Column(
          children: [
            // Container(
            //
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       begin: Alignment.topCenter,
            //       end: Alignment.bottomCenter,
            //       colors: [
            //         AppColors.primary.withOpacity(0.95),
            //         AppColors.primary.withOpacity(0.75),
            //       ],
            //     ),
            //     borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
            //   ),
            //
            //   padding: const EdgeInsets.symmetric(vertical: 24),
            //   child: Column(
            //     children: [
            //       const CircleAvatar(
            //         radius: 40,
            //         backgroundColor: Colors.white,
            //         child: Icon(Icons.person, size: 50, color: Colors.black),
            //       ),
            //       const SizedBox(height: 12),
            //       Text("Mahmud Nik", style: mediumTextStyle(fontSize: dimen18, color: Colors.white)),
            //       const SizedBox(height: 4),
            //       Text("ID: 524869795", style: regularTextStyle(fontSize: dimen14, color: Colors.white70)),
            //     ],
            //   ),
            // ),
            Container(
              height: MediaQuery.of(context).size.height * 0.3, // 30% of screen height
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withOpacity(0.65),
                    AppColors.primary.withOpacity(0.95),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              padding: const EdgeInsets.only(top: 44),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 24,)
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.height * 0.1, // Set width for the container
                    height: MediaQuery.of(context).size.height * 0.1, // Set height for the container
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30), // Circular border radius
                    ),
                    child: const Icon(Icons.person, size: 50, color: Colors.black), // Icon inside the container
                  ),
                  const SizedBox(height: 12),
                  Text(provider.fullName, style: boldTextStyle(fontSize: dimen24, color: Colors.white,latterSpace: 1.0)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildProfileTile(Icons.account_circle, "Role", provider.user_role_name!),
            _buildProfileTile(Icons.work_outline,"Role ID",provider.user_role!),
            _buildProfileTile(Icons.account_box_outlined, "Customer ID", provider.user_customer_id!),
            _buildProfileTile(Icons.person_outline,"User ID", provider.user_id!),
            _buildProfileTile(Icons.wifi_calling_3,"Mobile No.", provider.user_mobile_no!),
            _buildProfileTile(Icons.email_outlined,"Email ", provider.user_email_id!),
            // _buildContactTile(provider.user_mobile_no!, provider.user_email_id!),
          ],
        ),
      );
    });


  }

  Widget _buildContactTile(String number, String email) {
    return Card(
      elevation: 0,
      color: AppColors.ghostWhite, // GhostWhite color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 12.0),
        child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.record_voice_over, color: AppColors.primary),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Contact Details ", style: mediumTextStyle(fontSize: dimen15, color: Colors.black)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              contactInfoRow(
                Icons.phone,
                number,
                onTap: () {
                  // Handle tap
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Divider(thickness: 0.3,color: Colors.grey.shade300,),
              ),
              contactInfoRow(
                Icons.email,
                email,
                onTap: () {
                  // Handle tap
                },
              ),

            ]
        ),
      ),
    );
  }

  Widget contactInfoRow(IconData icon, String number, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 40.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary,size: 20,),
            const SizedBox(width: 10),
            Text(number, style: semiBoldTextStyle(fontSize: dimen15, color: Colors.black)),
            // const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile(IconData icon, String label, String value) {
    return Card(
      elevation: 0,
      color: AppColors.grey50, // GhostWhite color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 16),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("$label -  ",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: mediumTextStyle(fontSize: dimen15, color: Colors.black)),
                  Text(value, overflow: TextOverflow.ellipsis,
                      maxLines: 1,style: mediumTextStyle(fontSize: dimen15, color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
