import 'package:flutter/material.dart';
import 'package:flutter_planner/planner/planner.dart';

enum PlannerSize { small, medium, large }

typedef PlannerWidgetBuilder = Widget Function(PlannerSize currentSize);

class PlannerLayoutBuilder extends StatelessWidget {
  const PlannerLayoutBuilder({
    Key? key,
    required this.activitiesHeader,
    required this.tasksHeader,
    required this.calendar,
    required this.activities,
    required this.tasks,
  }) : super(key: key);

  final PlannerWidgetBuilder activitiesHeader;
  final PlannerWidgetBuilder tasksHeader;
  final PlannerWidgetBuilder calendar;
  final PlannerWidgetBuilder activities;
  final PlannerWidgetBuilder tasks;

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

            if (width <= PlannerBreakpoints.small) {
              const currentSize = PlannerSize.small;
              return Column(
                children: [
                  calendar(currentSize),
                  const SizedBox(height: 20),
                  activitiesHeader(currentSize),
                  const SizedBox(height: 20),
                  Expanded(child: activities(currentSize))
                ],
              );
            } else if (width <= PlannerBreakpoints.medium) {
              const currentSize = PlannerSize.medium;
              return Column(
                children: [
                  calendar(currentSize),
                  const SizedBox(height: 20),
                  activitiesHeader(currentSize),
                  const SizedBox(height: 20),
                  Expanded(child: activities(currentSize))
                ],
              );
            }
            const currentSize = PlannerSize.large;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                    ),
                    child: Column(
                      children: [
                        calendar(currentSize),
                        const SizedBox(height: 30),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(15),
                              
                            ),
                            child: Column(
                              children: [
                                tasksHeader(currentSize),
                                const SizedBox(height: 10),
                                Expanded(child: tasks(currentSize)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      activitiesHeader(currentSize),
                      const SizedBox(height: 20),
                      Expanded(child: activities(currentSize))
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
