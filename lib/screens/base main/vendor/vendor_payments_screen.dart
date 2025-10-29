import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_colors.dart';
import '../../../providers/transaction_provider.dart';
import '../../../widgets/common_text_widgets.dart';
import '../../vendor_pages/vendor payments/vendor_paymentCard_list.dart';
import '../../vendor_pages/vendor payments/pending_bills_list.dart';
import 'dart:async';

class VendorPaymentsScreen extends StatefulWidget {
  const VendorPaymentsScreen({super.key});

  @override
  State<VendorPaymentsScreen> createState() => _VendorPaymentsScreenState();
}

class _VendorPaymentsScreenState extends State<VendorPaymentsScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _clearAllFiltersAndSearch();
      Provider.of<TransactionProvider>(context, listen: false)
          .getTransactions(context);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // App came back to foreground, clear search state
      _clearAllFiltersAndSearch();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Clear search and filters when page becomes active
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _clearAllFiltersAndSearch();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _clearAllFiltersAndSearch() async {
    setState(() {
      _searchQuery = '';
    });
    _searchController.clear();
    _debounceTimer?.cancel();
    // Clear provider search state
    final provider = Provider.of<TransactionProvider>(context, listen: false);
    await provider.clearSearch(context);
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });

    // Cancel previous timer
    _debounceTimer?.cancel();

    // If query is empty, clear search immediately
    if (query.isEmpty) {
      _clearSearch();
      return;
    }

    // Debounce search to avoid too many API calls
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (query.length >= 3) {
        _performSearch(query);
      }
    });
  }

  void _performSearch(String query) async {
    if (query.isEmpty) {
      // Clear search and get all transactions
      await context.read<TransactionProvider>().clearSearch(context);
      return;
    }

    // Check if query contains only digits and has 3 or more characters
    if (RegExp(r'^\d{3,}$').hasMatch(query)) {
      await context.read<TransactionProvider>().searchByMobile(context, query);
    } else {
      // Search by name
      await context.read<TransactionProvider>().searchByName(context, query);
    }
  }

  void _clearSearch() async {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
    await context.read<TransactionProvider>().clearSearch(context);
  }

  String _getSearchHint() {
    if (_searchQuery.isEmpty) {
      return 'Search by name or mobile number...';
    }

    if (RegExp(r'^\d+$').hasMatch(_searchQuery)) {
      if (_searchQuery.length >= 3) {
        return 'Searching by mobile number...';
      } else {
        return 'Type 3+ digits to search by mobile...';
      }
    } else {
      return 'Searching by name...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Clear search state before going back
        _clearAllFiltersAndSearch();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.ghostWhite.withOpacity(0.5),
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: HeaderTextWhite("Collected Payments"),
          backgroundColor: AppColors.primary,
        ),
        body: Consumer<TransactionProvider>(
          builder: (context, provider, _) {
            return Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.textWhite!),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: _getSearchHint(),
                        hintStyle: TextStyle(
                          color: AppColors.grey,
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.grey,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.grey[600],
                                ),
                                onPressed: _clearSearch,
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                // Search Section
                if (provider.isLoading)
                  Center(child: CircularProgressIndicator()),
                if (provider.errorMessage != null)
                  Center(child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(provider.errorMessage!),
                  )),
                Expanded(
                  child: provider.filteredTransactions.isEmpty &&
                          _searchQuery.isNotEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: AppColors.grey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No results found for "$_searchQuery"',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                RegExp(r'^\d{3,}$').hasMatch(_searchQuery)
                                    ? 'No mobile numbers match your search'
                                    : 'No names match your search',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : provider.filteredTransactions.isEmpty
                          ? const Center(child: Text('No transactions found.'))
                          : VendorPaymentCardList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
