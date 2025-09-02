import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_assets.dart';
import '../../constants/app_textstyles.dart';
import '../../providers/auth_provider.dart';
import '../otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.sendOtp(_phoneController.text);

      if (!mounted) return;

      if (success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPScreen(phoneNumber: _phoneController.text),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error ?? 'Failed to send OTP'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.ghostWhite,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/background.png'), // Change path if needed
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Positioned(
            //   top: -300,
            //   child: Align(
            //     alignment: Alignment.bottomCenter,
            //     child: Container(
            //       height: 500,
            //       width: 500,
            //       decoration: BoxDecoration(
            //         shape: BoxShape.circle,
            //         gradient: RadialGradient(
            //           colors: [
            //             AppColors.primary.withOpacity(0.2),
            //             AppColors.primary.withOpacity(0.01),
            //             Colors.transparent,
            //           ],
            //           radius: 0.9,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.only(right: 24.0, left: 24.0, top: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Image.asset(AppAssets.logo, width: 200, height: 50),
                          Text("Agents",
                              style: semiBoldTextStyle(
                                fontSize: dimen16,
                                color: Colors.black,
                              ))
                        ],
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Sign in to your Account',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: boldTextStyle(
                                  fontSize: dimen24,
                                  color: Colors.black,
                                  latterSpace: 0.2)),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Enter your phone number',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: mediumTextStyle(
                                  fontSize: dimen15, color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Mobile Number',
                          labelStyle:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                          hintText: 'Enter 10 digit mobile number',
                          hintStyle:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your mobile number';
                          }
                          if (value.length != 10) {
                            return 'Please enter a valid 10 digit mobile number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              Colors.indigo.withOpacity(0.8),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed:
                              authProvider.isLoading ? null : _handleLogin,
                          child: authProvider.isLoading
                              ? const SizedBox(
                                  // height: 20,
                                  width: 15,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.buttonText),
                                  ),
                                )
                              : Text('Get OTP',
                                  style: boldTextStyle(
                                      fontSize: dimen18, color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 400),
                    ],
                  ),
                ),
              ),
            ),

            /// Faded circle at the bottom
            // Positioned(
            //   bottom: -200,
            //   child: Align(
            //     alignment: Alignment.bottomCenter,
            //     child: Container(
            //       height: 300,
            //       width: 300,
            //       decoration: BoxDecoration(
            //         shape: BoxShape.circle,
            //         gradient: RadialGradient(
            //           colors: [
            //             AppColors.primary.withOpacity(0.2),
            //             AppColors.primary.withOpacity(0.01),
            //             Colors.transparent,
            //           ],
            //           radius: 0.9,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.center,
//             colors: [
//               Color(0xFFCCE9FF), // Light sky blue
//               Color(0xFFFFFFFF), // White
//             ],
//             stops: [0.1,0.4],
//           ),
//         ),
//         child: Stack(
//           children: [
//           SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 24.0,left: 24.0,top:50.0),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         const SizedBox(height: 60),
//                         // Distributor Logo
//                         Image.asset(
//                           AppAssets.logo,
//                           width: 200,
//                           height: 200,
//                         ),
//                         const SizedBox(height: 50),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Sign in to your Account',
//                               style: boldTextStyle(
//                                 fontSize: dimen24,
//                                 color: Colors.black,
//                                 latterSpace: 0.2
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 5),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Enter your phone number',
//                               style: mediumTextStyle(
//                                 fontSize: dimen15,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 30),
//                         TextFormField(
//                           controller: _phoneController,
//                           keyboardType: TextInputType.phone,
//                           inputFormatters: [
//                             FilteringTextInputFormatter.digitsOnly,
//                             LengthLimitingTextInputFormatter(10),
//                           ],
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: AppColors.textPrimary,
//                           ),
//                           decoration: InputDecoration(
//                             labelText: 'Mobile Number',
//                             labelStyle: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey,
//                             ),
//                             hintText: 'Enter 10 digit mobile number',
//                             hintStyle: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey,
//                             ),
//                             // prefixIcon: Icon(
//                             //   Icons.phone,
//                             //   color: AppColors.secondary,
//                             //   size: 20,
//                             // ),
//                             contentPadding: EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 16,
//                             ),
//                             fillColor: Colors.white,
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your mobile number';
//                             }
//                             if (value.length != 10) {
//                               return 'Please enter a valid 10 digit mobile number';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 30),
//                     Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         gradient:  LinearGradient(
//                           colors: [AppColors.primary, AppColors.primary.withOpacity(0.6),],
//                           begin: Alignment.centerLeft,
//                           end: Alignment.centerRight,
//                         ),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.transparent,
//                           shadowColor: Colors.transparent,
//                           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                         ),
//                         onPressed: authProvider.isLoading ? null : _handleLogin,
//                         child: authProvider.isLoading
//                             ? const SizedBox(
//                           height: 20,
//                           width: 10,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                                 AppColors.buttonText),
//                           ),
//                         )
//                             : Text(
//                             'Get OTP',
//                             style: boldTextStyle(fontSize: dimen20, color: Colors.white)
//                         ),
//                       ),
//                     )],),),),),
//             Positioned(
//               bottom: -500, // Pull it partially outside the screen for a subtle fade
//               left: -50,
//               right: -50,
//               child: Container(
//                 width: 1000,
//                 height: 1000,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: RadialGradient(
//                     colors: [
//                       AppColors.primary.withOpacity(0.3),
//                       Colors.white.withOpacity(0.1),
//                       Colors.white,
//                     ],
//                     center: Alignment.center,
//                     radius: 0.8,
//                   ),
//                 ),
//               ),
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }
