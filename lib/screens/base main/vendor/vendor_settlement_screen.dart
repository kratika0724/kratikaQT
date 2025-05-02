import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_textstyles.dart';
import '../../../widgets/common_text_widgets.dart';
import '../../../widgets/filter_button.dart';
import '../../../widgets/filter_chips_widget.dart';
import '../../vendor_pages/settlement/settlement_filter_bottom_sheet.dart';
import '../../vendor_pages/settlement/settlement_list.dart';
import '../../vendor_pages/vendor payments/vendor_paymentCard_list.dart';
import '../../vendor_pages/vendor payments/venodr_payment_filter_bottom_sheet.dart';

class VendorSettlementScreen extends StatefulWidget {
  const VendorSettlementScreen({super.key});

  @override
  State<VendorSettlementScreen> createState() => _VendorSettlementScreenState();
}

class _VendorSettlementScreenState extends State<VendorSettlementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _hasFilters = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openFilterBottomSheet() {
    if (_tabController.index == 0) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (_) => SettlementFilterBottomSheet(
          onApply: (_, __, ___, ____) {
            setState(() => _hasFilters = true);
          },
          onClear: () {
            setState(() => _hasFilters = false);
          },
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (_) => VendorPaymentFilterBottomSheet(
          onApply: (_, __, ___, ____, _____, ______) {
            setState(() => _hasFilters = true);
          },
          onClear: () {
            setState(() => _hasFilters = false);
          },
        ),
      );
    }
  }

  String get filterButtonLabel {
    if (_hasFilters) return "Filters";
    return _tabController.index == 0 ? "Requests" : "Payments";
  }

  Widget _buildFilterChips() {
    return _hasFilters
        ? FilterChipsWidget(
      filters: {"Filter": "Applied"},
      onClear: () {
        setState(() => _hasFilters = false);
      },
    )
        : const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ghostWhite.withOpacity(0.5),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: HeaderTextBlack("Payments"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.black,
          indicatorColor: AppColors.primary,
          dividerColor: Colors.transparent,
          labelStyle: mediumTextStyle(fontSize: dimen18, color: AppColors.primary),
          unselectedLabelStyle: mediumTextStyle(fontSize: dimen18, color: Colors.black),
          tabs: const [
            Tab(text: 'Requests'),
            Tab(text: 'Payments'),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: FilterButton(
              hasFilters: _hasFilters,
              label: filterButtonLabel,
              maxWidth: 142,
              onApplyTap: _openFilterBottomSheet,
              onClearTap: () {
                setState(() => _hasFilters = false);
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                SettlementListScreen(),
                VendorPaymentCardList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
