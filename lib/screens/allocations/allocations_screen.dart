import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qt_distributer/constants/app_colors.dart';
import 'package:qt_distributer/widgets/common_text_widgets.dart';
import '../../constants/app_textstyles.dart';
import '../../providers/allocation_provider.dart';
import '../../utils/device_utils.dart';
import '../agent/add_agent_screen.dart';
import 'add_allocation_screen.dart';
import 'allocation_card.dart';
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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Use WidgetsBinding to ensure the context is available after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AllocationProvider>(context, listen: false);
      provider.currentPage_allocation = 1;
      provider.getAllocationData(context);

      _scrollController.addListener(() {
        if (_scrollController.position.extentAfter < 300 &&
            !provider.isFetchingMore &&
            provider.hasMoreData) {
          provider.getAllocationData(context, loadMore: true);
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back)),
            SizedBox(
              width: 20,
            ),
            HeaderTextBlack("Allocations"),
            Spacer(),
            // Filter or Clear Filter Button
            GestureDetector(
              onTap: () {
                if (filterPincode != null || filterArea != null) {
                  setState(() {
                    filterPincode = null;
                    filterArea = null;
                  });
                } else {
                  _openFilterBottomSheet();
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 0),
                child: Container(
                  height: 33,
                  constraints: const BoxConstraints(maxWidth: 140),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: (filterPincode != null || filterArea != null)
                        ? AppColors.secondary
                        : AppColors.primary.withOpacity(0.1),
                    border: Border.all(color: AppColors.secondary),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Text(
                          (filterPincode != null || filterArea != null)
                              ? "Clear Filters"
                              : "Filter Allocations",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: mediumTextStyle(
                            fontSize: dimen13,
                            color: (filterPincode != null || filterArea != null)
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        (filterPincode != null || filterArea != null)
                            ? Icons.clear
                            : Icons.filter_list,
                        size: 16,
                        color: (filterPincode != null || filterArea != null)
                            ? Colors.white
                            : Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        // actions: [
        //   // Filter or Clear Filter Button
        //   GestureDetector(
        //     onTap: () {
        //       if (filterName != null || filterCode != null) {
        //         setState(() {
        //           filterName = null;
        //           filterCode = null;
        //         });
        //       } else {
        //         _openFilterBottomSheet();
        //       }
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.only(right: 12),
        //       child: Container(
        //         height: 30,
        //         constraints: const BoxConstraints(maxWidth: 120),
        //         padding: const EdgeInsets.symmetric(horizontal: 8),
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(9),
        //           color: (filterName != null || filterCode != null)
        //               ? AppColors.secondary
        //               : AppColors.primary.withOpacity(0.1),
        //           border: Border.all(color: AppColors.secondary),
        //         ),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             Flexible(
        //               child: Text(
        //                 (filterName != null || filterCode != null)
        //                     ? "Clear Filters"
        //                     : "Filter Products",
        //                 overflow: TextOverflow.ellipsis,
        //                 maxLines: 1,
        //                 style: mediumTextStyle(
        //                   fontSize: dimen13,
        //                   color: (filterName != null || filterCode != null)
        //                       ? Colors.white
        //                       : Colors.black,
        //                 ),
        //               ),
        //             ),
        //             const SizedBox(width: 4),
        //             Icon(
        //               (filterName != null || filterCode != null)
        //                   ? Icons.clear
        //                   : Icons.filter_list,
        //               size: 16,
        //               color: (filterName != null || filterCode != null)
        //                   ? Colors.white
        //                   : Colors.black,
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Consumer<AllocationProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.allocations.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null && provider.allocations.isEmpty) {
            return const Center(child: Text("Oops! Something went wrong"));
          }

          final filteredAllocations = provider.allocations.where((allocation) {
            final matchesPincode = filterPincode == null ||
                allocation.allocationPincode?.contains(filterPincode!) == true;
            final matchesArea = filterArea == null ||
                allocation.allocationArea
                        ?.toLowerCase()
                        .contains(filterArea!.toLowerCase()) ==
                    true;
            return matchesPincode && matchesArea;
          }).toList();

          if (filteredAllocations.isEmpty) {
            return const Center(child: Text("No allocations found."));
          }

          final isWide = DeviceUtils.getDeviceWidth(context);
          final scrollableList = isWide
              ? GridView.builder(
                  controller: _scrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: filteredAllocations.length + 1,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 100,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    if (index == filteredAllocations.length) {
                      return provider.hasMoreData
                          ? const Center(child: CircularProgressIndicator())
                          : const SizedBox.shrink();
                    }
                    return AllocationCard(
                        allocation: filteredAllocations[index]);
                  },
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 10),
                  itemCount: filteredAllocations.length + 1,
                  itemBuilder: (context, index) {
                    if (index == filteredAllocations.length) {
                      return provider.hasMoreData
                          ? const Center(child: CircularProgressIndicator())
                          : const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      child: AllocationCard(
                          allocation: filteredAllocations[index]),
                    );
                  },
                );

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
              Expanded(child: scrollableList),
            ],
          );
        },
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
                    MaterialPageRoute(
                        builder: (_) => const AddAllocationScreen()),
                  );
                },
                icon: const Icon(Icons.add, size: 18, color: Colors.white),
                label: Text(
                  'Add Allocation',
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
