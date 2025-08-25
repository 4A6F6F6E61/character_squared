import 'package:character_squared/pages/login_page.dart';
import 'package:fluent_window/fluent_window.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/login',
  // TODO: Change everything
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => FluentWindow(child: const LoginPage()),
    ),
  ],
);
