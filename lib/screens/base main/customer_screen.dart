// import 'package:flutter/material.dart';
//
// class CustomerScreen extends StatelessWidget {
//   const CustomerScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         foregroundColor: Colors.black,
//         backgroundColor: Colors.white,
//         title: Text("Customers",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.black),),
//       ),
//       body: const Center(
//         child: Text('Customer Content'),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:qt_distributer/constants/app_colors.dart';
import '../../constants/app_textstyles.dart';
import '../customer/add_customer_screen.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final customers = [
    {'name': 'John Doe', 'contact': '9876543210', 'service': 'Loan Recovery'},
    {'name': 'Jane Smith', 'contact': '9123456789', 'service': 'Payment Collection'},
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Customer List',
                    style: headTextStyle(
                        fontSize: dimen20, color: Colors.black),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddCustomerScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    child: Text(
                      'Add New',
                      style: boldTextStyle(fontSize: dimen14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Divider(thickness: 1, color: Colors.grey.shade200),
            Expanded(child: buildCustomerList()),
          ],
        ),
      ),
    );
  }

  Widget buildCustomerList() {
    if (customers.isEmpty) {
      return const Center(child: Text('No customers found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final customer = customers[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0,vertical: 0.0),
            child: ListTile(
              leading: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return  LinearGradient(
                    colors: [Colors.indigo.shade900, Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },
                child: const Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white, // This color becomes the base for the gradient
                ),
              ),
              title: Text(customer['name']!,style:  semiBoldTextStyle(fontSize: dimen15, color: Colors.black),),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Contact: ${customer['contact']}',style: regularTextStyle(fontSize: dimen14, color: Colors.black)),
                  SizedBox(height: 5,),
                  Text('Service: ${customer['service']}',style: regularTextStyle(fontSize: dimen13, color: Colors.black54)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

//
// import 'package:flutter/material.dart';
//
// class CustomerScreen extends StatefulWidget {
//   const CustomerScreen({super.key});
//
//   @override
//   State<CustomerScreen> createState() => _CustomerScreenState();
// }
//
// class _CustomerScreenState extends State<CustomerScreen> {
//   bool isAddingNew = false;
//
//   String? selectedGender;
//   String? selectedAgent;
//
//   final agents = ['Agent A', 'Agent B', 'Agent C'];
//
//   final customers = [
//     {'name': 'John Doe', 'contact': '9876543210', 'service': 'Loan Recovery'},
//     {'name': 'Jane Smith', 'contact': '9123456789', 'service': 'Payment Collection'},
//   ];
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Custom header
//             Container(
//               color: Colors.white,
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     isAddingNew ? 'Add Customer' : 'Customer List',
//                     style:  TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Theme.of(context).colorScheme.primary,
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() => isAddingNew = !isAddingNew);
//                     },
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
//                     child: Text(
//                       isAddingNew ? 'Show List' : 'Add New',
//                       style: TextStyle(color: Theme.of(context).colorScheme.primary),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Divider(thickness: 0.3,color: Theme.of(context).colorScheme.primary,),
//             Expanded(
//               child: isAddingNew ? buildAddCustomerForm() : buildCustomerList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   Widget buildCustomerList() {
//     if (customers.isEmpty) {
//       return const Center(child: Text('No customers found.'));
//     }
//
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: customers.length,
//       itemBuilder: (context, index) {
//         final customer = customers[index];
//         return Card(
//           margin: const EdgeInsets.only(bottom: 12),
//           elevation: 3,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           child: ListTile(
//             title: Text(customer['name']!),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Contact: ${customer['contact']}'),
//                 Text('Service: ${customer['service']}'),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget buildAddCustomerForm() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               buildTextField('First Name'),
//               buildTextField('Middle Name'),
//               buildTextField('Last Name'),
//               buildTextField('Email'),
//               buildTextField('Date of Birth', hint: 'dd/mm/yyyy'),
//               buildGenderSelector(),
//               buildDropdown('Select Agent', selectedAgent, agents, (value) {
//                 setState(() {
//                   selectedAgent = value;
//                 });
//               }),
//               buildTextField('Address'),
//               buildTextField('Pincode'),
//               buildTextField('State'),
//               buildTextField('City'),
//
//               const SizedBox(height: 20),
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         // Submit logic
//                         setState(() {
//                           isAddingNew = false;
//                         });
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Theme.of(context).colorScheme.primary,
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                       ),
//                       child: const Text('Submit'),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () {
//                         setState(() {
//                           isAddingNew = false;
//                         });
//                       },
//                       child: const Text('Cancel'),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildTextField(String label, {String? hint}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: TextField(
//         decoration: InputDecoration(
//           labelText: label,
//           hintText: hint,
//           border: const OutlineInputBorder(),
//         ),
//       ),
//     );
//   }
//
//   Widget buildGenderSelector() {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Gender',
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//           ),
//           Row(
//             children: [
//               Radio<String>(
//                 value: 'Male',
//                 groupValue: selectedGender,
//                 onChanged: (value) {
//                   setState(() => selectedGender = value);
//                 },
//               ),
//               const Text('Male'),
//               Radio<String>(
//                 value: 'Female',
//                 groupValue: selectedGender,
//                 onChanged: (value) {
//                   setState(() => selectedGender = value);
//                 },
//               ),
//               const Text('Female'),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildDropdown(
//       String label,
//       String? value,
//       List<String> items,
//       void Function(String?) onChanged,
//       ) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: DropdownButtonFormField<String>(
//         value: value,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//         ),
//         items: items.map((item) {
//           return DropdownMenuItem(value: item, child: Text(item));
//         }).toList(),
//         onChanged: onChanged,
//       ),
//     );
//   }
// }
//
