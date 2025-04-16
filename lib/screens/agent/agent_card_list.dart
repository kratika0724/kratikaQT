import 'package:flutter/material.dart';
import '../../models/agent_model.dart';
import 'agent_card.dart';

class AgentList extends StatefulWidget {
  AgentList({super.key});

  @override
  State<AgentList> createState() => _AgentListState();
}

class _AgentListState extends State<AgentList> {
  final List<AgentModel> agentList =
  sampleAgents.map((e) => AgentModel.fromMap(e)).toList();

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
    if (sampleAgents.isEmpty) {
      return const Center(child: Text('No agents found.'));
    }

    return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
        itemCount: agentList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: AgentCard(
              agent: agentList[index],
              isExpanded: expandedIndex == index,
              onExpandToggle: () => toggleExpanded(index),
            ),
          );
        },
      );
  }
}


