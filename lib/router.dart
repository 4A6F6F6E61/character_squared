import 'package:character_squared/db.dart';
import 'package:character_squared/pages/login_page.dart';
import 'package:character_squared/pages/tab_navigator.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluent_window/fluent_window.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/auth/login',
  refreshListenable: authListener,
  redirect: (context, state) {
    final loggedIn = auth.currentUser != null;

    if (state.fullPath!.startsWith("/auth")) {
      if (loggedIn) return '/tabs/home';

      return state.fullPath;
    }

    if (!loggedIn) return '/auth/login';

    return state.fullPath;
  },
  routes: [
    GoRoute(
      path: '/auth',
      redirect: (_, __) => '/auth/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (_, _) => FluentWindow(child: const LoginPage()),
        ),
        GoRoute(
          path: '/register',
          // TODO: Change to RegisterPage when implemented
          builder: (_, _) => FluentWindow(child: const LoginPage()),
        ),
      ],
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return TabNavigator(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/tabs/home',
              builder: (_, _) => Row(
                children: [
                  Text("Hom Page"),
                  Button(
                    child: Text("Logout"),
                    onPressed: () async {
                      await auth.signOut();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);
