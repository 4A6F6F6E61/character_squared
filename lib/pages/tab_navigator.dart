import 'package:fluent_window/fluent_window.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class TabNavigator extends StatefulWidget {
  const TabNavigator({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<TabNavigator> createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  @override
  Widget build(BuildContext context) {
    // TODO: Add bottom navigation bar
    return FluentWindow(child: widget.navigationShell);
  }
}
