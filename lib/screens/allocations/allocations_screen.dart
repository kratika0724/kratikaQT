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

  bool get _hasFilters => filterPincode != null || filterArea != null;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyFilters();
      Provider.of<AllocationProvider>(context, listen: false)
          .getAllocationData(context);
    });
  }

  void _applyFilters() {
    Provider.of<AllocationProvider>(context, listen: false).setFilters(
      pincode: filterPincode,
      area: filterArea,
    );
  }

  void _clearFilters() {
    setState(() {
      filterPincode = null;
      filterArea = null;
      _applyFilters();
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
            _applyFilters();
          });
        },
        onClear: _clearFilters,
      ),
    );
  }

  Widget _buildFilterButton() {
    return GestureDetector(
      onTap: () => _hasFilters ? _clearFilters() : _openFilterBottomSheet(),
      child: Container(
        height: 33,
        constraints: const BoxConstraints(maxWidth: 145),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: _hasFilters
              ? AppColors.secondary
              : AppColors.primary.withOpacity(0.1),
          border: Border.all(color: AppColors.secondary),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                _hasFilters ? "Clear Filters" : "Filter Allocations",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: mediumTextStyle(
                  fontSize: dimen14,
                  color: _hasFilters ? Colors.white : Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              _hasFilters ? Icons.clear : Icons.filter_list,
              size: 16,
              color: _hasFilters ? Colors.white : Colors.black,
            ),
          ],
        ),
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
            _buildFilterButton(),
          ],
        ),
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
          if (provider.allocations.isEmpty) {
            return const Center(child: Text("No Data Found!"));
          }

          return Column(
            children: [
              if (_hasFilters)
                FilterChipsWidget(
                  filters: {
                    'Pincode': filterPincode,
                    'Area': filterArea,
                  },
                  onClear: _clearFilters,
                ),
              Expanded(
                child: AllocationList(
                  allocations: provider.allocations,
                  filterPincode: filterPincode,
                  filterArea: filterArea,
                ),
              ),
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
