import 'package:activities_repository/activities_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_planner/activity/activity.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    Key? key,
    required this.activity,
    required this.currentSize,
    required this.isAllDay,
  }) : super(key: key);

  final Activity activity;
  final PlannerSize currentSize;
  final bool isAllDay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => currentSize == PlannerSize.large
          ? showDialog<Object>(
              context: context,
              builder: (context) => ActivityPage.dialog(activity: activity),
            )
          : context.goNamed(
              AppRoutes.activity,
              params: {'page': 'planner'},
              extra: activity,
            ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        width: double.infinity,
        height: isAllDay ? 80 : null,
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              activity.name,
              style: theme.textTheme.titleLarge,
              overflow: TextOverflow.fade,
              softWrap: false,
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxHeight > 40 && !isAllDay) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 5),
                        Flexible(
                          child: Text(
                            '${DateFormat('HH:mm').format(activity.startTime)}'
                            ' - '
                            '${DateFormat('HH:mm').format(activity.endTime)}',
                            style: theme.textTheme.bodySmall,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
