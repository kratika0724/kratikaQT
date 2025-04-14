import 'package:flutter/material.dart';
import 'package:qt_distributer/widgets/common_text_widgets.dart';
import 'package:qt_distributer/constants/app_colors.dart';
import '../../constants/app_textstyles.dart';
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.filter_list, color: AppColors.primary),
              onPressed: () => _showFilterSheet(context),
            ),
          ),
        ],
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
  void _showFilterSheet(BuildContext context) {
    final List<String> dropdownItems = ['Any', 'Yes', 'No'];

    String verifiedValue = 'Any';
    String roleValue = 'Any';
    String statusValue = 'Any';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            Widget buildFilterGroup(String title, String selected, void Function(String) onSelected) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 5,
                    children: dropdownItems.map((item) {
                      final bool isSelected = selected == item;
                      return ChoiceChip(
                        label: Text(item),
                        selected: isSelected,
                        showCheckmark: true,
                        checkmarkColor: Colors.white,
                        onSelected: (_) => setState(() => onSelected(item)),
                        selectedColor: AppColors.secondary,
                        labelStyle: mediumTextStyle(
                          color: isSelected ? Colors.white : AppColors.secondary  ,
                          fontSize: 14.0,
                        ),
                        backgroundColor: AppColors.primary.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(color: Colors.transparent)
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }

            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Filter',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildFilterGroup("Verified", verifiedValue, (val) => verifiedValue = val),
                  buildFilterGroup("Role", roleValue, (val) => roleValue = val),
                  buildFilterGroup("Status", statusValue, (val) => statusValue = val),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Apply filters using verifiedValue, roleValue, statusValue
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


}

