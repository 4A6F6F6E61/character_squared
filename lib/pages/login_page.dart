import 'package:character_squared/db.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    final username = usernameController.text;
    final password = passwordController.text;

    final AuthResponse _ = await auth.signInWithPassword(email: username, password: password);
  }

  Future<void> register() async {
    final username = usernameController.text;
    final password = passwordController.text;

    final AuthResponse _ = await auth.signUp(email: username, password: password);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 20.0),
          child: Text('Login', style: FluentTheme.of(context).typography.titleLarge),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 69.0),
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                InfoLabel(
                  label: 'Username',
                  child: TextBox(
                    controller: usernameController,
                    placeholder: 'Enter your username',
                  ),
                ),
                const SizedBox(height: 10),
                InfoLabel(
                  label: 'Password',
                  child: TextBox(
                    controller: passwordController,
                    placeholder: 'Enter your password',
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  style: ButtonStyle(
                    padding: ButtonState.all(
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    ),
                  ),
                  onPressed: login,
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
