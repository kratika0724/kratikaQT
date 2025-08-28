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

  // Add loading state for payment link initiation
  bool isInitiatingPayment = false;
  
  // Search related variables
  String? currentSearchQuery;
  String? currentSearchType; // 'mobile' or 'name'

  Future<void> refreshPendingBillsData(BuildContext context) async {
    currentPage = 1;
    hasMoreData = true;
    pendingBills.clear();
    await getPendingBills(context);
  }

  Future<void> getPendingBills(BuildContext context,
      {bool loadMore = false, String? searchQuery, String? searchType}) async {
    if (loadMore) {
      if (isFetchingMore || !hasMoreData) return;
      isFetchingMore = true;
    } else {
      isLoading = true;
      currentPage = 1; // reset on fresh fetch
      hasMoreData = true;
    }
    errorMessage = null;
    
    // Update search parameters
    if (searchQuery != null) {
      currentSearchQuery = searchQuery;
      currentSearchType = searchType;
    }
    
    notifyListeners();
    try {
      Map<String, String> params = {
        "page": currentPage.toString(),
        "limit": limit.toString(),
      };
      
      // Add search parameters if provided
      if (currentSearchQuery != null && currentSearchQuery!.isNotEmpty) {
        if (currentSearchType == 'mobile') {
          params['mobile'] = currentSearchQuery!;
        } else if (currentSearchType == 'name') {
          params['name'] = currentSearchQuery!;
        }
      }
      
      final response = await apiService.getAuth(
        context,
        ApiPath.getPendingBills,
        params,
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
        if (errorMessage != "No Data Found.") {}
        debugPrint(
            "Pending bills fetch failed: ${pendingBillsResponse.message}");
      }
    } catch (error) {
      errorMessage = "Error fetching pending bills: $error";
      debugPrint(errorMessage);
    } finally {
      isLoading = false;
      isFetchingMore = false;
      notifyListeners();
    }
  }

  // Search by mobile number
  Future<void> searchByMobile(BuildContext context, String mobile) async {
    await getPendingBills(context, searchQuery: mobile, searchType: 'mobile');
  }

  // Search by name
  Future<void> searchByName(BuildContext context, String name) async {
    await getPendingBills(context, searchQuery: name, searchType: 'name');
  }

  // Clear search and get all bills
  Future<void> clearSearch(BuildContext context) async {
    currentSearchQuery = null;
    currentSearchType = null;
    await getPendingBills(context);
  }

  Future<bool> initiatePaymentLink(BuildContext context,
      PendingBillData pendingBillData, double amount) async {
    isInitiatingPayment = true;
    notifyListeners();

    try {
      final response = await apiService.post_auth(
        context,
        ApiPath.intiatePaymentLink,
        {
          'userName':
              '${pendingBillData.firstName} ${pendingBillData.lastName}',
          'Email': pendingBillData.email,
          'user.mobile': pendingBillData.mobile,
          'transactionAmount': "-${pendingBillData.balance}"
        },
      );

      isInitiatingPayment = false;
      notifyListeners();

      if (response['success'] == true) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      isInitiatingPayment = false;
      notifyListeners();
      debugPrint("Error initiating payment link: $error");
      return false;
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
