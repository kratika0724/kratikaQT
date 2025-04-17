import 'package:flutter/material.dart';
import '../../../models/response models/allocation_response.dart';
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
    final filteredAllocations = allocations.where((allocation) {
      final matchesPincode = filterPincode == null || allocation.allocationPincode?.contains(filterPincode!) == true;
      final matchesArea = filterArea == null || allocation.allocationArea?.toLowerCase().contains(filterArea!.toLowerCase()) == true;
      return matchesPincode && matchesArea;
    }).toList();

    if (filteredAllocations.isEmpty) {
      return const Center(child: Text("No matching allocations found."));
    }

    final isWide = DeviceUtils.getDeviceWidth(context);

    return isWide
        ? GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: filteredAllocations.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 80, // Adjust height as needed
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        return AllocationCard(allocation: filteredAllocations[index]);
      },
    )
        : ListView.builder(
      itemCount: filteredAllocations.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: AllocationCard(allocation: filteredAllocations[index]),
        );
      },
    );
  }
}
