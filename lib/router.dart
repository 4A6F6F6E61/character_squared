import 'package:character_squared/db.dart';
import 'package:character_squared/pages/login_page.dart';
import 'package:character_squared/pages/tab_navigator.dart';
import 'package:character_squared/pages/tabs/account.dart';
import 'package:character_squared/pages/tabs/home.dart';
import 'package:character_squared/pages/tabs/search.dart';
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
      redirect: (_, _) => '/auth/login',
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
      builder: (_, _, navigationShell) {
        return TabNavigator(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [GoRoute(path: '/tabs/home', builder: (_, _) => const Home())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/tabs/search', builder: (_, _) => const Search())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/tabs/account', builder: (_, _) => const Account())],
        ),
      ],
    ),
  ],
);
