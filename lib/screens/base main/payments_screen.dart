import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_textstyles.dart';
import '../../widgets/common_text_widgets.dart';
import '../../widgets/filter_chips_widget.dart';
import '../../providers/transaction_provider.dart';
import '../payments/payment_filter_bottom_sheet.dart';
import '../payments/payment_list.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  String? filterQuintusId;
  String? filterEmail;
  String? filterStatus;
  String? filterTransactionType;
  DateTime? filterStartDate;
  DateTime? filterEndDate;
  var formatted;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionProvider>(context, listen: false)
          .getTransactions(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _openFilterBottomSheet() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => PaymentFilterBottomSheet(
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

          // ✅ Tell the provider about the filters!
          Provider.of<TransactionProvider>(context, listen: false).setFilters(
            transactionId: quintusId,
            email: email,
            status: status,
            transactionType: type,
            startDate: startDate,
            endDate: endDate,
          );
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

          Provider.of<TransactionProvider>(context, listen: false).setFilters();
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
        title: HeaderTextBlack("Payments"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          GestureDetector(
            onTap: () {
              if (filterQuintusId != null ||
                  filterTransactionType != null ||
                  filterStatus != null ||
                  filterEmail != null ||
                  filterStartDate != null && filterEndDate != null) {
                setState(() {
                  filterQuintusId = null;
                  filterEmail = null;
                  filterTransactionType = null;
                  filterStatus = null;
                  filterStartDate = null;
                  filterEndDate = null;
                });
              } else {
                _openFilterBottomSheet();
              }
            },
            // onTap: () => _openFilterBottomSheet(),
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Container(
                height: 33,
                constraints: const BoxConstraints(maxWidth: 140),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: (filterQuintusId != null ||
                          filterTransactionType != null ||
                          filterStatus != null ||
                          filterEmail != null ||
                          filterStartDate != null && filterEndDate != null)
                      ? AppColors.secondary
                      : AppColors.primary.withOpacity(0.1),
                  border: Border.all(color: AppColors.secondary),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                        child: Text(
                            (filterQuintusId != null ||
                                    filterTransactionType != null ||
                                    filterStatus != null ||
                                    filterEmail != null ||
                                    filterStartDate != null &&
                                        filterEndDate != null)
                                ? "Clear Filters"
                                : "Filter Payments",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: mediumTextStyle(
                              fontSize: dimen14,
                              color: (filterQuintusId != null ||
                                      filterTransactionType != null ||
                                      filterStatus != null ||
                                      filterEmail != null ||
                                      filterStartDate != null &&
                                          filterEndDate != null)
                                  ? Colors.white
                                  : Colors.black,
                            ))),
                    SizedBox(width: 4),
                    Icon(
                      (filterQuintusId != null ||
                              filterTransactionType != null ||
                              filterStatus != null ||
                              filterEmail != null ||
                              filterStartDate != null && filterEndDate != null)
                          ? Icons.clear
                          : Icons.filter_list,
                      size: 16,
                      color: (filterQuintusId != null ||
                              filterTransactionType != null ||
                              filterStatus != null ||
                              filterEmail != null ||
                              filterStartDate != null && filterEndDate != null)
                          ? Colors.white
                          : Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading)
            return const Center(child: CircularProgressIndicator());

          // Check if transactions list is empty and show "No Data Found"
          if (provider.transactions.isEmpty) {
            return const Center(child: Text("No Data Found!"));
          }

          if (provider.errorMessage != null)
            return const Center(child: Text("Oops! Something went wrong"));

          if (filterStartDate != null && filterEndDate != null)
            formatted =
                "${DateFormat('dd MMM yyyy').format(filterStartDate!)} - ${DateFormat('dd MMM yyyy').format(filterEndDate!)}";

          return Column(
            children: [
              if (filterQuintusId != null ||
                  filterTransactionType != null ||
                  filterStatus != null ||
                  filterEmail != null ||
                  filterStartDate != null && filterEndDate != null)
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
                child: PaymentCardList(
                  transactions: provider.transactions,
                  filterTransactionId: filterQuintusId,
                  filterTransactionType: filterTransactionType,
                  filterStatus: filterStatus,
                  filterEmail: filterEmail,
                  filterStartDate: filterStartDate,
                  filterEndDate: filterEndDate,
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
