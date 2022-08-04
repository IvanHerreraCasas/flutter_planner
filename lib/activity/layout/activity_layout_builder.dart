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
  }) : super(key: key);

  final ActivityWidgetBuilder headerButtons;
  final ActivityWidgetBuilder nameTextField;
  final ActivityWidgetBuilder descriptionTextField;
  final ActivityWidgetBuilder datePicker;
  final ActivityWidgetBuilder timePickers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            if (width <= ActivityBreakpoints.small) {
              const currentSize = ActivitySize.small;
              return Column(
                children: [
                  headerButtons(currentSize),
                  const SizedBox(height: 20),
                  nameTextField(currentSize),
                  const SizedBox(height: 20),
                  datePicker(currentSize),
                  timePickers(currentSize),
                  const SizedBox(height: 20),
                  Expanded(child: descriptionTextField(currentSize)),
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
                      datePicker(currentSize),
                      timePickers(currentSize),
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
