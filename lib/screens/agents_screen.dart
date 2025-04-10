import 'package:flutter/material.dart';
import '../constants/app_textstyles.dart';
import 'add_agent_screen.dart'; // We'll define this screen below

class AgentsScreen extends StatelessWidget {
  AgentsScreen({super.key});

  final agents = [
    {'name': 'Agent A', 'contact': '9876543210', 'region': 'Zone 1'},
    {'name': 'Agent B', 'contact': '9123456789', 'region': 'Zone 2'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [

            // Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Agents List',
                style: headTextStyle(
                    fontSize: dimen20, color: Colors.black),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddAgentScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    child: Text(
                      'Add New',
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ],
              ),
            ),
            Divider(thickness: 1, color: Colors.grey.shade200),
            Expanded(child: buildAgentList()),
          ],
        ),
      ),
    );
  }

  Widget buildAgentList() {
    if (agents.isEmpty) {
      return const Center(child: Text('No agents found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: agents.length,
      itemBuilder: (context, index) {
        final agent = agents[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 15),
            child: ListTile(
              leading: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return  LinearGradient(
                    colors: [Colors.black, Colors.grey],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },
                child: const Icon(
                  Icons.person,
                  size: 70,
                  color: Colors.white, // This color becomes the base for the gradient
                ),
              ),
              title: Text(agent['name']!, style: semiBoldTextStyle(fontSize: dimen15, color: Colors.black),),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Contact: ${agent['contact']}',style: regularTextStyle(fontSize: dimen14, color: Colors.black)),
                  SizedBox(height: 10,),
                  Text('Region: ${agent['region']}',style: regularTextStyle(fontSize: dimen13, color: Colors.black54)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
