import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/add_allocation_model.dart';
import '../models/allocation_reponse_model.dart';
import '../services/api_path.dart';
import '../services/api_service.dart';
import '../utils/ui_utils.dart';

class AllocationProvider with ChangeNotifier {

  bool isLoading = false;
  String? errorMessage;
  AddAllocationModel? responseModel;
  List<AllocationModel> allocations = [];


  final ApiService apiService = ApiService();

  void createAllocation(
      BuildContext context,
      TextEditingController pincodeController,
      TextEditingController areaController,
      ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      Map<String, dynamic> body = {
        "allocation_pincode": pincodeController.text.trim(),
        "allocation_area": areaController.text.trim(),
      };

      final response = await apiService.post_auth(ApiPath.createProduct, body);
      final mResponse = AddAllocationModel.fromJson(response);
      if (mResponse.success) {
        UiUtils().showSuccessSnackBar(context,"Allocation added successfully!");
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            Navigator.pop(context);
          }
        });
      } else {
        Fluttertoast.showToast(msg: "Failed to add allocation: ${mResponse.message}");
        debugPrint("Failed to add product: ${mResponse.message}");
      }
    } catch (error) {
      Fluttertoast.showToast(msg: "Error adding allocation: $error");
      debugPrint("Error adding allocation: $error");
    }finally {
      isLoading = false;
      notifyListeners();
    }
  }

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
