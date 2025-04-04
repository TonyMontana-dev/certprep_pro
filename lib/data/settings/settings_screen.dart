import 'package:flutter/material.dart';
import '../../data/settings/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = true;
  final _settings = SettingsService();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final mode = await _settings.getDarkMode();
    setState(() => _darkMode = mode);
  }

  void _toggleDarkMode(bool value) async {
    await _settings.setDarkMode(value);
    setState(() => _darkMode = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: SwitchListTile(
        value: _darkMode,
        onChanged: _toggleDarkMode,
        title: const Text("Dark Mode"),
      ),
    );
  }
}
