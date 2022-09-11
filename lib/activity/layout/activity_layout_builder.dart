import 'package:flutter/material.dart';
import 'package:flutter_planner/activity/activity.dart';

enum ActivitySize { small, large }

typedef ActivityWidgetBuilder = Widget Function(ActivitySize currentSize);

class ActivityLayoutBuilder extends StatelessWidget {
  const ActivityLayoutBuilder({
    Key? key,
    required this.headerButtons,
    required this.nameTextField,
    required this.descriptionTextField,
    required this.datePicker,
    required this.timePickers,
    required this.typePicker,
    required this.allDaySwitch,
    required this.reminders,
  }) : super(key: key);

  final ActivityWidgetBuilder headerButtons;
  final ActivityWidgetBuilder nameTextField;
  final ActivityWidgetBuilder descriptionTextField;
  final ActivityWidgetBuilder datePicker;
  final ActivityWidgetBuilder timePickers;
  final ActivityWidgetBuilder typePicker;
  final ActivityWidgetBuilder allDaySwitch;
  final ActivityWidgetBuilder reminders;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            if (width <= ActivityBreakpoints.small) {
              const currentSize = ActivitySize.small;
              return ListView(
                children: [
                  headerButtons(currentSize),
                  const SizedBox(height: 20),
                  nameTextField(currentSize),
                  const SizedBox(height: 20),
                  typePicker(currentSize),
                  const SizedBox(height: 10),
                  datePicker(currentSize),
                  const SizedBox(height: 10),
                  allDaySwitch(currentSize),
                  timePickers(currentSize),
                  const SizedBox(height: 20),
                  reminders(currentSize),
                  const SizedBox(height: 20),
                  descriptionTextField(currentSize)
                ],
              );
            }
            const currentSize = ActivitySize.large;

            return Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      headerButtons(currentSize),
                      const SizedBox(height: 20),
                      nameTextField(currentSize),
                      const SizedBox(height: 20),
                      Expanded(child: descriptionTextField(currentSize)),
                    ],
                  ),
                ),
                const SizedBox(width: 30),
                SizedBox(
                  width: 250,
                  child: Column(
                    children: [
                      typePicker(currentSize),
                      const SizedBox(height: 10),
                      datePicker(currentSize),
                      const SizedBox(height: 10),
                      allDaySwitch(currentSize),
                      timePickers(currentSize),
                      reminders(currentSize),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
