import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qt_distributer/constants/app_colors.dart';
import 'package:qt_distributer/widgets/common_text_widgets.dart';
import '../../../constants/app_textstyles.dart';
import '../../../providers/allocation_provider.dart';
import '../../../widgets/bottom_add_button.dart';
import '../../../widgets/filter_button.dart';
import 'add_allocation_screen.dart';
import 'allocation_filter_bottom_sheet.dart';
import 'allocation_list.dart';
import '../../../widgets/filter_chips_widget.dart';

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
            FilterButton(
              hasFilters: _hasFilters,
              label: "Allocations",
              maxWidth: 147,
              onApplyTap: _openFilterBottomSheet,
              onClearTap: _clearFilters,
            ),
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
      bottomNavigationBar: BottomAddButton(
        label: 'Add Allocation',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddAllocationScreen(),
            ),
          );
        },
      ),
    );
  }
}
