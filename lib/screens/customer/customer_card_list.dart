import 'package:flutter/material.dart';
import '../../models/response models/customer_response.dart';
import '../../models/sample models/customer_model.dart';
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
    final filteredCustomers = _getFilteredCustomers();

    if (filteredCustomers.isEmpty) {
      return const Center(child: Text('No customers found.'));
    }

    return isWide
        ? _buildGridView(filteredCustomers)
        : _buildListView(filteredCustomers);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
      itemCount: widget.customers.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: CustomerCard(customer: widget.customers[index], isExpanded: false, onExpandToggle: () {  },),
        );
      },
    );
  }

  List<CustomerData> _getFilteredCustomers() {
    return widget.customers.where((agent) {
      final matchesName = widget.filterName == null ||
          (agent.firstName ?? '').toLowerCase().contains(widget.filterName!.toLowerCase());

      final matchesEmail = widget.filterEmail == null ||
          (agent.email ?? '').toLowerCase().contains(widget.filterEmail!.toLowerCase());

      return matchesName && matchesEmail;
    }).toList();
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

