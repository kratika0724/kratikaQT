import 'package:flutter/material.dart';

class ResponsiveListGridView extends StatelessWidget {
  final List items;
  final IndexedWidgetBuilder itemBuilder;
  final EdgeInsetsGeometry padding;
  final int gridCrossAxisCount;
  final double widthThreshold;

  const ResponsiveListGridView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    this.gridCrossAxisCount = 2,
    this.widthThreshold = 600,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > widthThreshold;

    if (items.isEmpty) {
      return const Center(child: Text("No items found."));
    }

    return isWide
        ? GridView.builder(
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gridCrossAxisCount,
        childAspectRatio: 2, // You can adjust based on card shape
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: itemBuilder,
    )
        : ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: padding,
          child: itemBuilder(context, index),
        );
      },
    );
  }
}
