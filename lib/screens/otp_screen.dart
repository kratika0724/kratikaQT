import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../constants/app_assets.dart';
import '../constants/app_textstyles.dart';
import 'base main/home_screen.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPScreen({super.key, required this.phoneNumber});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> _controllers = List.generate(5, (_) => TextEditingController(),);
  final List<FocusNode> _focusNodes = List.generate(5,  (_) => FocusNode(),);
  int _remainingTime = 60;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  // void _onChanged(String value, int index) {
  //   if (value.isNotEmpty && index < 4) {
  //     _focusNodes[index + 1].requestFocus();
  //   } else if (value.isEmpty && index > 0) {
  //     _focusNodes[index - 1].requestFocus();
  //   }
  // }
  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 4) {
      setState(() {
        _focusNodes[index + 1].requestFocus();
      });
    } else if (value.isEmpty && index > 0) {
      setState(() {
        _focusNodes[index - 1].requestFocus();
      });
    }
  }


  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
        _startTimer();
      }
    });
  }

  void _handleOTPVerification() async {
    String otp = _controllers.map((c) => c.text).join();
    if (otp.length != 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter complete 5-digit OTP'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.verifyOtp(widget.phoneNumber, otp);

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error ?? 'Failed to verify OTP'),
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

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.ghostWhite,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'), // Change path if needed
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
                  padding: const EdgeInsets.symmetric(vertical: 24.0,horizontal: 5),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              onPressed: (){Navigator.pop(context);},
                              icon: Icon(Icons.arrow_back,color: Colors.black,)
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Image.asset(AppAssets.logo, width: 200, height: 200),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Enter Verification Code',
                              style: boldTextStyle(
                                fontSize: dimen24,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'We have sent a verification code to- \n${widget.phoneNumber}',
                              style: mediumTextStyle(
                                fontSize: dimen16,
                                color: Colors.grey,
                              ),
                              // textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(5, (index) => SizedBox(
                            width: 60,
                            child: TextField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(1),
                              ],
                              decoration: InputDecoration(
                                counterText: '',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors.inputBorder,
                                    width: 2,
                                  ),
                                ),
                              ),
                              onChanged: (value) => _onChanged(value, index),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      if (_remainingTime > 0)
                        Text(
                          'Resend OTP in $_remainingTime seconds',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        )
                      else
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _remainingTime = 60;
                            });
                            _startTimer();
                          },
                          child: const Text(
                            'Resend OTP',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const SizedBox(height: 30),
                      // Container(
                      //   width: double.infinity,
                      //   decoration: BoxDecoration(
                      //     gradient: LinearGradient(
                      //       colors: [
                      //         AppColors.primary,
                      //         Colors.indigo.withOpacity(0.8),
                      //       ],
                      //       begin: Alignment.centerLeft,
                      //       end: Alignment.centerRight,
                      //     ),
                      //     borderRadius: BorderRadius.circular(10),
                      //   ),
                      //   child: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //       backgroundColor: Colors.transparent,
                      //       shadowColor: Colors.transparent,
                      //       padding:
                      //       const EdgeInsets.symmetric(
                      //           horizontal: 16, vertical: 6),
                      //       shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(10)),
                      //     ),
                      //     onPressed: authProvider.isLoading
                      //         ? null
                      //         : _handleLogin,
                      //     child: authProvider.isLoading
                      //         ? const SizedBox(
                      //       height: 20,
                      //       width: 10,
                      //       child: CircularProgressIndicator(
                      //         strokeWidth: 2,
                      //         valueColor: AlwaysStoppedAnimation<Color>(
                      //             AppColors.buttonText),
                      //       ),
                      //     )
                      //         : Text('Get OTP',
                      //         style: boldTextStyle(
                      //             fontSize: dimen20, color: Colors.white)),
                      //   ),
                      // ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              Colors.indigo.withOpacity(0.8),
                            ],),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ElevatedButton(
                          onPressed:
                          authProvider.isLoading ? null : _handleOTPVerification,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding:
                            const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: authProvider.isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.buttonText),
                            ),
                          )
                              : const Text(
                            'Verify OTP',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      SizedBox(height: 250,),
                    ],
                  ),
                ),
              ),
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
            ]
        ),
      ),
    );
  }
}