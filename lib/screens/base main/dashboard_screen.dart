import 'package:fl_chart/fl_chart.dart';
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

    return Scaffold(
      backgroundColor: AppColors.ghostWhite.withOpacity(0.7),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: HeaderTextBlack("Dashboard"),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        // elevation: 3,
        actions: [
          GestureDetector(
            onTap: (){},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: AppColors.primary.withOpacity(0.1),
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
                  color: AppColors.primary.withOpacity(0.1),
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
            ? Center(child: Text("Oops! Something went wrong"))
            : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10.0),
                child: Column(
                  children: [
                    // PAYMENTS
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white,
                      ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "Payments",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:  boldTextStyle(
                                        fontSize: dimen18,
                                        color: Colors.black,
                                        latterSpace: 1.0,
                                      ),
                                    ),

                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6.0,horizontal: 8),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                    child: _buildCardSuccessPayments('Successful', '₹ 5009', Colors.green, Icons.check_circle_rounded, 1.0)
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0,right: 8.0,top:6),
                                child: GridView.count(
                                  shrinkWrap: true,
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8.0,
                                  mainAxisSpacing: 10.0,
                                  childAspectRatio: 1.9,
                                  children: [
                                    _buildCardPayments('Pending', '₹ 7261', Color(0xfff59d1b),Icons.error,0.7),
                                    _buildCardPayments('Failed', '₹ 4025', Color(0xfffd6363),Icons.cancel,0.5),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5,),
                            ],
                          ),
                        ),
                    ),
                    // OVERVIEW
                    const SizedBox(height: 10,),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "Overview",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:  boldTextStyle(
                                      fontSize: dimen18,
                                      color: Colors.black,
                                      latterSpace: 1.0,
                                    ),
                                  ),

                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0,horizontal: 4.0),
                              child: SizedBox(
                                height: 110, // Set a fixed height for all cards
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _buildCard(
                                        'User\nCount',
                                        '${dashboardProvider.userCount}',
                                        AppColors.primary,
                                        Icons.analytics_outlined,
                                        1.0,
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Expanded(
                                      child: _buildCard(
                                        'Customer\nCount',
                                        '0',
                                        AppColors.primary,
                                        Icons.analytics_outlined,
                                        1.0,
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Expanded(
                                      child: _buildCard(
                                        'Product\nCount',
                                        '${dashboardProvider.productCount}',
                                        AppColors.primary,
                                        Icons.analytics_outlined,
                                        1.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //GRAPH
                    const SizedBox(height: 10,),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12.0,bottom: 12.0,left: 8,right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "Overview",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:  boldTextStyle(
                                      fontSize: dimen18,
                                      color: Colors.black,
                                      latterSpace: 1.0,
                                    ),
                                  ),

                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 200,
                              child: LineChart(
                                LineChartData(
                                  gridData: FlGridData(show: false),
                                  borderData: FlBorderData(
                                    show: true,
                                    border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                                  ),
                                  titlesData: FlTitlesData(
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 30,
                                        interval: 1,
                                        getTitlesWidget: (value, meta) {
                                          // Generate last 7 dates from today
                                          final now = DateTime.now();
                                          final List<String> last7Days = List.generate(7, (index) {
                                            final date = now.subtract(Duration(days: 6 - index));
                                            return "${date.day.toString().padLeft(2, '0')} ${_monthShort(date.month)}";
                                          });

                                          int index = value.toInt();
                                          return Text(
                                            index >= 0 && index < last7Days.length ? last7Days[index] : '',
                                            style: const TextStyle(fontSize: 10, color: Colors.black),
                                          );
                                        },
                                      ),
                                    ),

                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        interval: 20,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            '${value.toInt()}',
                                            style: TextStyle(fontSize: 10,color: Colors.black),
                                          );
                                        },
                                      ),
                                    ),
                                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  ),
                                  lineBarsData: [
                                    _buildLineBarData([10, 20, 30, 25, 35, 40], Colors.green),
                                    _buildLineBarData([12, 24, 20, 30, 28, 22], Colors.amberAccent),
                                    _buildLineBarData([7, 15, 17, 22, 20, 27], Colors.red.shade600),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildLegend(Colors.green, "Users"),
                                    SizedBox(width: 10),
                                    _buildLegend(Colors.amberAccent, "Products"),
                                    SizedBox(width: 10),
                                    _buildLegend(Colors.red, "Payments"),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
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

  LineChartBarData _buildLineBarData(List<double> values, Color color) {
    return LineChartBarData(
      isCurved: false,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: values
          .asMap()
          .entries
          .map((e) => FlSpot(e.key.toDouble(), e.value))
          .toList(),
    );
  }

  Widget _buildLegend(Color color, String title) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        SizedBox(width: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title,
            style: regularTextStyle(fontSize: dimen12, color: Colors.black),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildCard(String title, String count, Color color, IconData checkCircle, double value) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: AppColors.primary.withOpacity(0.1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10,),
            Text(
              count,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: semiBoldTextStyle(
                fontSize: dimen20,
                color: AppColors.secondary,
              ),
            ),
            Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: mediumTextStyle(
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
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: color.withOpacity(0.2),
        ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6), // Rounded corners
                    ),
                  ),
                  Icon(
                    checkCircle,
                    color: color,
                    size: 23,
                  ),
                ],
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    amount,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: semiBoldTextStyle(
                      fontSize: dimen18,
                      color: AppColors.secondary,
                    ),
                  ),
                  Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: semiBoldTextStyle(
                          fontSize: dimen16,
                          color: AppColors.secondary,
                          // latterSpace: 1.5
                      )),
                ],
              ),
            ),
            // SizedBox(height: 10,),
          ],
        ),
      ));
  }

  Widget _buildCardSuccessPayments(String title, String amount, Color color, IconData checkCircle, double value) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Color(0xff13c898).withOpacity(0.1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 3,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(width: 50,),
                      Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: boldTextStyle(
                            fontSize: dimen16,
                            color: Colors.green.shade900,
                              latterSpace: 1.5
                          )),
                      Text(
                        amount,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: semiBoldTextStyle(
                          fontSize: dimen18,
                          color: Colors.green.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6), // Rounded corners
                        ),
                      ),
                      Icon(
                        checkCircle,
                        color: Color(0xff1c5e20),
                        size: 34,
                      ),
                    ],
                  ),
                ),
              ),
              // SizedBox(height: 10,),

            ],
          ),
        ));
  }
}

String _monthShort(int month) {
  const monthNames = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
  ];
  return monthNames[month - 1];
}


