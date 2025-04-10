import 'package:flutter/material.dart';


class AllocationsScreen extends StatefulWidget {
  const AllocationsScreen({super.key});

  @override
  State<AllocationsScreen> createState() => _AllocationsScreenState();
}

class _AllocationsScreenState extends State<AllocationsScreen> {
  bool isAddingNew = false;

  String verifiedValue = 'Any';
  String roleValue = 'Any';
  String statusValue = 'Any';

  final List<String> options = ['Any', 'Yes', 'No'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isAddingNew ? 'Add New Payments' : 'Payments List'),
        leading: isAddingNew
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              isAddingNew = false;
            });
          },
        )
            : null,
        actions: [
          if (!isAddingNew)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isAddingNew = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: const Text('Add New'),
              ),
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: isAddingNew ? buildAddNewView() : buildAllocationListView(),
      ),
    );
  }

  Widget buildAllocationListView() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // // Dropdown filters
          // Wrap(
          //   spacing: 10,
          //   runSpacing: 10,
          //   children: [
          //     buildDropdown('VERIFIED', verifiedValue, (val) {
          //       setState(() => verifiedValue = val!);
          //     }),
          //     buildDropdown('ROLE', roleValue, (val) {
          //       setState(() => roleValue = val!);
          //     }),
          //     buildDropdown('STATUS', statusValue, (val) {
          //       setState(() => statusValue = val!);
          //     }),
          //     ElevatedButton(
          //       onPressed: () {},
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: Colors.deepPurple,
          //       ),
          //       child: const Text('Submit'),
          //     )
          //   ],
          // ),
          // const SizedBox(height: 20),

          // Search Field
          TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Table Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Allocation Pincode'),
              Text('Allocation Area'),
              Text('Created At'),
            ],
          ),
          const Divider(),

          // No Data Message
          const Expanded(
            child: Center(
              child: Text("No data to display"),
            ),
          ),

          // Footer Total
          const Text("0 total"),
        ],
      ),
    );
  }

  Widget buildAddNewView() {
    return SingleChildScrollView(
      child: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'ALLOCATION CREATION',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 20),

                // Upload Excel Section
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'UPLOAD YOUR EXCEL HERE',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 20),

                  ],
                ),

                ElevatedButton(
                  onPressed: () {
                    // File picker logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.black,
                    elevation: 0,
                  ),
                  child: const Text('Choose file'),
                ),
                const SizedBox(width: 10),
                const Text('No file chosen'),
                const SizedBox(height: 30),

                // Download Sample Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Download Sample File From Here : ',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Download sample logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Click Here'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget buildDropdown(
      String label,
      String currentValue,
      ValueChanged<String?> onChanged,
      ) {
    return SizedBox(
      width: 110,
      child: DropdownButtonFormField<String>(
        value: currentValue,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        ),
        items: options.map((val) {
          return DropdownMenuItem(
            value: val,
            child: Text(val),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

