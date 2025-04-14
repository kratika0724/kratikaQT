import 'package:flutter/material.dart';
import '../../models/customer_model.dart';
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
      padding: const EdgeInsets.all(16),
      itemCount: customerList.length,
      itemBuilder: (context, index) {
        return CustomerCard(customer: customerList[index]);
      },
    );
  }
}

