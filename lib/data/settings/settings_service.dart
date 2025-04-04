import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String darkModeKey = 'dark_mode';

  Future<void> setDarkMode(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(darkModeKey, enabled);
  }

  Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(darkModeKey) ?? true;
  }
}
