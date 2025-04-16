import 'package:flutter/material.dart';
import '../../models/sample models/customer_model.dart';
import 'customer_card.dart';

class CustomerList extends StatelessWidget {
  CustomerList({super.key});

  final List<CustomerModel> customerList =
  sampleCustomers.map((e) => CustomerModel.fromMap(e)).toList();



  @override
  Widget build(BuildContext context) {
    if (sampleCustomers.isEmpty) {
      return const Center(child: Text('No customers found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
      itemCount: customerList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: CustomerCard(customer: customerList[index]),
        );
      },
    );
  }
}

