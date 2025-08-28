import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show AnimatedAlign; // Only for animation

const double kBottomNavigationBarHeight = 56.0;

class FluentBottomNavigationItem {
  final String? label;
  final IconData icon;
  final IconData? activeIcon;

  const FluentBottomNavigationItem({this.label, required this.icon, this.activeIcon});
}

class FluentBottomNavigation extends StatefulWidget {
  const FluentBottomNavigation({
    super.key,
    required this.items,
    required this.index,
    required this.onClick,
  });

  final List<FluentBottomNavigationItem> items;
  final int index;
  final void Function(int index) onClick;

  @override
  State<FluentBottomNavigation> createState() => _FluentBottomNavigationState();
}

class _FluentBottomNavigationState extends State<FluentBottomNavigation> {
  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final itemCount = widget.items.length;
    final itemWidth = screenWidth / itemCount;

    return Card(
      padding: EdgeInsetsGeometry.all(0.0),
      child: SizedBox(
        width: double.maxFinite,
        height: kBottomNavigationBarHeight,
        child: Stack(
          children: [
            Row(
              children: [
                ...widget.items.indexed.map((x) {
                  final i = x.$1;
                  final item = x.$2;

                  bool active = i == widget.index;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => widget.onClick(i),
                      behavior: HitTestBehavior.translucent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            active ? (item.activeIcon ?? item.icon) : item.icon,
                            color: active ? theme.accentColor : theme.inactiveColor,
                            size: 20.0,
                          ),

                          if (item.label != null) ...[
                            const SizedBox(height: 2.0),
                            Text(
                              item.label!,
                              style: TextStyle(
                                color: active ? theme.accentColor : theme.inactiveColor,
                                fontSize: 11.0,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),

            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              left: (itemWidth * widget.index) + (itemWidth / 4),
              bottom: 0,
              child: Container(
                width: itemWidth / 2,
                height: 2.5,
                decoration: BoxDecoration(
                  color: theme.accentColor,
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
