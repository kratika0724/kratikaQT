// import 'package:flutter/material.dart';
// import 'package:qt_distributer/constants/app_colors.dart';
// import 'package:qt_distributer/widgets/common_text_widgets.dart';
// import '../../constants/app_textstyles.dart';
// import '../../widgets/add_new_button.dart';
// import '../../widgets/app_theme_button.dart';
// import 'add_customer_screen.dart';
// import 'customer_card_list.dart';
//
// class CustomerScreen extends StatelessWidget {
//   const CustomerScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, String>> agentsList = [
//       {'name': 'John Doe', 'email': 'john@example.com'},
//       {'name': 'Jane Smith', 'email': 'jane@gmail.com'},
//       {'name': 'Alice Johnson', 'email': 'alice@domain.com'},
//     ];
//
//     void showFilterSheet() {
//       showModalBottomSheet(
//         context: context,
//         isScrollControlled: true,
//         backgroundColor: Colors.white,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         builder: (context) => FilterSheet(agentsList: agentsList),
//       );
//     }
//     return Scaffold(
//       backgroundColor:AppColors.ghostWhite,
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(90), // 👈 Increase height
//         child: AppBar(
//           backgroundColor: Colors.white,
//           foregroundColor: Colors.black,
//           elevation: 0,
//           title: HeaderTextBlack("Customer"),
//           automaticallyImplyLeading: true,
//           flexibleSpace: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   const SizedBox(height: 40),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (_) => const AddCustomerScreen()),
//                           );
//                         },
//                         child: Container(
//                           height: 30,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(9),
//                             color: AppColors.primary.withOpacity(0.1),
//                             border: Border.all(color: AppColors.secondary),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "Add customer ",
//                                   overflow: TextOverflow.ellipsis,
//                                   maxLines: 1,
//                                   style: mediumTextStyle(fontSize: dimen13, color: Colors.black),
//                                 ),
//                                 const Icon(Icons.add, size: 16, color: Colors.black),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       GestureDetector(
//                         onTap: () => showFilterSheet(),
//                         child: Container(
//                           height: 30,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(9),
//                             color: AppColors.primary.withOpacity(0.1),
//                             border: Border.all(color: AppColors.secondary),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "Filter ",
//                                   overflow: TextOverflow.ellipsis,
//                                   maxLines: 1,
//                                   style: mediumTextStyle(fontSize: dimen13, color: Colors.black),
//                                 ),
//                                 const Icon(Icons.filter_list, size: 16, color: Colors.black),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Column(
//               children: [
//                 Expanded(child: CustomerList()),
//               ],
//             ),
//             // Positioned(
//             //   bottom: 20,
//             //   right: 20,
//             //   child: FloatingCircularAddButton(
//             //     onPressed: () {
//             //       Navigator.push(
//             //         context,
//             //         MaterialPageRoute(builder: (_) => const AddCustomerScreen()));
//             //     },
//             //   ),
//             // )
//           ],
//         )
//       ),
//     );
//   }
// }
//
// class FilterSheet extends StatefulWidget {
//   final List<Map<String, String>> agentsList;
//   const FilterSheet({super.key, required this.agentsList});
//
//   @override
//   State<FilterSheet> createState() => FilterSheetState();
// }
//
// class FilterSheetState extends State<FilterSheet> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final GlobalKey nameFieldKey = GlobalKey();
//   final GlobalKey emailFieldKey = GlobalKey();
//   final LayerLink nameLink = LayerLink();
//   final LayerLink emailLink = LayerLink();
//   OverlayEntry? overlayEntry;
//   String selectedStatus = '';
//   String contactNumber = '';
//
//   @override
//   void dispose() {
//     nameController.dispose();
//     emailController.dispose();
//     overlayEntry?.remove();
//     super.dispose();
//   }
//
//   void showOverlay({
//     required GlobalKey fieldKey,
//     required LayerLink link,
//     required List<String> options,
//     required TextEditingController controller,
//   }) {
//     removeOverlay();
//
//     final renderBox = fieldKey.currentContext?.findRenderObject() as RenderBox?;
//     if (renderBox == null) return;
//
//     final size = renderBox.size;
//     final offset = renderBox.localToGlobal(Offset.zero);
//
//     final filteredOptions = options
//         .where((o) => o.toLowerCase().contains(controller.text.toLowerCase()))
//         .toList();
//
//     if (filteredOptions.isEmpty) return;
//
//     overlayEntry = OverlayEntry(
//       builder: (context) => Positioned(
//         left: offset.dx,
//         top: offset.dy + size.height,
//         width: size.width,
//         child: CompositedTransformFollower(
//           link: link,
//           showWhenUnlinked: false,
//           child: Padding(
//             padding: const EdgeInsets.only(top: 50.0),
//             child: Material(
//               elevation: 4,
//               borderRadius: BorderRadius.circular(20),
//               color: Colors.white,
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: filteredOptions.length,
//                 itemBuilder: (context, index) {
//                   final option = filteredOptions[index];
//                   return ListTile(
//                     title: Text(option),
//                     onTap: () {
//                       controller.text = option;
//                       removeOverlay();
//                     },
//                   );
//                 },
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//
//     Overlay.of(context).insert(overlayEntry!);
//   }
//
//   void removeOverlay() {
//     overlayEntry?.remove();
//     overlayEntry = null;
//   }
//
//   Widget buildComboField({
//     required String label,
//     required TextEditingController controller,
//     required GlobalKey fieldKey,
//     required LayerLink link,
//     required List<String> options,
//   }) {
//     return CompositedTransformTarget(
//       link: link,
//       child: TextField(
//         key: fieldKey,
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           suffixIcon: const Icon(Icons.arrow_drop_down),
//           border: OutlineInputBorder(),
//         ),
//         onTap: () => showOverlay(
//           fieldKey: fieldKey,
//           link: link,
//           options: options,
//           controller: controller,
//         ),
//         onChanged: (_) => showOverlay(
//           fieldKey: fieldKey,
//           link: link,
//           options: options,
//           controller: controller,
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final names = widget.agentsList.map((e) => e['name']!).toList();
//     final emails = widget.agentsList.map((e) => e['email']!).toList();
//     final statusOptions = ['Active', 'Inactive'];
//
//     return Padding(
//       padding: EdgeInsets.only(
//         left: 16,
//         right: 16,
//         top: 24,
//         bottom: MediaQuery.of(context).viewInsets.bottom + 16,
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             const Text("Filter Customers", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 20),
//             buildComboField(
//               label: "Select or Enter Name",
//               controller: nameController,
//               fieldKey: nameFieldKey,
//               link: nameLink,
//               options: names,
//             ),
//             const SizedBox(height: 16),
//             buildComboField(
//               label: "Select or Enter Email",
//               controller: emailController,
//               fieldKey: emailFieldKey,
//               link: emailLink,
//               options: emails,
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               keyboardType: TextInputType.number,
//               maxLength: 10,
//               decoration: const InputDecoration(
//                 labelText: 'Contact Number',
//                 border: OutlineInputBorder(),
//                 counterText: "",
//               ),
//               onChanged: (value) {
//                 if (value.length <= 10 && RegExp(r'^\d*$').hasMatch(value)) {
//                   setState(() => contactNumber = value);
//                 }
//               },
//             ),
//             const SizedBox(height: 20),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text("Status", style: TextStyle(fontWeight: FontWeight.w600)),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Wrap(
//                   spacing: 10,
//                   children: statusOptions.map((status) {
//                     final selected = selectedStatus == status;
//                     return ChoiceChip(
//                       label: Text(status),
//                       selected: selected,
//                       showCheckmark: true,
//                       checkmarkColor: Colors.white,
//                       selectedColor: AppColors.secondary,
//                       labelStyle: mediumTextStyle(
//                         color: selected ? Colors.white : AppColors.secondary  ,
//                         fontSize: 14.0,
//                       ),
//                       backgroundColor: AppColors.primary.withOpacity(0.1),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           side: BorderSide(color: Colors.transparent)
//                       ),
//                       onSelected: (_) => setState(() => selectedStatus = status),
//                     );
//                   }).toList(),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text("Apply Filters"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_textstyles.dart';
import '../../providers/customer_provider.dart';
import '../../widgets/common_text_widgets.dart';
import '../../widgets/filter_chips_widget.dart';
import 'add_customer_screen.dart';
import 'customer_card.dart';
import 'customer_card_list.dart';
import 'customer_filter_bottom_sheet.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerScreen> {

  String? filterName;
  String? filterEmail;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CustomerProvider>(context, listen: false).getCustomerData();
    });
  }

  void _openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => CustomerFilterBottomSheet(
        initialName: filterName,
        initialEmail: filterEmail,
        onApply: (name, email) {
          setState(() {
            filterName = name;
            filterEmail = email;
          });
        },
        onClear: () {
          setState(() {
            filterName = null;
            filterEmail = null;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ghostWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back)
            ),
            SizedBox(width: 20,),
            HeaderTextBlack("Customers"),
            Spacer(),
            // Filter or Clear Filter Button
            GestureDetector(
              onTap: () {
                if (filterName != null || filterEmail != null) {
                  setState(() {
                    filterName = null;
                    filterEmail = null;
                  });
                } else {
                  _openFilterBottomSheet();
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 0),
                child: Container(
                  height: 33,
                  constraints: const BoxConstraints(maxWidth: 135),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: (filterName != null || filterEmail != null)
                        ? AppColors.secondary
                        : AppColors.primary.withOpacity(0.1),
                    border: Border.all(color: AppColors.secondary),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Text(
                          (filterName != null || filterEmail != null)
                              ? "Clear Filters"
                              : "Filter Customers",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: mediumTextStyle(
                            fontSize: dimen13,
                            color: (filterName != null || filterEmail != null)
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        (filterName != null || filterEmail != null)
                            ? Icons.clear
                            : Icons.filter_list,
                        size: 16,
                        color: (filterName != null || filterEmail != null)
                            ? Colors.white
                            : Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        // actions: [
        //   // Filter or Clear Filter Button
        //   GestureDetector(
        //     onTap: () {
        //       if (filterName != null || filterCode != null) {
        //         setState(() {
        //           filterName = null;
        //           filterCode = null;
        //         });
        //       } else {
        //         _openFilterBottomSheet();
        //       }
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.only(right: 12),
        //       child: Container(
        //         height: 30,
        //         constraints: const BoxConstraints(maxWidth: 120),
        //         padding: const EdgeInsets.symmetric(horizontal: 8),
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(9),
        //           color: (filterName != null || filterCode != null)
        //               ? AppColors.secondary
        //               : AppColors.primary.withOpacity(0.1),
        //           border: Border.all(color: AppColors.secondary),
        //         ),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             Flexible(
        //               child: Text(
        //                 (filterName != null || filterCode != null)
        //                     ? "Clear Filters"
        //                     : "Filter Products",
        //                 overflow: TextOverflow.ellipsis,
        //                 maxLines: 1,
        //                 style: mediumTextStyle(
        //                   fontSize: dimen13,
        //                   color: (filterName != null || filterCode != null)
        //                       ? Colors.white
        //                       : Colors.black,
        //                 ),
        //               ),
        //             ),
        //             const SizedBox(width: 4),
        //             Icon(
        //               (filterName != null || filterCode != null)
        //                   ? Icons.clear
        //                   : Icons.filter_list,
        //               size: 16,
        //               color: (filterName != null || filterCode != null)
        //                   ? Colors.white
        //                   : Colors.black,
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Consumer<CustomerProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }

          if (provider.customers.isEmpty) {
            return const Center(child: Text('No customers found.'));
          }

          return Column(
            children: [
              if (filterName != null || filterEmail != null)
                FilterChipsWidget(
                  filters: {
                    'Name': filterName,
                    'Email': filterEmail,

                  },
                  onClear: () => setState(() {
                    filterEmail = null;
                    filterName = null;
                  }),
                ),

                Expanded(
                  child: CustomerList(
                    customers: provider.customers,
                    filterName: filterName,
                    filterEmail: filterEmail,
                  ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 8),
            child: SizedBox(
              height: 45,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddCustomerScreen()),
                  );
                },
                icon: const Icon(Icons.add, size: 18, color: Colors.white),
                label: Text(
                  'Add Customer',
                  style: mediumTextStyle(fontSize: dimen15, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
