// import 'package:flutter/material.dart';
//
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: const Center(
//         child: Text('Profile Content'),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:qt_distributer/constants/app_colors.dart';
import '../../utils/ui_utils.dart';
import '../../constants/app_textstyles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ghostWhite,
      appBar: AppBar(
        title: Text(
          'User Profile',
          style: headTextStyle(
            fontSize: dimen20,
            color: AppColors.primary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.indigo.shade900, Colors.blue.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return  LinearGradient(
                              colors: [Colors.amber, Colors.white],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds);
                          },
                          child: const Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.white, // This color becomes the base for the gradient
                          ),
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("User Name",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: semiBoldTextStyle(
                                      fontSize: dimen15, color: Colors.white)),
                              SizedBox(height: 5,),
                              Text("9165329901",
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ListView(
                    children: [
                      UiUtils().menuItem(context,"My Profile", Icons.person_outline),
                      UiUtils().menuItem(context,"Services", Icons.description_outlined),
                      UiUtils().menuItem(context,"Allocations", Icons.assignment_outlined),
                      UiUtils().menuItem(context,"Payments", Icons.payment_outlined),
                      SizedBox(height: 15,),
                      Card(
                        color: Colors.white,
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 12,left: 2,right: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 10),
                          child: Column(
                            children: [
                              UiUtils().menuItemBase(context,"Help Center", Icons.headset_mic_outlined),
                              Divider(thickness: 0.4,color: Colors.grey.shade300,),
                              UiUtils().menuItemBase(context,"Terms & Conditions", Icons.description_outlined),
                              Divider(thickness: 0.4,color: Colors.grey.shade300,),
                              UiUtils().menuItemBase(context,"Privacy Policies", Icons.privacy_tip_outlined),
                              Divider(thickness: 0.4,color: Colors.grey.shade300,),
                              UiUtils().menuItemBase(context,"About Us" , Icons.info_outline),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Center(child: SizedBox(
                          width: double.infinity,
                          // Makes the button occupy full width
                          child: ElevatedButton.icon(
                            onPressed: () {
                              showDialog(
                                  context: context, // Ensure you pass the correct BuildContext here
                                  builder: (BuildContext context){
                                    return AlertDialog(
                                      // backgroundColor: white,
                                      title: Text(
                                        "Logging Out!",
                                        // style: semiBoldTextStyle(
                                        //   color : black,
                                        //   fontSize: dimen20,
                                        // ),
                                      ),
                                      content: Text(
                                        "Are you sure you want to logout?",
                                        // style: regularTextStyle(
                                        //   color : black,
                                        //   fontSize: dimen15,
                                        // ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text(
                                            'NO',
                                            style: TextStyle(
                                              color :Colors.black,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text(
                                            'YES',
                                            style: TextStyle(
                                              color :Colors.black,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            icon: Icon(Icons.logout, color:  Colors.white),
                            label: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text("Logout",
                                  style: semiBoldTextStyle(fontSize: dimen14, color: Colors.white)),
                            ),
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              shadowColor: Colors.black.withOpacity(0.3),
                              side: BorderSide(color:  Colors.white),
                              padding: EdgeInsets.symmetric(vertical: 8),
                              // Internal padding
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10), // Corner radius
                              ),
                            ),
                          ),
                        ),),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
