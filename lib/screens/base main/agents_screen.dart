import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_textstyles.dart';
import '../../providers/agent_provider.dart';
import '../../widgets/common_text_widgets.dart';
import '../../widgets/filter_chips_widget.dart';
import '../agent/add_agent_screen.dart';
import '../agent/agent_filter_bottom_sheet.dart';
import '../agent/agent_list.dart';

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

  Widget _buildFilterButton() {
    return GestureDetector(
      onTap: () => _hasFilters ? _clearFilters() : _openFilterBottomSheet(),
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Container(
          height: 33,
          constraints: const BoxConstraints(maxWidth: 120),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: _hasFilters
                ? AppColors.secondary
                : AppColors.primary.withOpacity(0.1),
            border: Border.all(color: AppColors.secondary),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  _hasFilters ? "Clear Filters" : "Filter Agents",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: mediumTextStyle(
                    fontSize: dimen14,
                    color: _hasFilters ? Colors.white : Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                _hasFilters ? Icons.clear : Icons.filter_list,
                size: 16,
                color: _hasFilters ? Colors.white : Colors.black,
              ),
            ],
          ),
        ),
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
        actions: [_buildFilterButton()],
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
      bottomNavigationBar: Container(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 8),
            child: SizedBox(
              height: 45,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddAgentScreen()),
                  );
                },
                icon: const Icon(Icons.add, size: 18, color: Colors.white),
                label: Text(
                  'Add Agent',
                  style:
                      mediumTextStyle(fontSize: dimen15, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
