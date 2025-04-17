import 'package:flutter/material.dart';
import '../../models/response models/agent_response.dart';
import '../../utils/device_utils.dart';
import 'agent_card.dart';

class AgentList extends StatefulWidget {
  final List<AgentModel> agents;
  final String? filterName;
  final String? filterEmail;

  const AgentList({
    super.key,
    required this.agents,
    this.filterName,
    this.filterEmail,
  });

  @override
  State<AgentList> createState() => _AgentListState();
}

class _AgentListState extends State<AgentList> {
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
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final filteredAgents = widget.agents.where((agent) {
      final matchesName = widget.filterName == null || agent.firstName?.contains(widget.filterName!) == true;
      final matchesEmail = widget.filterEmail == null || agent.email?.toLowerCase().contains(widget.filterEmail!.toLowerCase()) == true;
      return matchesName && matchesEmail;
    }).toList();

    if (filteredAgents.isEmpty) {
      return const Center(child: Text("No agents found."));
    }

    final isWide = DeviceUtils.getDeviceWidth(context);

    return isWide
        ? GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: filteredAgents.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 300, // Adjust height as needed
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        return AgentCard(
          agent: filteredAgents[index],
          isExpanded: expandedIndex == index,
          onExpandToggle: () => toggleExpanded(index),
        );
      },
    )
        : ListView.builder(
      itemCount: filteredAgents.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: AgentCard(
            agent: filteredAgents[index],
            isExpanded: expandedIndex == index,
            onExpandToggle: () => toggleExpanded(index),
          ),
        );
      },
    );
  }
}
