import 'package:flutter/material.dart';
import 'package:flutter_planner/settings/settings.dart';

class SettingsRemindersPage extends StatelessWidget {
  const SettingsRemindersPage({
    Key? key,
    required this.isPage,
  }) : super(key: key);

  final bool isPage;

  @override
  Widget build(BuildContext context) {
    return SettingsRemindersView(isPage: isPage);
  }
}

class SettingsRemindersView extends StatelessWidget {
  const SettingsRemindersView({
    Key? key,
    required this.isPage,
  }) : super(key: key);

  final bool isPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsRemindersHeader(isPage: isPage),
            const SizedBox(height: 40),
            const Expanded(
              child: SettingsRemindersTasks(),
            ),
          ],
        ),
      ),
    );
  }
}
