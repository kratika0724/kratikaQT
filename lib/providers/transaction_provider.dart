import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/response models/transaction_response.dart';
import '../services/api_path.dart';
import '../services/api_service.dart';

class TransactionProvider with ChangeNotifier {
  final ApiService apiService = ApiService();

  bool isLoading = false;
  String? errorMessage;
  List<TransactionData> transactions = [];
  Meta? meta;

  Future<void> getTransactions() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await apiService.getAuth(ApiPath.getTransactions, {});
      final transactionResponse = TransactionResponseModel.fromJson(response);

      if (transactionResponse.success) {
        transactions = transactionResponse.data;
        meta = transactionResponse.meta;
      } else {
        errorMessage = transactionResponse.message;
        Fluttertoast.showToast(msg: errorMessage!);
        debugPrint("Transaction fetch failed: ${transactionResponse.message}");
      }
    } catch (error) {
      errorMessage = "Error fetching transactions: $error";
      Fluttertoast.showToast(msg: errorMessage!);
      debugPrint(errorMessage);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearTransactions() {
    transactions.clear();
    meta = null;
    notifyListeners();
  }
}
