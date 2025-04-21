import 'package:flutter/material.dart';
import '../../models/response models/agent_response.dart';
import '../../utils/device_utils.dart';
import 'agent_card.dart';

class AgentList extends StatefulWidget {
  final List<AgentModel> agents;
  final String? filterName;
  final String? filterEmail;
  final bool? filterIsActive;

  const AgentList({
    super.key,
    required this.agents,
    this.filterName,
    this.filterEmail,
    this.filterIsActive,
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
    final isWide = DeviceUtils.getDeviceWidth(context);
    final filteredAgents = _getFilteredAgents();

    if (filteredAgents.isEmpty) {
      return const Center(
          child: Text("No agents found.")
      );
    }
    return isWide
        ? _buildGridView(filteredAgents)
        : _buildListView(filteredAgents);
  }

  List<AgentModel> _getFilteredAgents() {
    return widget.agents.where((agent) {
      final matchesName = widget.filterName == null ||
          (agent.firstName ?? '').toLowerCase().contains(widget.filterName!.toLowerCase());

      final matchesEmail = widget.filterEmail == null ||
          (agent.email ?? '').toLowerCase().contains(widget.filterEmail!.toLowerCase());

      final matchesStatus = widget.filterIsActive == null || agent.isActive == widget.filterIsActive;

      return matchesName && matchesEmail && matchesStatus;
    }).toList();
  }


  Widget _buildGridView(List<AgentModel> agents) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: agents.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 300,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) => AgentCard(
        agent: agents[index],
        isExpanded: expandedIndex == index,
        onExpandToggle: () => toggleExpanded(index),
      ),
    );
  }

  Widget _buildListView(List<AgentModel> agents) {
    return ListView.builder(
      itemCount: agents.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: AgentCard(
          agent: agents[index],
          isExpanded: expandedIndex == index,
          onExpandToggle: () => toggleExpanded(index),
        ),
      ),
    );
  }
}
