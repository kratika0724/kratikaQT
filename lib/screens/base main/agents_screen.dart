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
        child: Column(
          children: [
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
    );
  }
}

