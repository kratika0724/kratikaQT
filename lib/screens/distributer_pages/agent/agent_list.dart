import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/response models/agent_response.dart';
import '../../../providers/agent_provider.dart';
import '../../../utils/device_utils.dart';
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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void toggleExpanded(int index) {
    setState(() {
      if (expandedIndex == index) {
        expandedIndex = null;
      } else {
        expandedIndex = index;
      }
    });
  }

  void _onScroll() {
    final provider = Provider.of<AgentProvider>(context, listen: false);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !provider.isFetchingMore &&
        provider.hasMoreData) {
      provider.getAgentData(context, loadMore: true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = DeviceUtils.getDeviceWidth(context);
    final agentProvider = Provider.of<AgentProvider>(context);
    final filteredAgents = agentProvider.agents;
    if (filteredAgents.isEmpty) {
      return const Center(child: Text("No agents found."));
    }
    return isWide
        ? _buildGridView(filteredAgents)
        : _buildListView(filteredAgents);
  }

  Widget _buildGridView(List<AgentModel> agents) {
    final isOdd = agents.length.isOdd;
    final totalItems = isOdd ? agents.length + 1 : agents.length;

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: totalItems,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 300,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        // Prevent index out of range
        if (index >= agents.length) {
          return const SizedBox(); // empty space to complete the row
        }

        return AgentCard(
          agent: agents[index],
          isExpanded: expandedIndex == index,
          onExpandToggle: () => toggleExpanded(index),
        );
      },
    );
  }

  Widget _buildListView(List<AgentModel> agents) {
    return ListView.builder(
      controller: _scrollController,
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
