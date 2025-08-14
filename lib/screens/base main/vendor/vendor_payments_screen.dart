import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_textstyles.dart';
import '../../../widgets/common_text_widgets.dart';
import '../../../widgets/filter_button.dart';
import '../../../widgets/filter_chips_widget.dart';
import '../../vendor_pages/settlement/settlement_filter_bottom_sheet.dart';
import '../../vendor_pages/settlement/settlement_list.dart';
import '../../vendor_pages/vendor payments/vendor_paymentCard_list.dart';
import '../../vendor_pages/vendor payments/pending_bills_list.dart';
import '../../vendor_pages/vendor payments/venodr_payment_filter_bottom_sheet.dart';

class VendorPaymentsScreen extends StatefulWidget {
  const VendorPaymentsScreen({super.key});

  @override
  State<VendorPaymentsScreen> createState() => _VendorPaymentsScreenState();
}

class _VendorPaymentsScreenState extends State<VendorPaymentsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.secondary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.secondary,
          tabs: const [
            Tab(text: 'Paid'),
            Tab(text: 'Pending'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Paid Tab
          const Expanded(
            child: VendorPaymentCardList(),
          ),
          // Pending Tab
          const Expanded(
            child: PendingBillsList(),
          ),
        ],
      ),
    );
  }
}
