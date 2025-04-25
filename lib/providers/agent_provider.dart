import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/add models/add_agent_model.dart';
import '../models/response models/get_agent_by_area_response.dart';
import '../models/response models/agent_response.dart';
import '../services/api_path.dart';
import '../services/api_service.dart';
import '../utils/ui_utils.dart';

class AgentProvider with ChangeNotifier {
  final ApiService apiService = ApiService();

  bool isLoading = false;
  bool isFetchingMore = false;
  bool hasMoreData = true;
  String? errorMessage;

  int currentPage_agent = 1;
  final int limit = 10;
  Meta? meta;

  List<AgentModel> agents = [];
  List<CustomerAgentByAreaData> agentsbyArea = []; // Use CustomerAgentByAreaData directly now

  String? filterName;
  String? filterEmail;
  bool? filterIsActive = true;

  void setFilters({
    String? name,
    String? email,
    bool? isActive,
  }) {
    filterName = name;
    filterEmail = email;
    filterIsActive = isActive;
    notifyListeners();
  }

  List<AgentModel> get FilteredAgents {
    return agents.where((agent) {
      final matchesName = filterName == null ||
          (agent.firstName ?? '').toLowerCase().contains(filterName!.toLowerCase());

      final matchesEmail = filterEmail == null ||
          (agent.email ?? '').toLowerCase().contains(filterEmail!.toLowerCase());

      final matchesStatus = filterIsActive == null || agent.isActive == filterIsActive;

      return matchesName && matchesEmail && matchesStatus;
    }).toList();
  }

  void createAgent(
    BuildContext context,
    TextEditingController firstnameController,
    TextEditingController middleNameController,
    TextEditingController lastnameController,
    TextEditingController emailController,
    TextEditingController mobileController,
    TextEditingController cityController,
    TextEditingController stateController,
    TextEditingController countryController,
    TextEditingController pinCodeController,
    TextEditingController assignedPinCodeController,
    TextEditingController assignedAreaController, {
    required String? gender,
    required DateTime? dob,
  })
  async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      Map<String, dynamic> body = {
        "first_name": firstnameController.text.trim(),
        "middle_name": middleNameController.text.trim(),
        "last_name": lastnameController.text.trim(),
        "email": emailController.text.trim(),
        "mobile": mobileController.text.trim(),
        "city": cityController.text.trim(),
        "state": stateController.text.trim(),
        "country": countryController.text.trim(),
        "pin": pinCodeController.text.trim(),
        "selectedPincode": assignedPinCodeController.text.trim(),
        "selectedArea": assignedAreaController.text.trim(),
        "gender": gender?.toLowerCase(),
        "dob": dob?.toIso8601String(),
      };

      final response =
          await apiService.post_auth(context, ApiPath.createAgent, body);
      final mResponse =
          AgentAddModel.fromJson(response); // reuse or make AgentAddModel

      if (mResponse.success) {
        UiUtils().showSuccessSnackBar(context, "Agent added successfully!");
        refreshAgentData(context);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            Navigator.pop(context);
          }
        });
      } else {
        // Fluttertoast.showToast(msg: "Failed to add agent: ${mResponse.message}");
        debugPrint("Failed to add agent: ${mResponse.message}");
      }
    } catch (error) {
      // Fluttertoast.showToast(msg: "Error adding agent: $error");
      debugPrint("Error adding agent: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshAgentData(BuildContext context) async {
    currentPage_agent = 1;
    hasMoreData = true;
    agents.clear();
    await getAgentData(context);
  }

  Future<void> getAgentData(BuildContext context,{bool loadMore = false}) async {
    if (loadMore) {
      if (isFetchingMore || !hasMoreData) return;
      isFetchingMore = true;
    } else {
      isLoading = true;
      currentPage_agent = 1; // reset on fresh fetch
      hasMoreData = true;
    }

    errorMessage = null;
    notifyListeners();

    try {
      final response = await apiService.getAuth(
          context,
          ApiPath.getAgent,
          {
            "page": currentPage_agent.toString(),
            "limit": limit.toString(),
          },
      );

      final agentResponse = AgentResponseModel.fromJson(response);

      if (agentResponse.success) {
        final newAgents = agentResponse.data;
        meta = agentResponse.meta;

        if (loadMore) {
          agents.addAll(newAgents);
          currentPage_agent++;
        } else {
          agents = newAgents;
          currentPage_agent = 2;
        }

        if (newAgents.length < limit) {
          hasMoreData = false;
          debugPrint("No more agents to load.");
        }
      } else {
        errorMessage = agentResponse.message;
        agents = [];
        // Fluttertoast.showToast(msg: errorMessage!);
        debugPrint("Get agent failed: ${agentResponse.message}");
      }
    } catch (error) {
      agents = [];
      errorMessage = "Error fetching agents: $error";
      // Fluttertoast.showToast(msg: errorMessage!);
      debugPrint(errorMessage);
    } finally {
      isLoading = false;
      isFetchingMore = false;
      notifyListeners();
    }
  }

  List<String> getAgentNamesByArea() {
    return agentsbyArea
        .map((agent) => agent.firstName ?? '')
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList();
  }

  Future<void> getAgentDataByArea(BuildContext context, String area) async {
    isLoading = true;
    errorMessage = null;
    agentsbyArea = []; // Clear previous agent list
    notifyListeners();

    try {
      final response =
          await apiService.getAuth(context, ApiPath.getAgentByArea, {
        'area': area,
      });

      final areaResponse = GetAgentListByAreaResponse.fromJson(response);

      if (areaResponse.success && areaResponse.data.isNotEmpty) {
        agentsbyArea = areaResponse.data;
      } else {
        agentsbyArea = []; // Clear the list if no agents found
        errorMessage = areaResponse.message.isNotEmpty
            ? areaResponse.message
            : 'No Agent Found';
        // Fluttertoast.showToast(msg: errorMessage!);
        debugPrint("Get agent failed: $errorMessage");
      }
    } catch (error) {
      agentsbyArea = []; // Clear the list in case of error
      errorMessage = "Error fetching agents: $error";
      // Fluttertoast.showToast(msg: errorMessage!);
      debugPrint(errorMessage);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearAgents() {
    agents.clear();
    meta = null;
    currentPage_agent = 1;
    hasMoreData = true;
    notifyListeners();
  }
}
