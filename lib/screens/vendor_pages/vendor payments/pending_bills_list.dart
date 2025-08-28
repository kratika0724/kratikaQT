import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/pending_bills_provider.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_textstyles.dart';
import 'pending_bill_card.dart';
import 'dart:async'; // Added for Timer

class PendingBillsList extends StatefulWidget {
  const PendingBillsList({Key? key}) : super(key: key);

  @override
  State<PendingBillsList> createState() => _PendingBillsListState();
}

class _PendingBillsListState extends State<PendingBillsList> {
  int? expandedIndex;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PendingBillsProvider>().clearSearch(context);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();

    super.dispose();
  }

  void toggleExpanded(int index) {
    setState(() {
      if (expandedIndex == index) {
        expandedIndex = null;
      } else {
        expandedIndex = index;
      }
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });

    // Cancel previous timer
    _debounceTimer?.cancel();

    // Debounce search to avoid too many API calls
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (query.length >= 3) {
        _performSearch(query);
      }
    });
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      // Clear search and get all bills
      context.read<PendingBillsProvider>().clearSearch(context);
      return;
    }

    // Check if query contains only digits and has 3 or more characters
    if (RegExp(r'^\d{3,}$').hasMatch(query)) {
      context.read<PendingBillsProvider>().searchByMobile(context, query);
    } else {
      // Search by name
      context.read<PendingBillsProvider>().searchByName(context, query);
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
    context.read<PendingBillsProvider>().clearSearch(context);
  }

  String _getSearchHint() {
    if (_searchQuery.isEmpty) {
      return 'Search by name or mobile number...';
    }

    // Check if current query is numeric
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
    return Consumer<PendingBillsProvider>(
      builder: (context, pendingBillsProvider, child) {
        if (pendingBillsProvider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  pendingBillsProvider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    pendingBillsProvider.getPendingBills(context);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        if (pendingBillsProvider.pendingBills.isEmpty) {
          Center(
            child: Text(
              'No customer found',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return Column(
          children: [
            // Search Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primary_appbar,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: _getSearchHint(),
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey[600],
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
                  const SizedBox(height: 12),

                  // Search Info
                  if (_searchQuery.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${pendingBillsProvider.pendingBills.length} result${pendingBillsProvider.pendingBills.length != 1 ? 's' : ''} found',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.grey,
                            ),
                          ),
                          const Spacer(),
                          // Show search type indicator
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              RegExp(r'^\d{3,}$').hasMatch(_searchQuery)
                                  ? 'Mobile Search'
                                  : 'Name Search',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            pendingBillsProvider.isLoading
                ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : // Bills List
                Expanded(
                    child: pendingBillsProvider.pendingBills.isEmpty &&
                            _searchQuery.isNotEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Colors.grey[400],
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
                        : RefreshIndicator(
                            onRefresh: () => pendingBillsProvider
                                .refreshPendingBillsData(context),
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 12),
                              itemCount:
                                  pendingBillsProvider.pendingBills.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 4),
                              itemBuilder: (context, index) {
                                final pendingBill =
                                    pendingBillsProvider.pendingBills[index];
                                return PendingBillCard(
                                  pendingBill: pendingBill,
                                  isExpanded: expandedIndex == index,
                                  onExpandToggle: () => toggleExpanded(index),
                                );
                              },
                            ),
                          ),
                  ),
          ],
        );
      },
    );
  }
}
