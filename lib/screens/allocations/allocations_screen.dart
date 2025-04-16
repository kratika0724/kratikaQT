import 'package:flutter/material.dart';
import 'package:qt_distributer/widgets/add_new_button.dart';
import 'package:qt_distributer/widgets/common_text_widgets.dart';
import 'package:qt_distributer/constants/app_colors.dart';
import '../../constants/app_textstyles.dart';
import '../../widgets/app_theme_button.dart';
import 'add_allocation_screen.dart';
import 'allocation_card_list.dart';

class AllocationsScreen extends StatefulWidget {
  const AllocationsScreen({super.key});

  @override
  State<AllocationsScreen> createState() => _AllocationsScreenState();
}

class _AllocationsScreenState extends State<AllocationsScreen> {
  final List<Map<String, String>> agentsList = [
    {'name': 'John Doe', 'email': 'john@example.com'},
    {'name': 'Jane Smith', 'email': 'jane@gmail.com'},
    {'name': 'Alice Johnson', 'email': 'alice@domain.com'},
  ];

  void showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FilterSheet(agentsList: agentsList),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ghostWhite,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90), // 👈 Increase height
        child: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          title: HeaderTextBlack("Allocations"),
          automaticallyImplyLeading: true,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AddAllocationScreen()),
                          );
                        },
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            color: AppColors.primary.withOpacity(0.1),
                            border: Border.all(color: AppColors.secondary),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Add allocation ",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: mediumTextStyle(fontSize: dimen13, color: Colors.black),
                                ),
                                const Icon(Icons.add, size: 16, color: Colors.black),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => showFilterSheet(),
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            color: AppColors.primary.withOpacity(0.1),
                            border: Border.all(color: AppColors.secondary),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Filter ",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: mediumTextStyle(fontSize: dimen13, color: Colors.black),
                                ),
                                const Icon(Icons.filter_list, size: 16, color: Colors.black),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
              children: [
                const Expanded(child: AllocationCardList()),
              ]
          ),
          // Positioned(
          //   bottom: 40,
          //   right: 20,
          //   child: FloatingCircularAddButton(
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (_) => const AddAllocationScreen()),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }


}


class FilterSheet extends StatefulWidget {
  final List<Map<String, String>> agentsList;
  const FilterSheet({super.key, required this.agentsList});

  @override
  State<FilterSheet> createState() => FilterSheetState();
}

class FilterSheetState extends State<FilterSheet> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey nameFieldKey = GlobalKey();
  final GlobalKey emailFieldKey = GlobalKey();
  final LayerLink nameLink = LayerLink();
  final LayerLink emailLink = LayerLink();
  OverlayEntry? overlayEntry;
  String selectedStatus = '';
  String contactNumber = '';

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    overlayEntry?.remove();
    super.dispose();
  }

  void showOverlay({
    required GlobalKey fieldKey,
    required LayerLink link,
    required List<String> options,
    required TextEditingController controller,
  }) {
    removeOverlay();

    final renderBox = fieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    final filteredOptions = options
        .where((o) => o.toLowerCase().contains(controller.text.toLowerCase()))
        .toList();

    if (filteredOptions.isEmpty) return;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        width: size.width,
        child: CompositedTransformFollower(
          link: link,
          showWhenUnlinked: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredOptions.length,
                itemBuilder: (context, index) {
                  final option = filteredOptions[index];
                  return ListTile(
                    title: Text(option),
                    onTap: () {
                      controller.text = option;
                      removeOverlay();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry!);
  }

  void removeOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  Widget buildComboField({
    required String label,
    required TextEditingController controller,
    required GlobalKey fieldKey,
    required LayerLink link,
    required List<String> options,
  }) {
    return CompositedTransformTarget(
      link: link,
      child: TextField(
        key: fieldKey,
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.arrow_drop_down),
          border: OutlineInputBorder(),
        ),
        onTap: () => showOverlay(
          fieldKey: fieldKey,
          link: link,
          options: options,
          controller: controller,
        ),
        onChanged: (_) => showOverlay(
          fieldKey: fieldKey,
          link: link,
          options: options,
          controller: controller,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final names = widget.agentsList.map((e) => e['name']!).toList();
    final emails = widget.agentsList.map((e) => e['email']!).toList();
    final statusOptions = ['Active', 'Inactive'];

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text("Filter Allocations", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            buildComboField(
              label: "Select or Enter Name",
              controller: nameController,
              fieldKey: nameFieldKey,
              link: nameLink,
              options: names,
            ),
            const SizedBox(height: 16),
            buildComboField(
              label: "Select or Enter Email",
              controller: emailController,
              fieldKey: emailFieldKey,
              link: emailLink,
              options: emails,
            ),
            const SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              maxLength: 10,
              decoration: const InputDecoration(
                labelText: 'Contact Number',
                border: OutlineInputBorder(),
                counterText: "",
              ),
              onChanged: (value) {
                if (value.length <= 10 && RegExp(r'^\d*$').hasMatch(value)) {
                  setState(() => contactNumber = value);
                }
              },
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Status", style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 10,
                  children: statusOptions.map((status) {
                    final selected = selectedStatus == status;
                    return ChoiceChip(
                      label: Text(status),
                      selected: selected,
                      showCheckmark: true,
                      checkmarkColor: Colors.white,
                      selectedColor: AppColors.secondary,
                      labelStyle: mediumTextStyle(
                        color: selected ? Colors.white : AppColors.secondary  ,
                        fontSize: 14.0,
                      ),
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.transparent)
                      ),
                      onSelected: (_) => setState(() => selectedStatus = status),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Apply Filters"),
            )
          ],
        ),
      ),
    );
  }
}

