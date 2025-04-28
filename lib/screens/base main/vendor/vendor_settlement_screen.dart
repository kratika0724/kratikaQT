// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// import '../../../constants/app_colors.dart';
// import '../../../providers/transaction_provider.dart';
// import '../../../widgets/common_text_widgets.dart';
// import '../../../widgets/filter_chips_widget.dart';
// import '../../settlement/settlement_filter_bottom_sheet.dart';
// import '../../settlement/settlement_list.dart';
//
// class VendorSettlementScreen extends StatefulWidget {
//   const VendorSettlementScreen({super.key});
//
//   @override
//   State<VendorSettlementScreen> createState() => _SettlementScreenState();
// }
//
// class _SettlementScreenState extends State<VendorSettlementScreen> {
//   String? filterQuintusId;
//   String? filterEmail;
//   String? filterStatus;
//   String? filterTransactionType;
//   DateTime? filterStartDate;
//   DateTime? filterEndDate;
//   var formatted;
//
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       Provider.of<TransactionProvider>(context, listen: false)
//           .getTransactions(context);
//     });
//   }
//
//   void _openFilterBottomSheet() async {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (_) => SettlementFilterBottomSheet(
//         initialQuintusId: filterQuintusId,
//         initialEmail: filterEmail,
//         initialStatus: filterStatus,
//         initialType: filterTransactionType,
//         filterStartDate: filterStartDate,
//         filterEndDate: filterEndDate,
//         onApply: (quintusId, email, status, type, startDate, endDate) {
//           setState(() {
//             filterQuintusId = quintusId;
//             filterEmail = email;
//             filterStatus = status;
//             filterTransactionType = type;
//             filterStartDate = startDate;
//             filterEndDate = endDate;
//           });
//         },
//         onClear: () {
//           setState(() {
//             filterQuintusId = null;
//             filterEmail = null;
//             filterStatus = null;
//             filterTransactionType = null;
//             filterStartDate = null;
//             filterEndDate = null;
//           });
//         },
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.ghostWhite,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: HeaderTextBlack("Settlement Request"),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         actions: [
//           GestureDetector(
//             onTap: () => _openFilterBottomSheet(),
//             child: Padding(
//               padding: const EdgeInsets.only(right: 12),
//               child: Container(
//                 height: 30,
//                 constraints: const BoxConstraints(maxWidth: 80),
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: AppColors.primary.withOpacity(0.1),
//                   border: Border.all(color: AppColors.secondary),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     Flexible(
//                         child: Text("Filter",
//                             overflow: TextOverflow.ellipsis, maxLines: 1)),
//                     SizedBox(width: 4),
//                     Icon(Icons.filter_list, size: 16, color: Colors.black),
//                   ],
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//       body: Column(
//         children: [
//           if (filterQuintusId != null ||
//               filterTransactionType != null ||
//               filterStatus != null ||
//               filterEmail != null ||
//               filterStartDate != null && filterEndDate != null)
//             FilterChipsWidget(
//               filters: {
//                 'Transaction ID': filterQuintusId,
//                 'Email': filterEmail,
//                 'Transaction Type': filterTransactionType,
//                 'Transaction Status': filterStatus,
//                 'Date Range': formatted,
//               },
//               onClear: () {
//                 setState(() {
//                   filterQuintusId = null;
//                   filterEmail = null;
//                   filterTransactionType = null;
//                   filterStatus = null;
//                   filterStartDate = null;
//                   filterEndDate = null;
//                 });
//               },
//             ),
//           Expanded(
//               child: SettlementListScreen()
//           ),
//           const SizedBox(height: 10),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qt_distributer/constants/app_textstyles.dart';
import 'package:qt_distributer/screens/vendor%20payments/vendor_paymentCard_list.dart';
import '../../../constants/app_colors.dart';
import '../../../providers/transaction_provider.dart';
import '../../../widgets/common_text_widgets.dart';
import '../../../widgets/filter_chips_widget.dart';
import '../../settlement/settlement_filter_bottom_sheet.dart';
import '../../settlement/settlement_list.dart';

class VendorSettlementScreen extends StatefulWidget {
  const VendorSettlementScreen({super.key});

  @override
  State<VendorSettlementScreen> createState() => _VendorSettlementScreenState();
}

class _VendorSettlementScreenState extends State<VendorSettlementScreen> with SingleTickerProviderStateMixin {
  String? filterQuintusId;
  String? filterEmail;
  String? filterStatus;
  String? filterTransactionType;
  DateTime? filterStartDate;
  DateTime? filterEndDate;
  var formatted;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {
      Provider.of<TransactionProvider>(context, listen: false).getTransactions(context);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openFilterBottomSheet() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SettlementFilterBottomSheet(
        initialQuintusId: filterQuintusId,
        initialEmail: filterEmail,
        initialStatus: filterStatus,
        initialType: filterTransactionType,
        filterStartDate: filterStartDate,
        filterEndDate: filterEndDate,
        onApply: (quintusId, email, status, type, startDate, endDate) {
          setState(() {
            filterQuintusId = quintusId;
            filterEmail = email;
            filterStatus = status;
            filterTransactionType = type;
            filterStartDate = startDate;
            filterEndDate = endDate;
          });
        },
        onClear: () {
          setState(() {
            filterQuintusId = null;
            filterEmail = null;
            filterStatus = null;
            filterTransactionType = null;
            filterStartDate = null;
            filterEndDate = null;
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
            Tab(
                text: 'Requests',
            ),
            Tab(text: 'Payments'),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () => _openFilterBottomSheet(),
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Container(
                height: 30,
                constraints: const BoxConstraints(maxWidth: 80),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.primary.withOpacity(0.1),
                  border: Border.all(color: AppColors.secondary),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Flexible(
                      child: Text(
                        "Filter",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.filter_list, size: 16, color: Colors.black),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (filterQuintusId != null ||
              filterTransactionType != null ||
              filterStatus != null ||
              filterEmail != null ||
              (filterStartDate != null && filterEndDate != null))
            FilterChipsWidget(
              filters: {
                'Transaction ID': filterQuintusId,
                'Email': filterEmail,
                'Transaction Type': filterTransactionType,
                'Transaction Status': filterStatus,
                'Date Range': formatted,
              },
              onClear: () {
                setState(() {
                  filterQuintusId = null;
                  filterEmail = null;
                  filterTransactionType = null;
                  filterStatus = null;
                  filterStartDate = null;
                  filterEndDate = null;
                });
              },
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,

              children: [
                // Request Tab
                const SettlementListScreen(), // Or add your own widget
                // Payments Tab
                const VendorPaymentCardList(),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
