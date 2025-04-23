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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AgentProvider>(context, listen: false).getAgentData();
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
          });
        },
        onClear: () {
          setState(() {
            filterName = null;
            filterEmail = null;
            filterIsActive = true;
          });
        },
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
          // Add Agent Button
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddAgentScreen()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                height: 30,
                constraints: const BoxConstraints(maxWidth: 110),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: AppColors.primary.withOpacity(0.1),
                  border: Border.all(color: AppColors.secondary),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        "Add Agent",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: mediumTextStyle(fontSize: dimen13, color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.add, size: 16, color: Colors.black),
                  ],
                ),
              ),
            ),
          ),

          // Filter Button
          GestureDetector(
            onTap: () => _openFilterBottomSheet(),
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Container(
                height: 30,
                constraints: const BoxConstraints(maxWidth: 80),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: AppColors.primary.withOpacity(0.1),
                  border: Border.all(color: AppColors.secondary),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        "Filter",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: mediumTextStyle(fontSize: dimen13, color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.filter_list, size: 16, color: Colors.black),
                  ],
                ),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Consumer<AgentProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) return const Center(child: CircularProgressIndicator());
          if (provider.errorMessage != null) return const Center(child: Text("Oops! Something went wrong"));

          return Column(
            children: [
              if (filterName != null || filterEmail != null)
                FilterChipsWidget(
                  filters: {
                    'Name': filterName,
                    'Email': filterEmail,

                  },
                  onClear: () => setState(() {
                    filterEmail = null;
                    filterName = null;
                  }),
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
    );
  }
}
