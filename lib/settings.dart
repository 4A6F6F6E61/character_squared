import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  Settings._();

  static late final SharedPreferences prefs;
  static bool initialized = false;

  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static bool get includeAdult => prefs.getBool("includeAdult") ?? false;
  static set includeAdult(bool value) => prefs.setBool("includeAdult", value);
}
