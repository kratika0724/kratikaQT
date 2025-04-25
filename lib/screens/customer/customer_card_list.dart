import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/response models/customer_response.dart';
import '../../models/sample models/customer_model.dart';
import '../../providers/customer_provider.dart';
import '../../utils/device_utils.dart';
import 'customer_card.dart';

class CustomerList extends StatefulWidget {
  final List<CustomerData> customers;
  final String? filterName;
  final String? filterEmail;

  const CustomerList({
    super.key,
    required this.customers,
    this.filterName,
    this.filterEmail,
  });

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  int? expandedIndex;

  void toggleExpanded(int index) {
    setState(() {
      if (expandedIndex == index) {
        expandedIndex = null;
      } else {
        expandedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWide = DeviceUtils.getDeviceWidth(context);
    final customerProvider = Provider.of<CustomerProvider>(context);
    final filteredCustomers = customerProvider.FilteredCustomers;

    if (filteredCustomers.isEmpty) {
      return const Center(child: Text('No customers found.'));
    }

    return isWide
        ? _buildGridView(filteredCustomers)
        : _buildListView(filteredCustomers);

  }


  Widget _buildGridView(List<CustomerData> customers) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: customers.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 300,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) => CustomerCard(
        customer: widget.customers[index],
        isExpanded: expandedIndex == index,
        onExpandToggle: () => toggleExpanded(index),
      ),
    );
  }

  Widget _buildListView(List<CustomerData> customers) {
    return ListView.builder(
      itemCount: customers.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: CustomerCard(
          customer: widget.customers[index],
          isExpanded:expandedIndex == index,
          onExpandToggle: () => toggleExpanded(index),
        ),
      ),
    );
  }
}

