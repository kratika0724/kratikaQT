import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_colors.dart';
import '../../../providers/customer_provider.dart';
import '../../../widgets/bottom_add_button.dart';
import '../../../widgets/common_text_widgets.dart';
import '../../../widgets/filter_button.dart';
import '../../../widgets/filter_chips_widget.dart';
import 'add_customer_screen.dart';
import 'customer_card_list.dart';
import 'customer_filter_bottom_sheet.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerScreen> {
  String? filterName;
  String? filterEmail;

  bool get _hasFilters => filterName != null || filterEmail != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyFilters();
      Provider.of<CustomerProvider>(context, listen: false)
          .getCustomerData(context);
    });
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

  void _openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => CustomerFilterBottomSheet(
        initialName: filterName,
        initialEmail: filterEmail,
        onApply: (name, email) {
          setState(() {
            filterName = name;
            filterEmail = email;
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
      backgroundColor: AppColors.ghostWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back)),
            SizedBox(
              width: 20,
            ),
            HeaderTextBlack("Customers"),
            Spacer(),
            // Filter or Clear Filter Button
            FilterButton(
              hasFilters: _hasFilters,
              label: "Customers",
              maxWidth: 145,
              onApplyTap: _openFilterBottomSheet,
              onClearTap: _clearFilters,
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Consumer<CustomerProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }

          if (provider.customers.isEmpty) {
            return const Center(child: Text('No customers found.'));
          }

          return Column(
            children: [
              if (_hasFilters)
                FilterChipsWidget(
                  filters: {
                    'Name': filterName,
                    'Email': filterEmail,
                  },
                  onClear: _clearFilters,
                ),
              Expanded(
                child: CustomerList(
                  customers: provider.customers,
                  filterName: filterName,
                  filterEmail: filterEmail,
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomAddButton(
        label: 'Add Customer',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddCustomerScreen(),
            ),
          );
        },
      ),
    );
  }
}
