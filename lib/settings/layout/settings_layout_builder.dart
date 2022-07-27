import 'package:flutter/material.dart';
import 'package:flutter_planner/settings/settings.dart';

enum SettingsSize { small, large }

typedef SettingsWidgetBuilder = Widget Function(SettingsSize currentSize);

class SettingsLayoutBuilder extends StatelessWidget {
  const SettingsLayoutBuilder({
    Key? key,
    required this.options,
    required this.body,
  }) : super(key: key);

  final SettingsWidgetBuilder options;
  final SettingsWidgetBuilder body;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width <= SettingsBreakpoints.small) {
          const currentSize = SettingsSize.small;
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: options(currentSize),
            ),
          );
        }

        const currentSize = SettingsSize.large;
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                SizedBox(
                  width: 200,
                  child: options(currentSize),
                ),
                const SizedBox(width: 40),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: body(currentSize),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
