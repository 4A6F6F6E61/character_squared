import 'dart:developer' as dev;

import 'package:character_squared/db.dart';
import 'package:character_squared/pages/details_view.dart';
import 'package:character_squared/pages/login_page.dart';
import 'package:character_squared/pages/tab_navigator.dart';
import 'package:character_squared/pages/tabs/account.dart';
import 'package:character_squared/pages/tabs/home.dart';
import 'package:character_squared/pages/tabs/search.dart';
import 'package:fluent_window/fluent_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/auth/login',
  refreshListenable: authListener,
  debugLogDiagnostics: true,
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
          routes: [
            GoRoute(
              path: '/tabs/search',
              builder: (_, _) => const Search(),
              routes: [
                // Path & QueryParameters do not work or some reason, so I will just use extra
                GoRoute(
                  path: "/details",
                  pageBuilder: (context, state) {
                    final extra = GoRouterState.of(context).extra! as Map<String, dynamic>;
                    final int id = extra["id"];
                    final MediaType mType = extra["mType"];
                    return CustomTransitionPage(
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: DetailsView(id: id, mType: mType),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/tabs/account', builder: (_, _) => const Account())],
        ),
      ],
    ),
  ],
);
