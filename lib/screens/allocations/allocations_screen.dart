import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qt_distributer/widgets/common_text_widgets.dart';
import 'package:qt_distributer/constants/app_colors.dart';
import '../../constants/app_textstyles.dart';
import '../../models/response models/allocation_response.dart';
import '../../providers/allocation_provider.dart';
import 'add_allocation_screen.dart';
import 'allocation_card.dart';

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

  void _openFilterBottomSheet(BuildContext context) {
    final pincodeController = TextEditingController(text: filterPincode ?? '');
    final areaController = TextEditingController(text: filterArea ?? '');
    List<String> pincodeSuggestions = [];
    List<String> areaSuggestions = [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            void updatePincodeSuggestions(String query) {
              final provider = Provider.of<AllocationProvider>(context, listen: false);
              setModalState(() {
                pincodeSuggestions = provider.allocations
                    .map((e) => e.allocationPincode ?? '')
                    .where((code) => code.toLowerCase().contains(query.toLowerCase()))
                    .toSet()
                    .toList();
              });
            }

            void updateAreaSuggestions(String query) {
              final provider = Provider.of<AllocationProvider>(context, listen: false);
              setModalState(() {
                areaSuggestions = provider.allocations
                    .map((e) => e.allocationArea ?? '')
                    .where((area) => area.toLowerCase().contains(query.toLowerCase()))
                    .toSet()
                    .toList();
              });
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Filter Allocations", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    TextField(
                      controller: pincodeController,
                      decoration: const InputDecoration(
                        labelText: 'Pincode',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: updatePincodeSuggestions,
                    ),
                    if (pincodeSuggestions.isNotEmpty)
                      ...pincodeSuggestions.map((val) => _buildSuggestionTile(val, pincodeController, setModalState, pincodeSuggestions)),
                    const SizedBox(height: 16),
                    TextField(
                      controller: areaController,
                      decoration: const InputDecoration(
                        labelText: 'Area',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: updateAreaSuggestions,
                    ),
                    if (areaSuggestions.isNotEmpty)
                      ...areaSuggestions.map((val) => _buildSuggestionTile(val, areaController, setModalState, areaSuggestions)),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                filterPincode = pincodeController.text.trim().isNotEmpty
                                    ? pincodeController.text.trim()
                                    : null;
                                filterArea = areaController.text.trim().isNotEmpty
                                    ? areaController.text.trim()
                                    : null;
                              });
                              Navigator.pop(context);
                            },
                            child: const Text("Apply Filters"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                            ),
                            onPressed: () {
                              setState(() {
                                filterPincode = null;
                                filterArea = null;
                              });
                              Navigator.pop(context);
                            },
                            child: const Text("Clear Filters"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSuggestionTile(String value, TextEditingController controller, void Function(void Function()) setModalState, List<String> list) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: AppColors.ghostWhite,
      ),
      child: ListTile(
        dense: true,
        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
        minVerticalPadding: 0,
        contentPadding: EdgeInsets.only(left: 8.0, right: 8.0),
        title: Text(value, style: regularTextStyle(fontSize: dimen13, color: Colors.black)),
        onTap: () {
          controller.text = value;
          setModalState(() => list.clear());
        },
      ),
    );
  }

  List<AllocationModel> _applyFilters(List<AllocationModel> allocations) {
    return allocations.where((allocation) {
      final pincodeMatch = filterPincode == null || (allocation.allocationPincode?.contains(filterPincode!) ?? false);
      final areaMatch = filterArea == null || (allocation.allocationArea?.toLowerCase().contains(filterArea!.toLowerCase()) ?? false);
      return pincodeMatch && areaMatch;
    }).toList();
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
                          _openFilterBottomSheet(context);
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
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            return Center(child: Text("Oops! Something went wrong"));
          }
          final filteredAllocations = _applyFilters(provider.allocations);
          return Column(
            children: [
              if (filterPincode != null || filterArea != null)
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (filterPincode != null || filterArea != null)
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              if (filterPincode != null)
                                Chip(
                                  label: Text(
                                    "Pincode: $filterPincode",
                                    style: const TextStyle(
                                      color: AppColors.secondary,
                                      fontSize: 12,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 1,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    side: const BorderSide(color: AppColors.secondary,width: 0.7),
                                  ),
                                  backgroundColor: Colors.white,
                                  visualDensity: VisualDensity.compact,
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              if (filterArea != null)
                                Chip(
                                  label: Text(
                                    "Area: $filterArea",
                                    style: const TextStyle(
                                      color: AppColors.secondary,
                                      fontSize: 12,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 1,
                                  ),

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    side: const BorderSide(color: AppColors.secondary,width: 0.7),
                                  ),
                                  backgroundColor: Colors.white,
                                  visualDensity: VisualDensity.compact,
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                            ],
                          ),

                        if (filterPincode != null || filterArea != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      filterPincode = null;
                                      filterArea = null;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: AppColors.ghostWhite,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical:5,horizontal: 9.0),
                                      child:  Text(
                                        "Clear Filters",
                                        style: regularTextStyle(fontSize: dimen13,color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    )


                ),
              if (filteredAllocations.isEmpty)
                const Expanded(
                  child: Center(child: Text("No allocations found")),
                )
              else
                Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  itemCount: filteredAllocations.length,
                  itemBuilder: (context, index) {
                    final allocation = filteredAllocations[index];
                    return AllocationCard(allocation: allocation);
                  },
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



