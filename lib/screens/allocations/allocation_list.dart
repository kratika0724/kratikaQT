import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/response models/allocation_response.dart';
import '../../providers/allocation_provider.dart';
import '../../utils/device_utils.dart';
import 'allocation_card.dart';

class AllocationList extends StatelessWidget {
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
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: allocations.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 80, // Adjust height as needed
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        return AllocationCard(allocation: allocations[index]);
      },
    );
  }

  Widget _buildListView(List<AllocationModel> allocations) {
    return ListView.builder(
      itemCount: allocations.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
          child: AllocationCard(allocation: allocations[index]),
        );
      },
    );
  }
}
