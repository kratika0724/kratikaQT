import 'package:flutter/material.dart';


class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Dashboard',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            Divider(thickness: 1, color: Colors.grey.shade200),
            SizedBox(height: 16),

            // Expanded(
            //   child: GridView.count(
            //     crossAxisCount: 2,
            //     crossAxisSpacing: 16.0,
            //     mainAxisSpacing: 16.0,
            //     children: [
            //       _buildCard('Success Payments', '₹ 5009', Colors.green, Icons.check_circle, 0.9),
            //       _buildCard('Pending Payments', '₹ 7261', Colors.orange,Icons.error,0.7),
            //       _buildCard('Failed Payments', '₹ 4025', Colors.red,Icons.cancel,0.5),
            //     ],
            //   ),
            // ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 26.0),
                children: [
                  _buildCard('Success Payments', '₹ 5009', Colors.green, Icons.check_circle, 0.9),
                  const SizedBox(height: 16),
                  _buildCard('Pending Payments', '₹ 7261', Colors.orange,Icons.error,0.7),
                  const SizedBox(height: 16),
                  _buildCard('Failed Payments', '₹ 4025', Colors.red,Icons.cancel,0.5),

                ],
              ),
            )

          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, String amount, Color color, IconData check_circle, double value, ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.3), color.withOpacity(0.2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                )),
            const SizedBox(height: 8),
            Text(
              ' $amount',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 10),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 70,
                  width: 70,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: value,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    backgroundColor: color.withOpacity(0.1),
                  ),
                ),
                Icon(
                  check_circle,
                  color: color,
                  size: 25,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
