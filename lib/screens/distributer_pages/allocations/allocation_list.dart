import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/response models/allocation_response.dart';
import '../../../providers/allocation_provider.dart';
import '../../../utils/device_utils.dart';
import 'allocation_card.dart';

class AllocationList extends StatefulWidget {
  final List<AllocationModel> allocations;
  final String? filterPincode;
  final String? filterArea;

  const AllocationList({
    super.key,
    required this.allocations,
    this.filterPincode,
    this.filterArea,
  });

  @override
  State<AllocationList> createState() => _AllocationListState();
}

class _AllocationListState extends State<AllocationList> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final provider = Provider.of<AllocationProvider>(context, listen: false);
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !provider.isFetchingMore &&
        provider.hasMoreData) {
      provider.getAllocationData(context, loadMore: true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final isWide = DeviceUtils.getDeviceWidth(context);
    final allocationProvider = Provider.of<AllocationProvider>(context);
    final filteredAllocations = allocationProvider.FilteredAllocations;

    if (filteredAllocations.isEmpty) {
      return const Center(
          child: Text("No allocations found.")
      );
    }
    return isWide
        ? _buildGridView(filteredAllocations)
        : _buildListView(filteredAllocations);
  }

  Widget _buildGridView(List<AllocationModel> allocations) {
    final isOdd = allocations.length.isOdd;
    final totalItems = isOdd ? allocations.length + 1 : allocations.length;

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: totalItems,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        // mainAxisExtent: 100, // Adjust height as needed
        childAspectRatio: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        if (index >= allocations.length) {
          return const SizedBox(); // Empty widget to balance the grid
        }
        return AllocationCard(allocation: allocations[index]);
      },
    );
  }

  Widget _buildListView(List<AllocationModel> allocations) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: allocations.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          child: AllocationCard(allocation: allocations[index]),
        );
      },
    );
  }
}
