import 'package:flutter/material.dart';
import 'package:qt_distributer/widgets/common_text_widgets.dart';
import 'package:qt_distributer/constants/app_colors.dart';
import '../../widgets/add_new_button.dart';
import 'add_allocation_screen.dart';
import 'allocation_card_list.dart';

class AllocationsScreen extends StatelessWidget {
  const AllocationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: HeaderTextThemeSecondary("Allocations"),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.secondary,
        elevation: 3,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(child: AllocationCardList()),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AddNewButton(
                    label: 'Add New Allocation',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddAllocationScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

