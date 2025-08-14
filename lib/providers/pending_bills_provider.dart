import 'package:flutter/material.dart';
import '../models/response models/pending_bills_response.dart';
import '../services/api_path.dart';
import '../services/api_service.dart';

class PendingBillsProvider with ChangeNotifier {
  final ApiService apiService = ApiService();

  bool isLoading = false;
  bool isFetchingMore = false;
  bool hasMoreData = true;
  String? errorMessage;

  List<PendingBillData> pendingBills = [];
  Meta? meta;

  int currentPage = 1;
  final int limit = 10;

  Future<void> refreshPendingBillsData(BuildContext context) async {
    currentPage = 1;
    hasMoreData = true;
    pendingBills.clear();
    await getPendingBills(context);
  }

  Future<void> getPendingBills(BuildContext context, {bool loadMore = false}) async {
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
        context,
        ApiPath.getPendingBills,
        {
          "page": currentPage.toString(),
          "limit": limit.toString(),
        },
      );

      final pendingBillsResponse = PendingBillsResponseModel.fromJson(response);

      if (pendingBillsResponse.success) {
        final newPendingBills = pendingBillsResponse.data;
        meta = pendingBillsResponse.meta;

        if (loadMore) {
          pendingBills.addAll(newPendingBills);
          currentPage++;
        } else {
          pendingBills = newPendingBills;
          currentPage = 2;
        }

        if (newPendingBills.length < limit) {
          hasMoreData = false;
          debugPrint("No more pending bills to load.");
        }
      } else {
        errorMessage = pendingBillsResponse.message;
        if (errorMessage != "No Data Found.") {
          // Fluttertoast.showToast(msg: errorMessage!);
        }
        debugPrint("Pending bills fetch failed: ${pendingBillsResponse.message}");
      }
    } catch (error) {
      errorMessage = "Error fetching pending bills: $error";
      // Fluttertoast.showToast(msg: errorMessage!);
      debugPrint(errorMessage);
    } finally {
      isLoading = false;
      isFetchingMore = false;
      notifyListeners();
    }
  }

  void clearPendingBills() {
    pendingBills.clear();
    meta = null;
    currentPage = 1;
    hasMoreData = true;
    notifyListeners();
  }
}
