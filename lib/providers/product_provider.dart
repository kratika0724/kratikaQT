import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/add models/add_product_model.dart';
import '../models/response models/product_response.dart';
import '../services/api_path.dart';
import '../services/api_service.dart';
import '../utils/ui_utils.dart';

class ProductProvider with ChangeNotifier {
  final ApiService apiService = ApiService();

  bool isLoading = false;
  bool isFetchingMore = false;
  bool hasMoreData = true;
  String? errorMessage;

  int currentPage_product = 1;
  final int limit = 10;
  Meta? meta;

  List<ProductModel> products = [];

  String? filterName;
  String? filterCode;

  void setFilters({
    String? name,
    String? code,
  }) {
    filterName = name;
    filterCode = code;
    notifyListeners();
  }

  List<ProductModel> get FilteredProducts {
    return products.where((product) {
      final matchesName = filterName == null ||
          (product.productName ?? '').toLowerCase().contains(filterName!.toLowerCase());
      final matchesCode = filterCode == null ||
          (product.productCode ?? '').toLowerCase().contains(filterCode!.toLowerCase());
      return matchesName && matchesCode;
    }).toList();
  }


  List<String> getProductNames() {
    return products
        .map((p) => p.productName ?? '')
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList();
  }

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

      final response =
          await apiService.post_auth(context, ApiPath.createProduct, body);
      final mResponse = ProductAddModel.fromJson(response);
      if (mResponse.success) {
        UiUtils().showSuccessSnackBar(context, "Product added successfully!");
        refreshProductData(context); // Reset and reload all data
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            Navigator.pop(context);
          }
        });
      } else {
        Fluttertoast.showToast(
            msg: "Failed to add product: ${mResponse.message}");
        debugPrint("Failed to add product: ${mResponse.message}");
      }
    } catch (error) {
      Fluttertoast.showToast(msg: "Error adding product: $error");
      debugPrint("Error adding product: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshProductData(BuildContext context) async {
    currentPage_product = 1;
    hasMoreData = true;
    products.clear();
    await getProductData(context);
  }

  Future<void> getProductData(BuildContext context, {bool loadMore = false}) async {
    if (loadMore) {
      if (isFetchingMore || !hasMoreData) return;
      isFetchingMore = true;
    } else {
      isLoading = true;
      currentPage_product = 1; // reset on fresh fetch
      hasMoreData = true; // reset hasMoreData on fresh fetch
    }

    errorMessage = null;
    notifyListeners();

    try {
      final response = await apiService.getAuth(
        context,
        ApiPath.getProduct,
        {
          "page": currentPage_product.toString(),
          "limit": limit.toString(),
        },
      );

      final productResponse = ProductResponseModel.fromJson(response);

      if (productResponse.success) {
        final newProducts = productResponse.data;

        debugPrint(
            "Fetched Page: $currentPage_product | Items: ${newProducts.length}");

        if (loadMore) {
          products.addAll(newProducts);
          currentPage_product++;
        } else {
          products = newProducts;
          currentPage_product = 2;
        }

        if (newProducts.length < limit) {
          hasMoreData = false;
          debugPrint("No more products to load.");
        }
      } else {
        errorMessage = productResponse.message;
        products = [];
        Fluttertoast.showToast(msg: errorMessage!);
        debugPrint("Get product failed: ${productResponse.message}");
      }
    } catch (error) {
      products = [];
      errorMessage = "Error fetching products: $error";
      Fluttertoast.showToast(msg: errorMessage!);
      debugPrint(errorMessage);
    } finally {
      isLoading = false;
      isFetchingMore = false;
      notifyListeners();
    }
  }

  void clearProducts() {
    products.clear();
    meta = null;
    currentPage_product = 1;
    hasMoreData = true;
    notifyListeners();
  }
}
