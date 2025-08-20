import 'package:flutter/material.dart';
import 'package:qt_distributer/constants/app_colors.dart';
import 'package:qt_distributer/constants/commonString.dart';
import 'package:qt_distributer/screens/base%20main/vendor/customers_screen.dart';
import 'package:qt_distributer/screens/base%20main/vendor/vendor_dashboard_screen.dart';
import 'package:qt_distributer/screens/base%20main/vendor/vendor_payments_screen.dart';
import 'package:qt_distributer/screens/base%20main/vendor/vendor_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  List<Widget> non_distributer_pages = [
    VendorDashboardScreen(),
    VendorPaymentsScreen(),
    CustomersScreen(),
    VendorProfileScreen(),
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
        children: non_distributer_pages,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 13,
        unselectedFontSize: 13,
        onTap: _onItemTapped,
        items: is_distributer
            ? const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.payment),
                  label: 'Payments',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Agents',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: 'Profile',
                ),
              ]
            : const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.assignment),
                  label: 'Payments',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Customers',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: 'Profile',
                ),
              ],
      ),
    );
  }
}
