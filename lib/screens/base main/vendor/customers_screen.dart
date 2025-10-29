import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_colors.dart';
import '../../../providers/customer_provider.dart';
import '../../../widgets/common_text_widgets.dart';
import '../../../widgets/filter_chips_widget.dart';
import 'CustomerList.dart';
import 'dart:async'; // Added for Timer

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen>
    with WidgetsBindingObserver {
  String? filterName;
  String? filterEmail;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Timer? _debounceTimer;

  bool get _hasFilters => filterName != null || filterEmail != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _clearAllFiltersAndSearch();
      Provider.of<CustomerProvider>(context, listen: false)
          .getCustomerData(context);
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

  void _clearAllFiltersAndSearch() {
    setState(() {
      filterName = null;
      filterEmail = null;
      _searchQuery = '';
    });
    _searchController.clear();
    _debounceTimer?.cancel();

    // Clear provider search state
    final provider = Provider.of<CustomerProvider>(context, listen: false);
    provider.clearSearch(context);
    provider.setFilters(name: null, email: null);
  }

  void _applyFilters() {
    Provider.of<CustomerProvider>(context, listen: false).setFilters(
      name: filterName,
      email: filterEmail,
    );
  }

  void _clearFilters() {
    setState(() {
      filterName = null;
      filterEmail = null;
      _applyFilters();
    });
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

  void _performSearch(String query) {
    if (query.isEmpty) {
      // Clear search and get all customers
      context.read<CustomerProvider>().clearSearch(context);
      return;
    }

    // Check if query contains only digits and has 3 or more characters
    if (RegExp(r'^\d{3,}$').hasMatch(query)) {
      context.read<CustomerProvider>().searchByMobile(context, query);
    } else {
      // Search by name
      context.read<CustomerProvider>().searchByName(context, query);
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
    context.read<CustomerProvider>().clearSearch(context);
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
    return WillPopScope(
      onWillPop: () async {
        // Clear search state before going back
        _clearAllFiltersAndSearch();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.ghostWhite.withOpacity(0.5),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: HeaderTextWhite("Customers"),
          // centerTitle: true,
          backgroundColor: AppColors.primary,
          // elevation: 3,
        ),
        body: Consumer<CustomerProvider>(
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
                      // border: Border.all(color: Colors.grey[300]!),
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
                ),
                // Search Section
                if (provider.isLoading)
                  Center(child: CircularProgressIndicator()),
                if (provider.errorMessage != null)
                  Center(child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(provider.errorMessage!),
                  )),
                if (_hasFilters)
                  FilterChipsWidget(
                    filters: {
                      'Name': filterName,
                      'Email': filterEmail,
                    },
                    onClear: _clearFilters,
                  ),
                Expanded(
                  child: provider.customers.isEmpty && _searchQuery.isNotEmpty
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
                      : provider.customers.isEmpty
                          ? const Center(child: Text('No customers found.'))
                          : CustomerList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
