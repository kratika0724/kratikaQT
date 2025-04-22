import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/add models/add_product_model.dart';
import '../models/response models/product_response.dart';
import '../services/api_path.dart';
import '../services/api_service.dart';
import '../utils/ui_utils.dart';

class ProductProvider with ChangeNotifier {

  bool isLoading = false;
  String? errorMessage;
  ProductAddModel? responseModel;
  List<ProductModel> products = [];


  final ApiService apiService = ApiService();

  void createProduct(
      BuildContext context,
      TextEditingController nameController,
      TextEditingController codeController,
      TextEditingController amountController,
      TextEditingController quarterDiscountController,
      TextEditingController halfYearDiscountController,
      TextEditingController yearlyDiscountController,
      ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      Map<String, dynamic> body = {
        "product_name": nameController.text.trim(),
        "product_code": codeController.text.trim(),
        "product_amount": int.tryParse(amountController.text.trim()) ?? 0,
        "quater_discount": quarterDiscountController.text.trim(),
        "halfyear_discount": halfYearDiscountController.text.trim(),
        "yearly_discount": yearlyDiscountController.text.trim(),
      };

      final response = await apiService.post_auth(ApiPath.createProduct, body);
      final mResponse = ProductAddModel.fromJson(response);
      if (mResponse.success) {
        UiUtils().showSuccessSnackBar(context,"Product added successfully!");
        getProductData();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              Navigator.pop(context);
            }
          });
      } else {
        Fluttertoast.showToast(msg: "Failed to add product: ${mResponse.message}");
        debugPrint("Failed to add product: ${mResponse.message}");
      }
    } catch (error) {
      Fluttertoast.showToast(msg: "Error adding product: $error");
      debugPrint("Error adding product: $error");
    }finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getProductData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await apiService.getAuth(ApiPath.getProduct, {});
      final productResponse = ProductResponseModel.fromJson(response);

      if (productResponse.success) {
        products = productResponse.data;
      } else {
        errorMessage = productResponse.message;
        Fluttertoast.showToast(msg: errorMessage!);
        debugPrint("Get product failed: ${productResponse.message}");
      }
    } catch (error) {
      errorMessage = "Error fetching products: $error";
      Fluttertoast.showToast(msg: errorMessage!);
      debugPrint(errorMessage);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}





