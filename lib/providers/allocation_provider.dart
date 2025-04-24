import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/add models/add_allocation_model.dart';
import '../models/response models/allocation_response.dart';
import '../services/api_path.dart';
import '../services/api_service.dart';
import '../utils/ui_utils.dart';

class AllocationProvider with ChangeNotifier {
  bool isLoading = false;
  bool isFetchingMore = false;
  bool hasMoreData = true;
  String? errorMessage;
  AllocationAddModel? responseModel;
  List<AllocationModel> allocations = [];

  String? selectedFileName;
  int currentPage_allocation = 1;
  final int limit = 10;
  final ApiService apiService = ApiService();

  List<String> getPincodeList() {
    return allocations
        .map((a) => a.allocationPincode ?? '')
        .where((pincode) => pincode.isNotEmpty)
        .toSet()
        .toList();
  }

  List<String> getAreaList(String selectedPincode) {
    return allocations
        .where((a) => a.allocationPincode == selectedPincode)
        .map((a) => a.allocationArea ?? '')
        .where((area) => area.isNotEmpty)
        .toSet()
        .toList();
  }

  Future<void> createbulkAllocation(
    BuildContext context,
    String pincode,
    String area,
  ) async {
    isLoading = false;
    errorMessage = null;
    notifyListeners();

    try {
      Map<String, dynamic> body = {
        "allocation_pincode": pincode.trim(),
        "allocation_area": area.trim(),
      };

      final response =
          await apiService.post_auth(ApiPath.createAllocation, body);
      final mResponse = AllocationAddModel.fromJson(response);
      if (mResponse.success) {
        UiUtils()
            .showSuccessSnackBar(context, "Allocation added successfully!");
      } else {
        Fluttertoast.showToast(
            msg: "Failed to add allocation: ${mResponse.message}");
        debugPrint("Failed to add allocation: ${mResponse.message}");
      }
    } catch (error) {
      Fluttertoast.showToast(msg: "Error adding allocation: $error");
      debugPrint("Error adding allocation: $error");
    } finally {
      notifyListeners();
    }
  }

  // Method to create a new allocation
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

      final response =
          await apiService.post_auth(ApiPath.createAllocation, body);
      final mResponse = AllocationAddModel.fromJson(response);
      if (mResponse.success) {
        UiUtils()
            .showSuccessSnackBar(context, "Allocation added successfully!");
        refreshAllocationData(); // Reset and reload all data
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            Navigator.pop(context);
          }
        });
      } else {
        Fluttertoast.showToast(
            msg: "Failed to add allocation: ${mResponse.message}");
        debugPrint("Failed to add allocation: ${mResponse.message}");
      }
    } catch (error) {
      Fluttertoast.showToast(msg: "Error adding allocation: $error");
      debugPrint("Error adding allocation: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Refresh allocation data and reset pagination
  Future<void> refreshAllocationData() async {
    currentPage_allocation = 1;
    hasMoreData = true;
    allocations.clear();
    await getAllocationData();
  }

  Future<void> select_excelFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (result != null) {
        selectedFileName = result.files.single.name;
        notifyListeners();

        var bytes = File(result.files.single.path!).readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);
        var sheet = excel.tables.keys.first;
        var table = excel.tables[sheet]!;

        print('Excel Data:');

        // Await each call to createbulkAllocation sequentially
        for (var row in table.rows) {
          if (row.isNotEmpty) {
            await createbulkAllocation(
              context,
              '${row[0]?.value}',
              '${row[1]?.value}',
            );
          }
        }

        // Only show the success message after all rows are processed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Excel file processed successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error processing Excel file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Fetch allocation data, with pagination support
  Future<void> getAllocationData({bool loadMore = false}) async {
    if (loadMore) {
      if (isFetchingMore || !hasMoreData) return;
      isFetchingMore = true;
    } else {
      isLoading = true;
      currentPage_allocation = 1; // reset on fresh fetch
      hasMoreData = true; // reset hasMoreData on fresh fetch
    }

    errorMessage = null;
    notifyListeners();

    try {
      final response = await apiService.getAuth(
        ApiPath.getAllocation,
        {
          "page": currentPage_allocation.toString(),
          "limit": limit.toString(),
        },
      );

      final allocationResponse = AllocationResponseModel.fromJson(response);

      if (allocationResponse.success) {
        final newAllocations = allocationResponse.data;

        debugPrint(
            "Fetched Page: $currentPage_allocation | Items: ${newAllocations.length}");

        if (loadMore) {
          allocations.addAll(newAllocations);
          currentPage_allocation++;
        } else {
          allocations = newAllocations;
          currentPage_allocation = 2;
        }

        if (newAllocations.length < limit) {
          hasMoreData = false;
          debugPrint("No more data to load.");
        }
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
      isFetchingMore = false;
      notifyListeners();
    }
  }
}

// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import '../models/add models/add_allocation_model.dart';
// import '../models/response models/allocation_response.dart';
// import '../services/api_path.dart';
// import '../services/api_service.dart';
// import '../utils/ui_utils.dart';
//
// class AllocationProvider with ChangeNotifier {
//
//   bool isLoading = false;
//   String? errorMessage;
//   AllocationAddModel? responseModel;
//   List<AllocationModel> allocations = [];
//
//
//   final ApiService apiService = ApiService();
//
//   void createAllocation(
//       BuildContext context,
//       TextEditingController pincodeController,
//       TextEditingController areaController,
//       ) async {
//     isLoading = true;
//     errorMessage = null;
//     notifyListeners();
//
//     try {
//       Map<String, dynamic> body = {
//         "allocation_pincode": pincodeController.text.trim(),
//         "allocation_area": areaController.text.trim(),
//       };
//
//       final response = await apiService.post_auth(ApiPath.createAllocation, body);
//       final mResponse = AllocationAddModel.fromJson(response);
//       if (mResponse.success) {
//         UiUtils().showSuccessSnackBar(context,"Allocation added successfully!");
//         getAllocationData();
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (context.mounted) {
//             Navigator.pop(context);
//           }
//         });
//       } else {
//         Fluttertoast.showToast(msg: "Failed to add allocation: ${mResponse.message}");
//         debugPrint("Failed to add product: ${mResponse.message}");
//       }
//     } catch (error) {
//       Fluttertoast.showToast(msg: "Error adding allocation: $error");
//       debugPrint("Error adding allocation: $error");
//     }finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<void> getAllocationData() async {
//     isLoading = true;
//     errorMessage = null;
//     notifyListeners();
//
//     try {
//       final response = await apiService.getAuth(ApiPath.getAllocation, {});
//       final allocationResponse = AllocationResponseModel.fromJson(response);
//
//       if (allocationResponse.success) {
//         allocations = allocationResponse.data;
//       } else {
//         errorMessage = allocationResponse.message;
//         Fluttertoast.showToast(msg: errorMessage!);
//         debugPrint("Get allocation failed: ${allocationResponse.message}");
//       }
//     } catch (error) {
//       errorMessage = "Error fetching allocations: $error";
//       Fluttertoast.showToast(msg: errorMessage!);
//       debugPrint(errorMessage);
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }
// }
