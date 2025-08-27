import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as m;

class FluentBottomNavigation extends StatefulWidget {
  const FluentBottomNavigation({
    super.key,
    required this.items,
    required this.index,
    required this.onClick,
  });

  final List<BottomNavigationItem> items;
  final int index;
  final void Function(int index) onClick;

  @override
  State<FluentBottomNavigation> createState() => _FluentBottomNavigationState();
}

class _FluentBottomNavigationState extends State<FluentBottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return Card(
      padding: EdgeInsetsGeometry.all(0),
      child: SizedBox(
        width: double.maxFinite,
        height: m.kBottomNavigationBarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (final e in widget.items)
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [e.icon, if (e.title != null) e.title!],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
