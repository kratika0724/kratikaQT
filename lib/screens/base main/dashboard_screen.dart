import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qt_distributer/constants/app_textstyles.dart';
import 'package:qt_distributer/widgets/common_text_widgets.dart';
import '../../constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final token = authProvider.loginResponse?.accessToken ?? '';
      if (token.isNotEmpty) {
        final provider = Provider.of<DashboardProvider>(context, listen: false);
        provider.fetchUserCountData(token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);
    final userCount = dashboardProvider.userCountData;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: HeaderTextThemeSecondary("Dashboard"),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 3,
        actions: [
          GestureDetector(
            onTap: (){},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7.0),
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: Colors.transparent,
                  border: Border.all(color: AppColors.secondary),
                ),
                child: Icon(
                  Icons.notifications_none,
                  color: AppColors.secondary,
                  size: 18,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){

            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: Colors.transparent,
                  border: Border.all(color: AppColors.secondary),
                ),
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: [Colors.amber, Colors.amberAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: Icon(Icons.person, size: 20,color: Colors.yellow.shade500,),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: dashboardProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : dashboardProvider.error != null
            ? Center(child: Text(dashboardProvider.error!))
            : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 16.0),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.secondary,AppColors.primary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        color: AppColors.secondary.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(25),
                      ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 6.0,bottom: 0,left: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Payments",
                                      style: boldTextStyle(fontSize: dimen18, color: Colors.white, latterSpace: 2.0),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6.0,horizontal: 8),
                                child: Container(
                                  width: double.infinity,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                    child: _buildCardSuccessPayments('Successful', '₹ 5009', Colors.green, Icons.check, 1.0)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                child: GridView.count(
                                  shrinkWrap: true,
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 2.0,
                                  mainAxisSpacing: 10.0,
                                  childAspectRatio: 1.5,
                                  children: [
                                    _buildCardPayments('Pending', '₹ 7261', Colors.amber,Icons.error,0.7),
                                    _buildCardPayments('Failed', '₹ 4025', Colors.red,Icons.cancel,0.5),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                            ],
                          ),
                        ),
                    ),
                    const SizedBox(height: 15,),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.secondary,AppColors.primary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        color: AppColors.secondary.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0,bottom: 8,left: 6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Overview",
                                    style: boldTextStyle(fontSize: dimen20, color: Colors.white, latterSpace: 2.0),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 120, // Set a fixed height for all cards
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _buildCard(
                                      'User\nCount',
                                      '${userCount?.total ?? 0}',
                                      AppColors.primary,
                                      Icons.analytics_outlined,
                                      1.0,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildCard(
                                      'Customer\nCount',
                                      '0',
                                      AppColors.primary,
                                      Icons.analytics_outlined,
                                      1.0,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildCard(
                                      'Product\nCount',
                                      '0',
                                      AppColors.primary,
                                      Icons.analytics_outlined,
                                      1.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15,),
                          ],
                        ),
                      ),
                    ),
                    // const SizedBox(height: 15,),
                    // Container(
                    //   width: double.infinity,
                    //   decoration: BoxDecoration(
                    //     gradient: LinearGradient(
                    //       colors: [AppColors.secondary,AppColors.primary],
                    //       begin: Alignment.topLeft,
                    //       end: Alignment.bottomRight,
                    //     ),
                    //     color: AppColors.secondary.withOpacity(0.9),
                    //     borderRadius: BorderRadius.circular(25),
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 0),
                    //     child: Column(
                    //       children: [
                    //         Padding(
                    //           padding: const EdgeInsets.only(top: 10.0,bottom: 8,left: 6),
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.start,
                    //             children: [
                    //               Text(
                    //                 "Overview",
                    //                 style: boldTextStyle(fontSize: dimen20, color: Colors.white, latterSpace: 2.0),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //
                    //         GridView.count(
                    //           shrinkWrap: true,
                    //           crossAxisCount: 2,
                    //           crossAxisSpacing: 8.0,
                    //           mainAxisSpacing: 8.0,
                    //           childAspectRatio: 1.2,
                    //           children: [
                    //             _buildCard(
                    //               'User Count',
                    //               '${userCount?.total ?? 0}',
                    //               AppColors.primary,
                    //               Icons.analytics_outlined,
                    //               1.0,
                    //             ),
                    //             _buildCard(
                    //               'Product Count',
                    //               '0',
                    //               AppColors.primary,
                    //               Icons.analytics_outlined,
                    //               1.0,
                    //             ),
                    //             _buildCard(
                    //               'Customer Count',
                    //               '0',
                    //               AppColors.primary,
                    //               Icons.analytics_outlined,
                    //               1.0,
                    //             ),
                    //           ],
                    //         ),
                    //
                    //         SizedBox(height: 15,),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildCard(String title, String count, Color color, IconData checkCircle, double value) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          // border: Border.all(color: AppColors.secondary)
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 10,),
            Text(
              count,
              textAlign: TextAlign.center,
              style: semiBoldTextStyle(
                fontSize: dimen24,
                color: AppColors.secondary,
              ),
            ),
            Text(
                title,
                textAlign: TextAlign.center,
                style: semiBoldTextStyle(
                  fontSize: dimen14,
                  color: AppColors.secondary,
                )),
            // const SizedBox(height: 8),

            // const SizedBox(height: 10),
            // Stack(
            //   alignment: Alignment.center,
            //   children: [
            //     SizedBox(
            //       height: 30,
            //       width: 30,
            //       child: CircularProgressIndicator(
            //         strokeWidth: 1,
            //         value: value,
            //         valueColor: AlwaysStoppedAnimation<Color>(color),
            //         backgroundColor: color.withOpacity(0.1),
            //       ),
            //     ),
            //     Icon(
            //       checkCircle,
            //       color: color,
            //       size: 20,
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardPayments(String title, String amount, Color color, IconData checkCircle, double value) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.6),color.withOpacity(0.4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
        child : Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                      ),
                    ),
                    Icon(
                      checkCircle,
                      color: color,
                      size: 15,
                    ),
                  ],
                ),
              ],
            ),
            Text(
              amount,
              style: semiBoldTextStyle(
                fontSize: dimen24,
                color: AppColors.secondary,
              ),
            ),

            Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: boldTextStyle(
                    fontSize: dimen14,
                    color: AppColors.secondary,
                    latterSpace: 1.5
                )),
            // SizedBox(height: 10,),

          ],
        ),

    ));
  }

  Widget _buildCardSuccessPayments(String title, String amount, Color color, IconData checkCircle, double value) {
    return Card(
        elevation: 4,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.7), color.withOpacity(0.5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.all(16),
          child : Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(width: 50,),
                  Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: boldTextStyle(
                        fontSize: dimen18,
                        color: Colors.green.shade900,
                          latterSpace: 1.5
                      )),
                  Text(
                    amount,
                    style: semiBoldTextStyle(
                      fontSize: dimen24,
                      color: Colors.green.shade900,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 70,
                    width: 70,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: value,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade800),
                      backgroundColor: Colors.green.shade800.withOpacity(0.1),
                    ),
                  ),
                  Icon(
                    checkCircle,
                    color: Colors.green.shade800,
                    size: 40,
                  ),
                ],
              ),


              // SizedBox(height: 10,),

            ],
          ),

        ));
  }
}

