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

  Widget _buildFilterButton() {
    return GestureDetector(
      onTap: () => _hasFilters ? _clearFilters() : _openFilterBottomSheet(),
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Container(
          height: 33,
          constraints: const BoxConstraints(maxWidth: 140),
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
                  _hasFilters ? "Clear Filters" : "Filter Payments",
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
        actions: [_buildFilterButton()],
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
