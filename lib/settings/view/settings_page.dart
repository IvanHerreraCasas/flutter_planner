import 'package:flutter/material.dart';
import 'package:flutter_planner/settings/settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SettingsView();
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsLayoutBuilder(
      options: (currentSize) => SettingsOptions(currentSize: currentSize),
      body: (_) => const SettingsBody(),
    );
  }
}
