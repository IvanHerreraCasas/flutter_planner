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
  }) : super(key: key);

  final Activity activity;
  final PlannerSize currentSize;

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
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            width: double.infinity,
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
                  maxLines: 1,
                ),
                if (constraints.maxHeight > 50) ...[
                  const SizedBox(height: 5),
                  Text(
                    '${DateFormat('hh:mm').format(activity.startTime)}'
                    ' - '
                    '${DateFormat('hh:mm').format(activity.endTime)}',
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
