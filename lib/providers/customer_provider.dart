import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/add models/add_customer_model.dart';
import '../models/response models/customer_response.dart';
import '../services/api_path.dart';
import '../services/api_service.dart';
import '../utils/ui_utils.dart';

class CustomerProvider with ChangeNotifier {
  bool isLoading = false;
  bool isFetchingMore = false;
  bool hasMoreData = true;
  String? errorMessage;
  List<CustomerData> customers = [];


  int currentPage_customer = 1;
  final int limit = 10;
  final ApiService apiService = ApiService();

  void createCustomer(
      BuildContext context,
      TextEditingController nameController,
      TextEditingController middleNameController,
      TextEditingController lastNameController,
      TextEditingController phoneController,
      TextEditingController emailController,
      TextEditingController cityController,
      TextEditingController pincodeController,
      TextEditingController stateController,
      TextEditingController countryController,
      {
        required String? gender,
        required String? productId,
        required String? area,
        required String? agentId,
        required DateTime? dob,
      }
      ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      Map<String, dynamic> body = {
        "first_name": nameController.text.trim(),
        "middle_name": middleNameController.text.trim(),
        "last_name": lastNameController.text.trim(),
        "mobile": phoneController.text.trim(),
        "email": emailController.text.trim(),
        "city": cityController.text.trim(),
        "pin": pincodeController.text.trim(),
        "state": stateController.text.trim(),
        "country": countryController.text.trim(),
        "gender": gender,
        "product_id": productId,
        "area": area,
        "assinged_agent": agentId,
        "dob": dob.toString(),
      };

      final response = await apiService.post_auth(ApiPath.createCustomer, body);
      final mResponse = CustomerAddModel.fromJson(response);

      if (mResponse.success) {
        UiUtils().showSuccessSnackBar(context, "Customer added successfully!");
        refreshCustomerData();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            Navigator.pop(context);
          }
        });
      } else {
        Fluttertoast.showToast(msg: "Failed to add customer: ${mResponse.message}");
        debugPrint("Failed to add customer: ${mResponse.message}");
      }
    } catch (error) {
      Fluttertoast.showToast(msg: "Error adding customer: $error");
      debugPrint("Error adding customer: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCustomerData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await apiService.getAuth(ApiPath.getCustomer, {});
      final customerResponse = CustomerResponse.fromJson(response);

      if (customerResponse.success) {
        customers = customerResponse.data;
      } else {
        customers = [];
        errorMessage = customerResponse.message;
        Fluttertoast.showToast(msg: errorMessage!);
        debugPrint("Get customer failed: ${customerResponse.message}");
      }
    } catch (error) {
      customers = [];
      errorMessage = "Error fetching customers: $error";
      Fluttertoast.showToast(msg: errorMessage!);
      debugPrint(errorMessage);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  Future<void> refreshCustomerData() async {
    currentPage_customer = 1;
    hasMoreData = true;
    customers.clear();
    await getCustomerData();
  }


}
