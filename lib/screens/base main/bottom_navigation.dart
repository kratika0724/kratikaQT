import 'package:flutter/material.dart';
import 'package:qt_distributer/screens/base%20main/payments_screen.dart';
import 'dashboard_screen.dart';
import 'allocations_screen.dart';
import 'customer_screen.dart';
import 'agents_screen.dart';
import 'profile_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _selectedIndex = 0;

  List<Widget> _screens = [
    DashboardScreen(),
     PaymentsScreen(),
    CustomerScreen(),
     AgentsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items:  [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Payments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Customer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Agents',
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
