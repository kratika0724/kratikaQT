import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_textstyles.dart';
import '../../../providers/customer_provider.dart';
import '../../../widgets/common_text_widgets.dart';
import '../../distributer_pages/customer/customer_card_list.dart';
import '../../distributer_pages/customer/customer_filter_bottom_sheet.dart';
import '../../distributer_pages/customer/add_customer_screen.dart';
import '../../../widgets/filter_button.dart';
import '../../../widgets/filter_chips_widget.dart';
import '../../../widgets/bottom_add_button.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
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
      backgroundColor: AppColors.ghostWhite.withOpacity(0.5),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: HeaderTextBlack("Customers"),
        // centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        // elevation: 3,
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
    );
  }
}
