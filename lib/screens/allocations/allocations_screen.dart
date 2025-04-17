import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qt_distributer/constants/app_colors.dart';
import 'package:qt_distributer/widgets/common_text_widgets.dart';
import '../../constants/app_textstyles.dart';
import '../../providers/allocation_provider.dart';
import '../agent/add_agent_screen.dart';
import 'add_allocation_screen.dart';
import 'allocation_filter_bottom_sheet.dart';
import 'allocation_list.dart';
import '../../widgets/filter_chips_widget.dart';

class AllocationsScreen extends StatefulWidget {
  const AllocationsScreen({super.key});

  @override
  State<AllocationsScreen> createState() => _AllocationsScreenState();
}

class _AllocationsScreenState extends State<AllocationsScreen> {
  String? filterPincode;
  String? filterArea;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<AllocationProvider>(context, listen: false).getAllocationData();
    });
  }

  void _openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => AllocationFilterBottomSheet(
        initialPincode: filterPincode,
        initialArea: filterArea,
        onApply: (pincode, area) {
          setState(() {
            filterPincode = pincode;
            filterArea = area;
          });
        },
        onClear: () {
          setState(() {
            filterPincode = null;
            filterArea = null;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ghostWhite,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          title: HeaderTextBlack("Allocations"),
          automaticallyImplyLeading: true,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AddAllocationScreen()),
                          );
                        },
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            color: AppColors.primary.withOpacity(0.1),
                            border: Border.all(color: AppColors.secondary),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Add allocation ",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: mediumTextStyle(fontSize: dimen13, color: Colors.black),
                                ),
                                const Icon(Icons.add, size: 16, color: Colors.black),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          _openFilterBottomSheet();
                        },
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            color: AppColors.primary.withOpacity(0.1),
                            border: Border.all(color: AppColors.secondary),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Filter ",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: mediumTextStyle(fontSize: dimen13, color: Colors.black),
                                ),
                                const Icon(Icons.filter_list, size: 16, color: Colors.black),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Consumer<AllocationProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) return const Center(child: CircularProgressIndicator());
          if (provider.errorMessage != null) return const Center(child: Text("Oops! Something went wrong"));

          return Column(
            children: [
              if (filterPincode != null || filterArea != null)
              FilterChipsWidget(
                filters: {
                  'Pincode': filterPincode,
                  'Area': filterArea,
                },
                onClear: () => setState(() {
                  filterPincode = null;
                  filterArea = null;
                }),
              ),

              Expanded(
                child: AllocationList(
                  allocations: provider.allocations,
                  filterPincode: filterPincode,
                  filterArea: filterArea,
                ),
              ),
              const SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }
}
