import 'package:flutter/material.dart';
import '../../../models/sample models/distributor_model.dart';
import 'distributor_card.dart';

class DistributorListScreen extends StatefulWidget {
  const DistributorListScreen({Key? key}) : super(key: key);

  @override
  State<DistributorListScreen> createState() => _DistributorListScreenState();
}

class _DistributorListScreenState extends State<DistributorListScreen> {
  final List<DistributorModel> _distributors = [
    DistributorModel(
      name: 'Suresh Yadav',
      createdAt: DateTime(2025, 4, 22, 10, 0),
      email: 'suresh@example.com',
      contact: '9988776655',
    ),
    DistributorModel(
      name: 'Neha Mehta',
      createdAt: DateTime(2025, 4, 21, 9, 30),
      email: 'neha@example.com',
      contact: '9876543210',
    ),
    DistributorModel(
      name: 'Rahul Sharma',
      createdAt: DateTime(2025, 4, 20, 14, 15),
      email: 'rahul@example.com',
      contact: '9090909090',
    ),
  ];

  int? expandedIndex;

  void toggleExpanded(int index) {
    setState(() {
      expandedIndex = (expandedIndex == index) ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: _distributors.length,
      separatorBuilder: (_, __) => const SizedBox(height: 6),
      itemBuilder: (context, index) {
        return DistributorCard(
          distributor: _distributors[index],
          isExpanded: expandedIndex == index,
          onExpandToggle: () => toggleExpanded(index),
        );
      },
    );
  }
}

