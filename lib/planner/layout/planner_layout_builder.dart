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
    required this.tabs,
    required this.fab,
  }) : super(key: key);

  final PlannerWidgetBuilder activitiesHeader;
  final PlannerWidgetBuilder tasksHeader;
  final PlannerWidgetBuilder calendar;
  final PlannerWidgetBuilder activities;
  final PlannerWidgetBuilder tasks;
  final PlannerWidgetBuilder tabs;
  final PlannerWidgetBuilder fab;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          if (width <= PlannerBreakpoints.small) {
            const currentSize = PlannerSize.small;
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    calendar(currentSize),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: tabs(currentSize),
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: fab(currentSize),
            );
          } else if (width <= PlannerBreakpoints.medium) {
            const currentSize = PlannerSize.medium;
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    calendar(currentSize),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: tabs(currentSize),
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: fab(currentSize),
            );
          }
          const currentSize = PlannerSize.large;
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 20,
              ),
              child: Row(
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
              ),
            ),
          );
        },
      ),
    );
  }
}
