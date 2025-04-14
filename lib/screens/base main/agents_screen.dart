import 'package:flutter/material.dart';
import 'package:qt_distributer/constants/app_colors.dart';
import 'package:qt_distributer/widgets/common_text_widgets.dart';
import '../../widgets/add_new_button.dart';
import '../agent/add_agent_screen.dart';
import '../agent/agent_card_list.dart';

class AgentsScreen extends StatelessWidget {
  const AgentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> dropdownItems = ['Any', 'Yes', 'No'];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: HeaderTextThemeSecondary("Agents"),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 3,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Verified'),
                value: 'Any',
                items: dropdownItems.map((e) => DropdownMenuItem(child: Text(e), value: e)).toList(),
                onChanged: (val) {},
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Role'),
                value: 'Any',
                items: dropdownItems.map((e) => DropdownMenuItem(child: Text(e), value: e)).toList(),
                onChanged: (val) {},
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Status'),
                value: 'Any',
                items: dropdownItems.map((e) => DropdownMenuItem(child: Text(e), value: e)).toList(),
                onChanged: (val) {},
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                child: const Text('Submit'),
              ),
              const SizedBox(height: 30),

              Expanded(child: AgentList()),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AddNewButton(
                      label: 'Add New Agent',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AddAgentScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
}

