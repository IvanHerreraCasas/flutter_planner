import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsRemindersHeader extends StatelessWidget {
  const SettingsRemindersHeader({
    Key? key,
    required this.isPage,
  }) : super(key: key);

  final bool isPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isPage)
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
          ),
        Text(
          'Reminders',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}
