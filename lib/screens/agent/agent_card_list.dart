import 'package:flutter/material.dart';
import '../../models/agent_model.dart';
import 'agent_card.dart';

class AgentList extends StatelessWidget {
  AgentList({super.key});

  final List<AgentModel> agentList =
  sampleAgents.map((e) => AgentModel.fromMap(e)).toList();

  @override
  Widget build(BuildContext context) {
    if (sampleAgents.isEmpty) {
      return const Center(child: Text('No agents found.'));
    }

    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: agentList.length,
        itemBuilder: (context, index) {
          return AgentCard(agent: agentList[index]);
        },
      );
  }
}


