import 'package:flutter/material.dart';
import 'package:qt_distributer/screens/allocations/allocation_card.dart';
import '../../models/allocation_model.dart';

class AllocationCardList extends StatelessWidget {
  const AllocationCardList({super.key});

  @override
  Widget build(BuildContext context) {
    final allocationList = sampleAllocations.map((e) => AllocationModel.fromMap(e)).toList();

    if (allocationList.isEmpty) {
      return const Center(child: Text('No allocations found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allocationList.length,
      itemBuilder: (context, index) {
        return AllocationCard(allocation: allocationList[index]);
      },
    );
  }
}
