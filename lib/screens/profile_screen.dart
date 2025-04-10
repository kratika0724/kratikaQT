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
import '../utils/ui_utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('User Profile'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: 10,),
              // // Header
              // Container(
              //   color:Colors.white,
              //   padding: const EdgeInsets.symmetric(horizontal: 0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 16),
              //         child: Text(
              //           'User Profile',
              //           style: TextStyle(
              //               fontSize: 24,
              //               fontWeight: FontWeight.bold,
              //               color: Colors.black54),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Divider(thickness: 1, color: Colors.grey.shade200),
              // const SizedBox(height: 20),

              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return  LinearGradient(
                            colors: [Colors.indigo.shade900, Colors.blue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds);
                        },
                        child: const Icon(
                          Icons.person,
                          size: 70,
                          color: Colors.white, // This color becomes the base for the gradient
                        ),
                      ),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("User Name",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black,fontWeight: FontWeight.w600)),
                          SizedBox(height: 5,),
                          Text("9165329901",
                              style:
                              TextStyle(fontSize: 14, color: Colors.black)),
                        ],
                      )
                    ],
                  ),
                ),
                // child: ListTile(
                //   leading: ShaderMask(
                //     shaderCallback: (Rect bounds) {
                //       return  LinearGradient(
                //         colors: [Colors.indigo.shade900, Colors.blue],
                //         begin: Alignment.topLeft,
                //         end: Alignment.bottomRight,
                //       ).createShader(bounds);
                //     },
                //     child: const Icon(
                //       Icons.person,
                //       size: 50,
                //       color: Colors.white, // This color becomes the base for the gradient
                //     ),
                //   ),
                //   title: Text("User Name",
                //       style: TextStyle(
                //           fontSize: 15, color: Colors.black)),
                //   subtitle: Text("9165329901",
                //       style:
                //       TextStyle(fontSize: 14, color: Colors.black)),
                // ),
              ),
              const SizedBox(height: 10),

              // Menu Options
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView(
                    children: [
                      UiUtils().menuItem(context,"My Profile", Icons.person_outline),
                      UiUtils().menuItem(context,"Services", Icons.description_outlined),
                      UiUtils().menuItem(context,"Allocations", Icons.assignment_outlined),
                      UiUtils().menuItem(context,"Payments", Icons.payment_outlined),
                      const Divider(height: 40),
                      UiUtils().menuItem(context,"Help Center", Icons.headset_mic_outlined),
                      UiUtils().menuItem(context,"Terms & Conditions", Icons.description_outlined),
                      UiUtils().menuItem(context,"Privacy Policies", Icons.privacy_tip_outlined),
                      UiUtils().menuItem(context,"About Us" , Icons.info_outline),
                      const SizedBox(height: 30),
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
                                  style: TextStyle(fontSize:14,fontWeight: FontWeight.bold,color: Colors.white)),
                            ),
                            style: ElevatedButton.styleFrom(
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
