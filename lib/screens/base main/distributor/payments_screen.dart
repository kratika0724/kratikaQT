import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_colors.dart';
import '../../../widgets/common_text_widgets.dart';
import '../../../widgets/filter_button.dart';
import '../../../widgets/filter_chips_widget.dart';
import '../../../providers/transaction_provider.dart';
import '../../distributer_pages/payments/payment_filter_bottom_sheet.dart';
import '../../distributer_pages/payments/payment_list.dart';

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
  String? formatted;

  bool get _hasFilters =>
      filterQuintusId != null ||
      filterEmail != null ||
      filterStatus != null ||
      filterTransactionType != null ||
      (filterStartDate != null && filterEndDate != null);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyFilters();
      Provider.of<TransactionProvider>(context, listen: false)
          .getTransactions(context);
    });
  }

  void _applyFilters() {
    Provider.of<TransactionProvider>(context, listen: false).setFilters(
      transactionId: filterQuintusId,
      email: filterEmail,
      status: filterStatus,
      transactionType: filterTransactionType,
      startDate: filterStartDate,
      endDate: filterEndDate,
    );
  }

  void _clearFilters() {
    setState(() {
      filterQuintusId = null;
      filterEmail = null;
      filterStatus = null;
      filterTransactionType = null;
      filterStartDate = null;
      filterEndDate = null;
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
      backgroundColor: AppColors.ghostWhite.withOpacity(0.7),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: HeaderTextBlack("Payments"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: FilterButton(
              hasFilters: _hasFilters,
              label: "Payments",
              maxWidth: 145,
              onApplyTap: _openFilterBottomSheet,
              onClearTap: _clearFilters,
            ),
          ),
        ],
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            return const Center(child: Text("Oops! Something went wrong"));
          }
          if (provider.transactions.isEmpty) {
            return const Center(child: Text("No Data Found!"));
          }
          if (filterStartDate != null && filterEndDate != null) {
            formatted =
                "${DateFormat('dd MMM yyyy').format(filterStartDate!)} - ${DateFormat('dd MMM yyyy').format(filterEndDate!)}";
          }

          return Column(
            children: [
              if (_hasFilters)
                FilterChipsWidget(
                  filters: {
                    'Transaction ID': filterQuintusId,
                    'Email': filterEmail,
                    'Transaction Type': filterTransactionType,
                    'Transaction Status': filterStatus,
                    'Date Range': formatted,
                  },
                  onClear: _clearFilters,
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
