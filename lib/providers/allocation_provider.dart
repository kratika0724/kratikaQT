import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/agent_model.dart';
import '../models/agent_reponse_model.dart';
import '../models/allocation_reponse_model.dart';
import '../models/product_model.dart';
import '../models/product_response.dart';
import '../services/api_path.dart';
import '../services/api_service.dart';
import '../utils/ui_utils.dart';

class AllocationProvider with ChangeNotifier {

  bool isLoading = false;
  String? errorMessage;
  // AgentAddModel? responseModel;
  List<AllocationModel> allocations = [];


  final ApiService apiService = ApiService();

  // void createAgent(
  //     BuildContext context,
  //     TextEditingController nameController,
  //     TextEditingController codeController,
  //     TextEditingController amountController,
  //     TextEditingController quarterDiscountController,
  //     TextEditingController halfYearDiscountController,
  //     TextEditingController yearlyDiscountController,
  //     ) async {
  //   isLoading = true;
  //   errorMessage = null;
  //   notifyListeners();
  //
  //   try {
  //     Map<String, dynamic> body = {
  //       "product_name": nameController.text.trim(),
  //       "product_code": codeController.text.trim(),
  //       "product_amount": int.tryParse(amountController.text.trim()) ?? 0,
  //       "quater_discount": quarterDiscountController.text.trim(),
  //       "halfyear_discount": halfYearDiscountController.text.trim(),
  //       "yearly_discount": yearlyDiscountController.text.trim(),
  //     };
  //
  //     final response = await apiService.post_auth(ApiPath.createProduct, body);
  //     final mResponse = AgentAddModel.fromJson(response);
  //     if (mResponse.success) {
  //       UiUtils().showSuccessSnackBar(context,"Product added successfully!");
  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         if (context.mounted) {
  //           Navigator.pop(context);
  //         }
  //       });
  //     } else {
  //       Fluttertoast.showToast(msg: "Failed to add product: ${mResponse.message}");
  //       debugPrint("Failed to add product: ${mResponse.message}");
  //     }
  //   } catch (error) {
  //     Fluttertoast.showToast(msg: "Error adding product: $error");
  //     debugPrint("Error adding product: $error");
  //   }finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

  Future<void> getAllocationData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await apiService.getAuth(ApiPath.getAllocation, {});
      final allocationResponse = AllocationResponseModel.fromJson(response);

      if (allocationResponse.success) {
        allocations = allocationResponse.data;
      } else {
        errorMessage = allocationResponse.message;
        Fluttertoast.showToast(msg: errorMessage!);
        debugPrint("Get allocation failed: ${allocationResponse.message}");
      }
    } catch (error) {
      errorMessage = "Error fetching allocations: $error";
      Fluttertoast.showToast(msg: errorMessage!);
      debugPrint(errorMessage);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
