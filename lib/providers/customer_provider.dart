import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qt_distributer/models/response%20models/common_response.dart';
import '../models/response models/customer_response.dart';
import '../services/api_path.dart';
import '../services/api_service.dart';
import '../utils/ui_utils.dart';

class CustomerProvider with ChangeNotifier {
  final ApiService apiService = ApiService();

  bool isLoading = false;
  bool isFetchingMore = false;
  bool hasMoreData = true;
  String? errorMessage;

  int currentPage_customer = 1;
  final int limit = 10;
  CustomerMeta? meta;

  List<CustomerData> customers = [];

  String? filterName;
  String? filterEmail;

  void setFilters({
    String? name,
    String? email,
  }) {
    filterName = name;
    filterEmail = email;
    notifyListeners();
  }

  List<CustomerData> get FilteredCustomers {
    return customers.where((customer) {
      final matchesName = filterName == null ||
          (customer.firstName ?? '').toLowerCase().contains(filterName!.toLowerCase());
      final matchesEmail = filterEmail == null ||
          (customer.email ?? '').toLowerCase().contains(filterEmail!.toLowerCase());

      return matchesName && matchesEmail;
    }).toList();
  }

  Future<void> refreshCustomerData(BuildContext context) async {
    currentPage_customer = 1;
    hasMoreData = true;
    customers.clear();
    await getCustomerData(context);
  }

  void createCustomer(
    BuildContext context,
    TextEditingController nameController,
    TextEditingController middleNameController,
    TextEditingController lastNameController,
    TextEditingController phoneController,
    TextEditingController emailController,
    TextEditingController cityController,
    TextEditingController pincodeController,
    TextEditingController addressController,
    TextEditingController stateController,
    // TextEditingController countryController,
    {
    required String? gender,
    required String? productId,
    required String? area,
    required String? agentId,
    required DateTime? dob,
  }) async {

    if (phoneController.text.length < 10) {
      Fluttertoast.showToast(msg: "Please enter valid mobile number");
      return;
    }
    if (!EmailValidator.validate(emailController.text.trim())) {
      Fluttertoast.showToast(msg: "Please enter valid Email Id");
      return;
    }

    try {
      Map<String, dynamic> body = {
        "first_name": nameController.text.trim(),
        "middle_name": middleNameController.text.trim(),
        "last_name": lastNameController.text.trim(),
        "mobile": phoneController.text.trim(),
        "email": emailController.text.trim(),
        "dob": dob.toString(),
        "gender": gender,
        "product_id": productId,
        "address": addressController.text.trim(),
        "pin": pincodeController.text.trim(),
        "state": stateController.text.trim(),
        // "country": countryController.text.trim(),
        "area": area,
        "assinged_agent": agentId,
        "city": cityController.text.trim(),
      };

      final response = await apiService.post_auth(context, ApiPath.createCustomer, body);
      final mResponse = CommonResponse.fromJson(response);

      if (mResponse.success!) {
        UiUtils().showSuccessSnackBar(context, "Customer added successfully!");
        refreshCustomerData(context);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            Navigator.pop(context);
          }
        });
      } else {
        // Fluttertoast.showToast(msg: "Failed to add customer: ${mResponse.message}");
        debugPrint("Failed to add customer: ${mResponse.message}");
      }
    } catch (error) {
      // Fluttertoast.showToast(msg: "Error adding customer: $error");
      debugPrint("Error adding customer: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCustomerData(BuildContext context, {bool loadMore = false}) async {
    if (loadMore) {
      if (isFetchingMore || !hasMoreData) return;
      isFetchingMore = true;
    } else {
      isLoading = true;
      currentPage_customer = 1; // reset on fresh fetch
      hasMoreData = true;
    }

    errorMessage = null;
    notifyListeners();

    try {
      final response = await apiService.getAuth(
          context,
          ApiPath.getCustomer,
          {
            "page": currentPage_customer.toString(),
            "limit": limit.toString(),
          },
      );

      final customerResponse = CustomerResponse.fromJson(response);

      if (customerResponse.success) {
        final newCustomers = customerResponse.data;
        meta = customerResponse.meta;

        if (loadMore) {
          customers.addAll(newCustomers);
          currentPage_customer++;
        } else {
          customers = newCustomers;
          currentPage_customer = 2;
        }
        if (newCustomers.length < limit) {
          hasMoreData = false;
          debugPrint("No more customers to load.");
        }
      } else {
        customers = [];
        errorMessage = customerResponse.message;
        // Fluttertoast.showToast(msg: errorMessage!);
        debugPrint("Get customer failed: ${customerResponse.message}");
      }
    } catch (error) {
      customers = [];
      errorMessage = "Error fetching customers: $error";
      // Fluttertoast.showToast(msg: errorMessage!);
      debugPrint(errorMessage);
    } finally {
      isLoading = false;
      isFetchingMore = false;
      notifyListeners();
    }
  }

  void clearCustomers() {
    customers.clear();
    meta = null;
    currentPage_customer = 1;
    hasMoreData = true;
    notifyListeners();
  }

}
