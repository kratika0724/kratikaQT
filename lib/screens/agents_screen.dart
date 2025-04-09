// import 'package:flutter/material.dart';
//
// class AgentsScreen extends StatelessWidget {
//   const AgentsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: const Center(
//         child: Text('Agents Content'),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class AgentsScreen extends StatefulWidget {
  const AgentsScreen({super.key});

  @override
  State<AgentsScreen> createState() => _AgentsScreenState();
}

class _AgentsScreenState extends State<AgentsScreen> {
  bool isAddingNew = false;

  String? selectedGender;
  String? selectedAgent;

  String? selectedZone;
  final zones = ['Zone 1', 'Zone 2', 'Zone 3'];

  final agents = [
    {'name': 'Agent A', 'contact': '9876543210', 'region': 'Zone 1'},
    {'name': 'Agent B', 'contact': '9123456789', 'region': 'Zone 2'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:SafeArea(
        child: Column(
          children: [
            // Custom header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isAddingNew ? 'Add Agent' : 'Agents List',
                    style:  TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() => isAddingNew = !isAddingNew);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    child: Text(
                      isAddingNew ? 'Show List' : 'Add New',
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ],
              ),
            ),
            Divider(thickness: 0.3,color: Theme.of(context).colorScheme.primary,),
            Expanded(
              child: isAddingNew ? buildAddAgentForm() : buildAgentList(),
            ),
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
          child: ListTile(
            title: Text(agent['name']!),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Contact: ${agent['contact']}'),
                Text('Region: ${agent['region']}'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildAddAgentForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              buildTextField('First Name'),
              buildTextField('Middle Name'),
              buildTextField('Last Name'),
              buildTextField('Email'),
              buildTextField('Mobile No'),
              buildTextField('CRM ID'),
              buildTextField('Date of Birth', hint: 'dd/mm/yyyy'),
              buildTextField('Address'),
              buildTextField('Pincode'),
              buildTextField('State'),
              buildGenderSelector(),
              buildDropdown('Select Services', null, ['Loan Recovery', 'Payment Collection'], (_) {}),
              buildTextField('Assigned Pincode'),
              buildTextField('Assigned Area'),
              buildTextField('City'),

              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Submit logic here
                        setState(() {
                          isAddingNew = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Submit'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          isAddingNew = false;
                        });
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget buildTextField(String label, {String? hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildGenderSelector() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gender',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Row(
            children: [
              Radio<String>(
                value: 'Male',
                groupValue: selectedGender,
                onChanged: (value) {
                  setState(() => selectedGender = value);
                },
              ),
              const Text('Male'),
              Radio<String>(
                value: 'Female',
                groupValue: selectedGender,
                onChanged: (value) {
                  setState(() => selectedGender = value);
                },
              ),
              const Text('Female'),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDropdown(
      String label,
      String? value,
      List<String> items,
      void Function(String?) onChanged,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items.map((item) {
          return DropdownMenuItem(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

