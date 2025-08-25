import 'package:fluent_ui/fluent_ui.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual login form
    return ScaffoldPage(
      header: const PageHeader(title: Text('Login')),
      content: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Login Page'),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                // Navigate to home or another page after login
                // context.go('/home'); // Uncomment and set the correct path
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
