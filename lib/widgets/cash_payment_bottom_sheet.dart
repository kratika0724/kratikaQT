import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qt_distributer/providers/dashboard_provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_textstyles.dart';
import '../models/response models/customer_response.dart';
import '../models/response models/cash_payment_response.dart';
import '../services/api_path.dart';
import '../services/api_service.dart';

class CashPaymentBottomSheet extends StatefulWidget {
  final String? customerEmail;
  final String? customerName;

  const CashPaymentBottomSheet({
    Key? key,
    this.customerEmail,
    this.customerName,
  }) : super(key: key);

  @override
  State<CashPaymentBottomSheet> createState() => _CashPaymentBottomSheetState();
}

class _CashPaymentBottomSheetState extends State<CashPaymentBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isLoading = false;
  bool _isSearching = false;
  bool _showSuccessPage = false;
  List<CustomerData> _searchResults = [];
  CustomerData? _selectedCustomer;
  CashPaymentResponse? _paymentResponse;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // Pre-fill email if provided
    if (widget.customerEmail != null) {
      _emailController.text = widget.customerEmail!;
      // Auto-search for the customer
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchCustomersByEmail(widget.customerEmail!);
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // Search customers by email
  Future<void> _searchCustomersByEmail(String email) async {
    if (email.isEmpty || email.length < 3) {
      setState(() {
        _searchResults = [];
        _selectedCustomer = null;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final response = await _apiService.getAuth(
        context,
        ApiPath.getCustomer,
        {"email": email},
      );

      final customerResponse = CustomerResponse.fromJson(response);

      if (customerResponse.success) {
        setState(() {
          _searchResults = customerResponse.data;
          _selectedCustomer = null; // Reset selection when new search
        });
      } else {
        setState(() {
          _searchResults = [];
          _selectedCustomer = null;
        });
      }
    } catch (error) {
      setState(() {
        _searchResults = [];
        _selectedCustomer = null;
      });
      debugPrint('Error searching customers: $error');
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  // Select customer from dropdown
  void _selectCustomer(CustomerData customer) {
    setState(() {
      _selectedCustomer = customer;
      _emailController.text = customer.email;
      _searchResults = []; // Clear search results when customer is selected
    });
  }

  // Process cash payment
  Future<void> _processCashPayment() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final amount = int.parse(_amountController.text.trim());
        final customerId = _selectedCustomer?.id;

        if (customerId == null) {
          throw Exception('Customer ID is required');
        }

        final payload = {
          "amount": amount,
          "id": customerId,
        };
        final response = await _apiService.post_auth(
          context,
          ApiPath.cashBalance,
          payload,
        );
        final paymentResponse = CashPaymentResponse.fromJson(response);
        if (paymentResponse.success) {
          DashboardProvider provider =
              Provider.of<DashboardProvider>(context, listen: false);
          provider.getDatabyId(context);
          setState(() {
            _paymentResponse = paymentResponse;
            _showSuccessPage = true;
            _isLoading = false;
          });
        } else {
          throw Exception(paymentResponse.message);
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Payment failed: ${e.toString()}'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      }
    }
  }

  // Reset to payment form
  void _resetToPaymentForm() {
    setState(() {
      _showSuccessPage = false;
      _paymentResponse = null;
      _selectedCustomer = null;
      _emailController.clear();
      _amountController.clear();
      _searchResults = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24.0,
          right: 24.0,
          top: 24.0,
        ),
        child: _showSuccessPage ? _buildSuccessPage() : _buildPaymentForm(),
      ),
    );
  }

  Widget _buildSuccessPage() {
    if (_paymentResponse == null) return const SizedBox.shrink();

    return SingleChildScrollView(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Success Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 50,
              ),
            ),
            const SizedBox(height: 16),

            // Success Title
            Text(
              "Payment Successful!",
              style: boldTextStyle(
                fontSize: dimen20,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),

            // Success Message
            Text(
              _paymentResponse!.message,
              style: mediumTextStyle(
                fontSize: dimen14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Payment Details Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  _buildDetailRow("User Balance",
                      "₹${_paymentResponse!.userBalance.toStringAsFixed(2)}"),
                  const SizedBox(height: 8),
                  _buildDetailRow("Amount Paid",
                      "₹${_paymentResponse!.walletAmountToPay.toStringAsFixed(2)}",
                      isHighlighted: true),
                  const SizedBox(height: 8),
                  _buildDetailRow("Updated Balance",
                      "₹${_paymentResponse!.updatedBalance.toStringAsFixed(2)}"),
                  const SizedBox(height: 8),
                  _buildDetailRow("Previous Lien",
                      "₹${_paymentResponse!.previousLien.toStringAsFixed(2)}"),
                  const SizedBox(height: 8),
                  _buildDetailRow("Updated Lien",
                      "₹${_paymentResponse!.updatedLien.toStringAsFixed(2)}"),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Customer Info
            if (_selectedCustomer != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.person,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedCustomer!.email,
                            style: mediumTextStyle(
                              fontSize: dimen14,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            '${_selectedCustomer!.firstName ?? ''} ${_selectedCustomer!.middleName ?? ''} ${_selectedCustomer!.lastName ?? ''}'
                                .trim(),
                            style: regularTextStyle(
                              fontSize: dimen12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetToPaymentForm,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: AppColors.primary),
                    ),
                    child: Text(
                      'New Payment',
                      style: mediumTextStyle(
                        fontSize: dimen16,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Close',
                      style: mediumTextStyle(
                        fontSize: dimen16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ],
    ));
  }

  Widget _buildDetailRow(String label, String value,
      {bool isHighlighted = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: mediumTextStyle(
            fontSize: dimen14,
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: boldTextStyle(
            fontSize: dimen14,
            color: isHighlighted ? AppColors.primary : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentForm() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(
                  Icons.payment,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cash Payment",
                      style: boldTextStyle(
                        fontSize: dimen20,
                        color: Colors.black87,
                      ),
                    ),
                    if (widget.customerName != null)
                      Text(
                        "for ${widget.customerName}",
                        style: mediumTextStyle(
                          fontSize: dimen14,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Enter payment details to proceed",
            style: mediumTextStyle(
              fontSize: dimen14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          // Form
          Form(
            key: _formKey,
            child: Column(
              children: [
                // Email Field with Search
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      enabled: widget.customerEmail ==
                          null, // Disable if email is pre-filled
                      onChanged: widget.customerEmail == null
                          ? (value) {
                              // Debounce the search
                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
                                if (mounted) {
                                  _searchCustomersByEmail(value);
                                }
                              });
                            }
                          : null,
                      decoration: InputDecoration(
                        labelText: 'Email ID',
                        hintText: widget.customerEmail != null
                            ? 'Customer email'
                            : 'Enter email address',
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: AppColors.primary,
                        ),
                        suffixIcon: _isSearching
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : widget.customerEmail != null
                                ? const Icon(
                                    Icons.lock,
                                    color: Colors.grey,
                                    size: 20,
                                  )
                                : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                              color: AppColors.primary, width: 2),
                        ),
                        filled: true,
                        fillColor: widget.customerEmail != null
                            ? Colors.grey[100]
                            : Colors.grey[50],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email address';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        if (_selectedCustomer == null) {
                          return 'Please select a customer from the list';
                        }
                        return null;
                      },
                    ),

                    // Search Results Dropdown
                    if (_searchResults.isNotEmpty &&
                        _emailController.text.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final customer = _searchResults[index];
                            final isSelected =
                                _selectedCustomer?.id == customer.id;
                            return ListTile(
                              dense: true,
                              title: Text(
                                customer.email,
                                style: TextStyle(
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.black87,
                                ),
                              ),
                              subtitle: Text(
                                '${customer.firstName ?? ''} ${customer.middleName ?? ''} ${customer.lastName ?? ''}'
                                    .trim(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              tileColor: isSelected
                                  ? AppColors.primary.withOpacity(0.1)
                                  : null,
                              onTap: () => _selectCustomer(customer),
                            );
                          },
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Amount Field
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    hintText: 'Enter amount',
                    prefixIcon: const Icon(
                      Icons.currency_rupee_outlined,
                      color: AppColors.primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          const BorderSide(color: AppColors.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter amount';
                    }
                    final amount = int.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _processCashPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 2,
                      shadowColor: AppColors.primary.withOpacity(0.3),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.payment, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Process Payment',
                                style: boldTextStyle(
                                  fontSize: dimen16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
