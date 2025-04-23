import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/response models/transaction_response.dart';
import '../services/api_path.dart';
import '../services/api_service.dart';

class TransactionProvider with ChangeNotifier {
  final ApiService apiService = ApiService();

  bool isLoading = false;
  bool isFetchingMore = false;
  bool hasMoreData = true;
  String? errorMessage;

  String? filterTransactionId;
  String? filterStatus;
  String? filterTransactionType;
  String? filterEmail;
  DateTime? filterStartDate;
  DateTime? filterEndDate;

  void setFilters({
    String? transactionId,
    String? status,
    String? transactionType,
    String? email,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    filterTransactionId = transactionId;
    filterStatus = status;
    filterTransactionType = transactionType;
    filterEmail = email;
    filterStartDate = startDate;
    filterEndDate = endDate;
    notifyListeners();
  }



  List<TransactionData> transactions = [];
  Meta? meta;

  int currentPage = 1;
  final int limit = 10;


  List<TransactionData> get filteredTransactions {
    return transactions.where((txn) {
      final matchesId = filterTransactionId == null ||
          (txn.quintusTransactionId ?? '').toLowerCase().contains(filterTransactionId!.toLowerCase());

      final matchesEmail = filterEmail == null ||
          (txn.user.email ?? '').toLowerCase().contains(filterEmail!.toLowerCase());

      final matchesStatus = filterStatus == null ||
          (txn.status ?? '').toLowerCase().contains(filterStatus!.toLowerCase());

      final matchesTransactionType = filterTransactionType == null ||
          (txn.walletHistory.transactionType ?? '').toLowerCase().contains(filterTransactionType!.toLowerCase());

      final matchesDateRange = filterStartDate == null || filterEndDate == null
          ? true
          : (txn.createdAt.isAfter(filterStartDate!.subtract(const Duration(days: 1))) &&
          txn.createdAt.isBefore(filterEndDate!.add(const Duration(days: 1))));

      return matchesId && matchesStatus && matchesTransactionType && matchesEmail && matchesDateRange;
    }).toList();
  }


  Future<void> refreshTransactionData() async {
    currentPage = 1;
    hasMoreData = true;
    transactions.clear();
    await getTransactions();
  }

  // Future<void> getTransactions({bool loadMore = false}) async {
  //   if (loadMore) {
  //     if (isFetchingMore || !hasMoreData) return;
  //     isFetchingMore = true;
  //   } else {
  //     isLoading = true;
  //     currentPage = 1; // reset on fresh fetch
  //     hasMoreData = true;
  //   }
  //
  //   errorMessage = null;
  //   notifyListeners();
  //
  //   try {
  //     final response = await apiService.getAuth(
  //       ApiPath.getTransactions,
  //       {
  //         "page": currentPage.toString(),
  //         "limit": limit.toString(),
  //       },
  //     );
  //
  //     final transactionResponse = TransactionResponseModel.fromJson(response);
  //
  //     if (transactionResponse.success) {
  //       final newTransactions = transactionResponse.data;
  //       meta = transactionResponse.meta;
  //
  //       if (loadMore) {
  //         transactions.addAll(newTransactions);
  //         currentPage++;
  //       } else {
  //         transactions = newTransactions;
  //         currentPage = 2;
  //       }
  //
  //       if (newTransactions.length < limit) {
  //         hasMoreData = false;
  //         debugPrint("No more transactions to load.");
  //       }
  //
  //     } else {
  //       errorMessage = transactionResponse.message;
  //       Fluttertoast.showToast(msg: errorMessage!);
  //       debugPrint("Transaction fetch failed: ${transactionResponse.message}");
  //     }
  //   } catch (error) {
  //     errorMessage = "Error fetching transactions: $error";
  //     Fluttertoast.showToast(msg: errorMessage!);
  //     debugPrint(errorMessage);
  //   } finally {
  //     isLoading = false;
  //     isFetchingMore = false;
  //     notifyListeners();
  //   }
  // }

  Future<void> getTransactions({bool loadMore = false}) async {
    if (loadMore) {
      if (isFetchingMore || !hasMoreData) return;
      isFetchingMore = true;
    } else {
      isLoading = true;
      currentPage = 1; // reset on fresh fetch
      hasMoreData = true;
    }

    errorMessage = null;
    notifyListeners();

    try {
      final response = await apiService.getAuth(
        ApiPath.getTransactions,
        {
          "page": currentPage.toString(),
          "limit": limit.toString(),
        },
      );

      final transactionResponse = TransactionResponseModel.fromJson(response);

      if (transactionResponse.success) {
        final newTransactions = transactionResponse.data;
        meta = transactionResponse.meta;

        if (loadMore) {
          transactions.addAll(newTransactions);
          currentPage++;
        } else {
          transactions = newTransactions;
          currentPage = 2;
        }

        if (newTransactions.length < limit) {
          hasMoreData = false;
          debugPrint("No more transactions to load.");
        }

      } else {
        errorMessage = transactionResponse.message;
        // Check if the message is "No Data Found" before showing the toast
        if (errorMessage != "No Data Found.") {
          Fluttertoast.showToast(msg: errorMessage!);
        }
        debugPrint("Transaction fetch failed: ${transactionResponse.message}");
      }
    } catch (error) {
      errorMessage = "Error fetching transactions: $error";
      Fluttertoast.showToast(msg: errorMessage!);
      debugPrint(errorMessage);
    } finally {
      isLoading = false;
      isFetchingMore = false;
      notifyListeners();
    }
  }

  void clearTransactions() {
    transactions.clear();
    meta = null;
    currentPage = 1;
    hasMoreData = true;
    notifyListeners();
  }
}

