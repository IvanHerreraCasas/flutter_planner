import 'package:flutter/material.dart';

typedef RoutineWidgetBuilder = Widget Function();

class RoutineLayoutBuilder extends StatelessWidget {
  const RoutineLayoutBuilder({
    Key? key,
    required this.headerButtons,
    required this.nameTextField,
    required this.dayPicker,
    required this.timePickers,
  }) : super(key: key);

  final RoutineWidgetBuilder headerButtons;
  final RoutineWidgetBuilder nameTextField;
  final RoutineWidgetBuilder dayPicker;
  final RoutineWidgetBuilder timePickers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headerButtons(),
            nameTextField(),
            const SizedBox(height: 20),
            dayPicker(),
            timePickers(),
          ],
        ),
      ),
    );
  }
}
