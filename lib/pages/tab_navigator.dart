import 'package:character_squared/components/fluent_bottom_navigation.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluent_window/fluent_window.dart';
import 'package:flutter/material.dart' as m;
import 'package:go_router/go_router.dart';

class TabNavigator extends StatefulWidget {
  const TabNavigator({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<TabNavigator> createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return FluentWindow(
      child: Column(
        children: [
          Expanded(child: widget.navigationShell),
          FluentBottomNavigation(
            index: index,
            onClick: (v) => setState(() => index = v),
            items: [
              BottomNavigationItem(title: Text("Home"), icon: Icon(FluentIcons.home)),
              BottomNavigationItem(title: Text("Settings"), icon: Icon(FluentIcons.settings)),
            ],
          ),
        ],
      ),
    );
  }
}
