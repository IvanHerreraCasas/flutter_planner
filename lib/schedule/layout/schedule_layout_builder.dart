import 'package:flutter/material.dart';
import 'package:flutter_planner/schedule/schedule.dart';

typedef ScheduleWidgetBuilder = Widget Function(ScheduleSize currentSize);

enum ScheduleSize { small, large }

class ScheduleLayoutBuilder extends StatelessWidget {
  const ScheduleLayoutBuilder({
    Key? key,
    required this.header,
    required this.timetable,
    required this.sidePane,
  }) : super(key: key);

  final ScheduleWidgetBuilder header;
  final ScheduleWidgetBuilder timetable;
  final ScheduleWidgetBuilder sidePane;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        late final ScheduleSize currentSize;
        if (constraints.maxWidth <= SchedulerBreakpoints.small) {
          currentSize = ScheduleSize.small;
        } else {
          currentSize = ScheduleSize.large;
        }
        return Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  header(currentSize),
                  const SizedBox(height: 20),
                  Expanded(
                    child: timetable(currentSize),
                  ),
                ],
              ),
            ),
            sidePane(currentSize),
          ],
        );
      },
    );
  }
}
