import 'package:flutter/material.dart';
import 'package:qt_distributer/constants/app_colors.dart';
import 'package:dotted_line/dotted_line.dart';
import '../constants/app_textstyles.dart';


class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> payments = [
      {
        'status': 'Success',
        'transactionId': 'TXN123456',
        'name': 'John Doe',
        'email': 'john@example.com',
        'amount': '₹500',
        'createdAt': '10 Apr 2025',
      },
      {
        'status': 'Pending',
        'transactionId': 'TXN654321',
        'name': 'Jane Smith',
        'email': 'jane@example.com',
        'amount': '₹850',
        'createdAt': '09 Apr 2025',
      },
      {
        'status': 'Failed',
        'transactionId': 'TXN123789',
        'name': 'Smith B.',
        'email': 'smith@example.com',
        'amount': '₹1300',
        'createdAt': '11 Apr 2025',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Payments',
                style: headTextStyle(
                    fontSize: dimen20, color: Colors.black),
                  ),
                ],
              ),
            ),
            Divider(thickness: 1, color: Colors.grey.shade200),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: payments.length,
                itemBuilder: (context, index) {
                  final payment = payments[index];
                  return Card(
                    color: AppColors.background,
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRow('Transaction ID', payment['transactionId']!),
                          const Padding(
                            padding: EdgeInsets.only(top: 4, bottom: 8),
                            child: DottedLine(
                              dashLength: 6.0,
                              dashColor: Colors.grey,
                            ),
                          ),

                          // _buildRow('Status', payment['status']!),
                          _buildRow('Name', payment['name']!),
                          _buildRow('Email', payment['email']!),
                          _buildRow('Amount', payment['amount']!),
                          _buildRow('Created At', payment['createdAt']!),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: payment['status'] == "Pending" ? Colors.yellow.withOpacity(0.2) : payment['status'] == "Success" ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2) ,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6.0,horizontal: 10.0),
                                  child: Text(
                                      "${payment['status']}",
                                    style: TextStyle(
                                      fontSize: 11,fontWeight: FontWeight.bold,color: payment['status'] == "Pending" ? Colors.yellow.shade700 : payment['status'] == "Success" ? Colors.green: Colors.red,

                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );

                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
              flex:1,
              child: Text(
                  '$label:',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: semiBoldTextStyle(fontSize: dimen14, color: Colors.black))),
          Expanded(
              child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: regularTextStyle(fontSize: dimen14, color: Colors.black))),
        ],
      ),
    );
  }
}
