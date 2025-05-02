import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_textstyles.dart';
import '../../../providers/agent_provider.dart';
import '../../../widgets/bottom_add_button.dart';
import '../../../widgets/common_text_widgets.dart';
import '../../../widgets/filter_button.dart';
import '../../../widgets/filter_chips_widget.dart';
import '../../distributer_pages/agent/add_agent_screen.dart';
import '../../distributer_pages/agent/agent_filter_bottom_sheet.dart';
import '../../distributer_pages/agent/agent_list.dart';

class AgentsScreen extends StatefulWidget {
  const AgentsScreen({super.key});

  @override
  State<AgentsScreen> createState() => AgentsScreenState();
}

class AgentsScreenState extends State<AgentsScreen> {
  String? filterName;
  String? filterEmail;
  bool? filterIsActive = true;

  bool get _hasFilters =>
      filterName != null ||
          filterEmail != null ||
          filterIsActive != true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyFilters();
      Provider.of<AgentProvider>(context, listen: false).getAgentData(context);
    });
  }

  void _applyFilters() {
    Provider.of<AgentProvider>(context, listen: false).setFilters(
      name: filterName,
      email: filterEmail,
      isActive: filterIsActive,
    );
  }

  void _clearFilters() {
    setState(() {
      filterName = null;
      filterEmail = null;
      filterIsActive = true;
      _applyFilters();
    });
  }

  void _openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => AgentFilterBottomSheet(
        initialName: filterName,
        initialEmail: filterEmail,
        initialIsActive: filterIsActive,
        onApply: (name, email, isActive) {
          setState(() {
            filterName = name;
            filterEmail = email;
            filterIsActive = isActive;
            _applyFilters();
          });
        },
        onClear: _clearFilters,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ghostWhite.withOpacity(0.7),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: HeaderTextBlack("Agents"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: FilterButton(
              hasFilters: _hasFilters,
              label: "Agents",
              maxWidth: 125,
              onApplyTap: _openFilterBottomSheet,
              onClearTap: _clearFilters,
            ),
          ),
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Consumer<AgentProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            return const Center(child: Text("Oops! Something went wrong"));
          }
          if (provider.agents.isEmpty) {
            return const Center(child: Text("No Data Found!"));
          }

          return Column(
            children: [
              if (_hasFilters)
                FilterChipsWidget(
                  filters: {
                    'Name': filterName,
                    'Email': filterEmail,
                  },
                  onClear: _clearFilters
                ),
              Expanded(
                child: AgentList(
                  agents: provider.agents,
                  filterName: filterName,
                  filterEmail: filterEmail,
                  filterIsActive: filterIsActive,
                ),
              ),
              const SizedBox(height: 10),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomAddButton(
        label: 'Add Agent',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddAgentScreen(),
            ),
          );
        },
      ),
    );
  }
}
