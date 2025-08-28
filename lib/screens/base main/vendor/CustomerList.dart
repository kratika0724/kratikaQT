import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/response models/customer_response.dart';
import '../../../providers/customer_provider.dart';
import '../../../utils/device_utils.dart';
import 'CustomerCard.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({
    super.key,
  });

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  int? expandedIndex;
  final ScrollController _scrollController = ScrollController();

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
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final provider = Provider.of<CustomerProvider>(context, listen: false);
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !provider.isFetchingMore &&
          provider.hasMoreData) {
        provider.getCustomerData(context, loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = DeviceUtils.getDeviceWidth(context);
    final customerProvider = Provider.of<CustomerProvider>(context);
    final customers = customerProvider.customers;

    if (customers.isEmpty) {
      return const Center(child: Text('No customers found.'));
    }

    return isWide
        ? _buildGridView(customers)
        : _buildListView(customers);
  }

  Widget _buildGridView(List<CustomerData> customers) {
    final isOdd = customers.length.isOdd;
    final totalItems = isOdd ? customers.length + 1 : customers.length;

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: totalItems,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 300,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        if (index >= customers.length) {
          return const SizedBox(); // Empty slot to balance the grid
        }

        return CustomerCard(
          customer: customers[index],
          isExpanded: expandedIndex == index,
          onExpandToggle: () => toggleExpanded(index),
        );
      },
    );
  }

  Widget _buildListView(List<CustomerData> customers) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: customers.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: CustomerCard(
          customer: customers[index],
          isExpanded: expandedIndex == index,
          onExpandToggle: () => toggleExpanded(index),
        ),
      ),
    );
  }
}
