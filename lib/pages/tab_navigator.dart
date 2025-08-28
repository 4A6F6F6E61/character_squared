import 'package:character_squared/components/fluent_bottom_navigation.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluent_window/fluent_window.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_acrylic/window_effect.dart';
import 'package:go_router/go_router.dart';

class TabNavigator extends StatefulWidget {
  const TabNavigator({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<TabNavigator> createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  int index = 0;

  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FluentWindow(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(child: widget.navigationShell),
            FluentBottomNavigation(
              index: index,
              onClick: (v) async {
                setState(() => index = v);
                _goBranch(v);
              },
              items: [
                FluentBottomNavigationItem(label: "Home", icon: FluentIcons.home_solid),
                FluentBottomNavigationItem(label: "Search", icon: FluentIcons.search),
                FluentBottomNavigationItem(label: "Profile", icon: FluentIcons.account_management),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
