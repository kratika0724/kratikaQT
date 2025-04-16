import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qt_distributer/screens/agent/agent_card.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_textstyles.dart';
import '../../models/agent_reponse_model.dart';
import '../../providers/agent_provider.dart';
import '../../widgets/common_text_widgets.dart';
import '../agent/add_agent_screen.dart';

class AgentsScreen extends StatefulWidget {
  const AgentsScreen({super.key});

  @override
  State<AgentsScreen> createState() => AgentsScreenState();
}

class AgentsScreenState extends State<AgentsScreen> {
  String? filterName;
  String? filterEmail;
  String? filterStatus;
  int? expandedIndex;

  void toggleExpanded(int index) {
    setState(() {
      if (expandedIndex == index) {
        expandedIndex = null;
      } else {
        expandedIndex = index;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<AgentProvider>(context, listen: false).getAgentData();
    });
  }
  void openFilterBottomSheet(BuildContext context) {
    final provider = Provider.of<AgentProvider>(context, listen: false);
    final nameController = TextEditingController(text: filterName ?? '');
    final emailController = TextEditingController(text: filterEmail ?? '');

    List<String> nameSuggestions = [];
    List<String> emailSuggestions = [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            void updateNameSuggestions(String input) {
              if (input.trim().isEmpty) {
                setModalState(() => nameSuggestions = []);
                return;
              }

              final matches = provider.agents
                  .map((e) => e.firstName)
                  .where((name) =>
                  name.toLowerCase().contains(input.toLowerCase()))
                  .toSet()
                  .toList();

              matches.sort((a, b) =>
              a.toLowerCase().indexOf(input.toLowerCase()) -
                  b.toLowerCase().indexOf(input.toLowerCase()));

              setModalState(() => nameSuggestions = matches);
            }

            void updateCodeSuggestions(String input) {
              if (input.trim().isEmpty) {
                setModalState(() => emailSuggestions = []);
                return;
              }

              final matches = provider.agents
                  .map((e) => e.email)
                  .where((code) =>
                  code.toLowerCase().contains(input.toLowerCase()))
                  .toSet()
                  .toList();

              matches.sort((a, b) =>
              a.toLowerCase().indexOf(input.toLowerCase()) -
                  b.toLowerCase().indexOf(input.toLowerCase()));

              setModalState(() => emailSuggestions = matches);
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Filter Agents", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Agent First Name',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: updateNameSuggestions,
                    ),
                    if (nameSuggestions.isNotEmpty)
                      ...nameSuggestions.map(
                            (name) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: AppColors.ghostWhite,
                          ),
                          child: ListTile(
                            dense: true,
                            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                            minVerticalPadding: 0,
                            contentPadding: EdgeInsets.only(left: 8.0,right: 8.0),
                            title: Text(name,style: regularTextStyle(fontSize: dimen13, color: Colors.black),),
                            onTap: () {
                              nameController.text = name;
                              setModalState(() => nameSuggestions.clear());
                            },
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Product Code',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: updateCodeSuggestions,
                    ),
                    if (emailSuggestions.isNotEmpty)
                      ...emailSuggestions.map(
                            (code) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: AppColors.ghostWhite,
                          ),
                          child: ListTile(
                            dense: true,
                            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                            minVerticalPadding: 0,
                            contentPadding: EdgeInsets.only(left: 8.0,right: 8.0),
                            title: Text(code,style: regularTextStyle(fontSize: dimen13, color: Colors.black),),

                            onTap: () {
                              emailController.text = code;
                              setModalState(() => emailSuggestions.clear());
                            },
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                filterName = nameController.text.trim().isNotEmpty
                                    ? nameController.text.trim()
                                    : null;
                                filterEmail = emailController.text.trim().isNotEmpty
                                    ? emailController.text.trim()
                                    : null;
                              });
                              Navigator.pop(context);
                            },
                            child: const Text("Apply Filters"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                            ),
                            onPressed: () {
                              setState(() {
                                filterName = null;
                                filterEmail = null;
                              });
                              Navigator.pop(context);
                            },
                            child: const Text("Clear Filters"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  List<AgentModel> _applyFilters(List<AgentModel> agents) {
    return agents.where((agent) {
      final nameMatch = filterName == null ||
          agent.firstName.toLowerCase().contains(filterName!.toLowerCase());
      final codeMatch = filterEmail == null ||
          agent.email.toLowerCase().contains(filterEmail!.toLowerCase());
      return nameMatch && codeMatch;
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ghostWhite.withOpacity(0.7),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: HeaderTextBlack("Agents"),
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddAgentScreen()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                height: 30,
                width: 95,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: AppColors.primary.withOpacity(0.1),
                  border: Border.all(color: AppColors.secondary),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(" Add Agent ",overflow: TextOverflow.ellipsis,maxLines: 1,style: mediumTextStyle(fontSize: dimen13, color: Colors.black),),
                    Icon(Icons.add, size: 16,color: Colors.black),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
              onTap: () => openFilterBottomSheet(context),
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Container(
                  height: 30,
                  width: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    color: AppColors.primary.withOpacity(0.1),
                    border: Border.all(color: AppColors.secondary),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Filter ",overflow: TextOverflow.ellipsis,maxLines: 1,style: mediumTextStyle(fontSize: dimen13, color: Colors.black),),
                      Icon(Icons.filter_list, size: 16,color: Colors.black),
                    ],
                  ),
                ),
              ),
            ),
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        // elevation: 3,
      ),
      body: Consumer<AgentProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            return Center(child: Text("Oops! Something went wrong"));
          }

          final filteredAgents = _applyFilters(provider.agents);
          return Column(
            children: [
              if (filterName != null || filterEmail != null)
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (filterName != null || filterEmail != null)
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              if (filterName != null)
                                Chip(
                                  label: Text(
                                    "Name: $filterName",
                                    style: const TextStyle(
                                      color: AppColors.secondary,
                                      fontSize: 12,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 1,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    side: const BorderSide(color: AppColors.secondary,width: 0.7),
                                  ),
                                  backgroundColor: Colors.white,
                                  visualDensity: VisualDensity.compact,
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              if (filterEmail != null)
                                Chip(
                                  label: Text(
                                    "Code: $filterEmail",
                                    style: const TextStyle(
                                      color: AppColors.secondary,
                                      fontSize: 12,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 1,
                                  ),

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    side: const BorderSide(color: AppColors.secondary,width: 0.7),
                                  ),
                                  backgroundColor: Colors.white,
                                  visualDensity: VisualDensity.compact,
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                            ],
                          ),

                        if (filterName != null || filterEmail != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      filterName = null;
                                      filterEmail = null;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: AppColors.ghostWhite,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical:5,horizontal: 9.0),
                                      child:  Text(
                                        "Clear Filters",
                                        style: regularTextStyle(fontSize: dimen13,color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    )


                ),
              if (filteredAgents.isEmpty)
                const Expanded(
                  child: Center(child: Text("No products found")),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredAgents.length,
                    itemBuilder: (context, index) {
                      final agent = filteredAgents[index];
                      return AgentCard(
                          agent: agent,
                          isExpanded: expandedIndex == index,
                          onExpandToggle: () {
                            toggleExpanded(index);
                          },
                      );
                    },
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
