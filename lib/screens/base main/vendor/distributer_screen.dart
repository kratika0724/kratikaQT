import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../widgets/bottom_add_button.dart';
import '../../../widgets/common_text_widgets.dart';
import '../../../widgets/filter_button.dart';
import '../../../widgets/filter_chips_widget.dart';
import '../../vendor_pages/distributor/add_distributor_screen.dart';
import '../../vendor_pages/distributor/distributor_filter_bottom_sheet.dart';
import '../../vendor_pages/distributor/distributor_list.dart';

class DistributerScreen extends StatefulWidget {
  const DistributerScreen({super.key});

  @override
  State<DistributerScreen> createState() => _DistributerScreenState();
}

class _DistributerScreenState extends State<DistributerScreen> {
  String? filterName;
  String? filterEmail;
  bool? filterIsActive = true;

  bool get _hasFilters =>
      filterName != null || filterEmail != null || filterIsActive != true;

  void _clearFilters() {
    setState(() {
      filterName = null;
      filterEmail = null;
      filterIsActive = true;
    });
  }

  void _openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => DistributorFilterBottomSheet(
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
        onClear: _clearFilters,
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
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: FilterButton(
              hasFilters: _hasFilters,
              label: "Distributors",
              maxWidth: 155,
              onApplyTap: _openFilterBottomSheet,
              onClearTap: _clearFilters,
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
              onClear: () {
                setState(() {
                  filterEmail = null;
                  filterName = null;
                });
              },
            ),
          const Expanded(child: DistributorListScreen()),
          const SizedBox(height: 10),
        ],
      ),
      bottomNavigationBar: BottomAddButton(
        label: 'Add Distributor',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddDistributorScreen(),
            ),
          );
        },
      ),
    );
  }
}
