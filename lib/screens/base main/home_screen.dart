import 'package:flutter/material.dart';
import 'package:qt_distributer/constants/app_assets.dart';
import 'package:qt_distributer/constants/app_colors.dart';
import 'package:qt_distributer/screens/base%20main/agents_screen.dart';
import 'package:qt_distributer/screens/base%20main/dashboard_screen.dart';
import 'package:qt_distributer/screens/base%20main/payments_screen.dart';
import 'package:qt_distributer/screens/base%20main/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

   List<Widget> _pages = [
    DashboardScreen(),
    PaymentsScreen(),
    AgentsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.secondary,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              AppAssets.dashboardIcon, // Adjust path if needed
              width: 24,
              height: 24,
            ),
            label: 'Dashboard',
          ),
           BottomNavigationBarItem(
            icon: Image.asset(
              AppAssets.paymentIcon, // Adjust path if needed
              width: 24,
              height: 24,
            ),
            label: 'Payments',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              AppAssets.realStateSellerIcon, // Adjust path if needed
              width: 24,
              height: 24,
            ),
            label: 'Agents',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              AppAssets.userIcon, // Adjust path if needed
              width: 24,
              height: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
