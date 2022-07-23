import 'package:activities_api/activities_api.dart';
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
          if (constraints.maxHeight > 50) {
            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        activity.name,
                        style: theme.textTheme.headline6,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      if (currentSize != PlannerSize.small) ...[
                        const SizedBox(width: 10),
                        Text(
                          '${DateFormat('hh: mm').format(activity.startTime)}'
                          ' - '
                          '${DateFormat('hh: mm').format(activity.endTime)}',
                          style: theme.textTheme.bodyText1,
                        ),
                      ],
                    ],
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 15),
                        Text(
                          activity.description,
                          style: theme.textTheme.bodyText2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Text(
                  activity.name,
                  style: theme.textTheme.headline6!.copyWith(fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                if (currentSize != PlannerSize.small) ...[
                  const SizedBox(width: 10),
                  Text(
                    '${DateFormat('hh: mm').format(activity.startTime)}'
                    ' - '
                    '${DateFormat('hh: mm').format(activity.endTime)}',
                    style: theme.textTheme.bodyText1!.copyWith(fontSize: 10),
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
