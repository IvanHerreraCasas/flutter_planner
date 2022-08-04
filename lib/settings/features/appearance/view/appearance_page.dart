import 'package:flutter/material.dart';
import 'package:flutter_planner/settings/settings.dart';

class AppearancePage extends StatelessWidget {
  const AppearancePage({Key? key, required this.isPage}) : super(key: key);

  final bool isPage;

  @override
  Widget build(BuildContext context) {
    return AppearanceView(isPage: isPage);
  }
}

class AppearanceView extends StatelessWidget {
  const AppearanceView({Key? key, required this.isPage}) : super(key: key);

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
            AppearanceHeader(
              isPage: isPage,
            ),
            const SizedBox(height: 40),
            Expanded(
              child: ListView(
                children: const [
                  AppearanceTheme(),
                  SizedBox(height: 30),
                  AppearanceTimeline(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
