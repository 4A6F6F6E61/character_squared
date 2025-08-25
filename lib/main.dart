import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:character_squared/router.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await dotenv.load();

  await Supabase.initialize(anonKey: dotenv.env['SUPABASE_KEY']!, url: dotenv.env['SUPABASE_URL']!);

  WidgetsFlutterBinding.ensureInitialized();

  await Window.initialize();

  if (Platform.isWindows) {
    await Window.hideWindowControls();
  }

  runApp(const MyApp());

  doWhenWindowReady(() {
    appWindow
      ..minSize = Size(360, 640)
      ..size = Size(800, 1300)
      ..show();
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return FluentApp.router(
      title: 'Character Squared',
      theme: FluentThemeData(
        brightness: Brightness.dark,
        // Important if you want to use a Scaffold and have Flutter Acrylic's effects
        scaffoldBackgroundColor: Color(0x00000000),
      ),
      routerConfig: router,
    );
  }
}
