import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qt_distributer/screens/distributor/distributor_card.dart';
import 'package:qt_distributer/screens/distributor/distributor_list.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_textstyles.dart';
import '../../../providers/agent_provider.dart';
import '../../../widgets/common_text_widgets.dart';
import '../../../widgets/filter_chips_widget.dart';
import '../../agent/add_agent_screen.dart';
import '../../agent/agent_filter_bottom_sheet.dart';
import '../../agent/agent_list.dart';
import '../../distributor/add_distributor_screen.dart';

class DistributerScreen extends StatefulWidget {
  const DistributerScreen({super.key});

  @override
  State<DistributerScreen> createState() => AgentsScreenState();
}

class AgentsScreenState extends State<DistributerScreen> {
  String? filterName;
  String? filterEmail;
  bool? filterIsActive = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<AgentProvider>(context, listen: false).getAgentData(context);
    });
  }

  void _openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => AgentFilterBottomSheet(
        initialName: filterName,
        initialEmail: filterEmail,
        initialIsActive: filterIsActive,
        onApply: (name, email, isActive) {
          setState(() {
            filterName = name;
            filterEmail = email;
            filterIsActive = isActive;
          });
        },
        onClear: () {
          setState(() {
            filterName = null;
            filterEmail = null;
            filterIsActive = true;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ghostWhite.withOpacity(0.7),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: HeaderTextBlack("Distributors"),
        actions: [
          // Add Agent Button
          // GestureDetector(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (_) => const AddAgentScreen()),
          //     );
          //   },
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 8),
          //     child: Container(
          //       height: 30,
          //       constraints: const BoxConstraints(maxWidth: 110),
          //       padding: const EdgeInsets.symmetric(horizontal: 8),
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(9),
          //         color: AppColors.primary.withOpacity(0.1),
          //         border: Border.all(color: AppColors.secondary),
          //       ),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Flexible(
          //             child: Text(
          //               "Add Distributor",
          //               overflow: TextOverflow.ellipsis,
          //               maxLines: 1,
          //               style: mediumTextStyle(
          //                   fontSize: dimen13, color: Colors.black),
          //             ),
          //           ),
          //           const SizedBox(width: 4),
          //           const Icon(Icons.add, size: 16, color: Colors.black),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),

          GestureDetector(
            onTap: () {
              if (filterName != null ||
                  filterEmail != null ||
                  filterIsActive != true) {
                setState(() {
                  filterName = null;
                  filterEmail = null;
                  filterIsActive = true;
                });
              } else {
                _openFilterBottomSheet();
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Container(
                height: 33,
                constraints: const BoxConstraints(maxWidth: 150),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: (filterName != null ||
                      filterEmail != null ||
                      filterIsActive != true)
                      ? AppColors.secondary
                      : AppColors.primary.withOpacity(0.1),
                  border: Border.all(color: AppColors.secondary),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        (filterName != null ||
                            filterEmail != null ||
                            filterIsActive != true)
                            ? "Clear Filters"
                            : "Filter Distributors",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: mediumTextStyle(
                          fontSize: dimen13,
                          color: (filterName != null ||
                              filterEmail != null ||
                              filterIsActive != true)
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      (filterName != null ||
                          filterEmail != null ||
                          filterIsActive != true)
                          ? Icons.clear
                          : Icons.filter_list,
                      size: 16,
                      color: (filterName != null ||
                          filterEmail != null ||
                          filterIsActive != true)
                          ? Colors.white
                          : Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          if (filterName != null || filterEmail != null)
            FilterChipsWidget(
              filters: {
                'Name': filterName,
                'Email': filterEmail,
              },
              onClear: () => setState(() {
                filterEmail = null;
                filterName = null;
              }),
            ),
          Expanded(
              child: DistributorListScreen()
          ),
          const SizedBox(height: 10),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 8),
            child: SizedBox(
              height: 45,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddDistributorScreen()),
                  );
                },
                icon: const Icon(Icons.add, size: 18, color: Colors.white),
                label: Text(
                  'Add Distributor',
                  style:
                  mediumTextStyle(fontSize: dimen15, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
