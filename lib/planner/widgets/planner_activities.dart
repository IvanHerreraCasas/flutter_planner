import 'package:dynamic_timeline/dynamic_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:intl/intl.dart';

class PlannerActivities extends StatefulWidget {
  const PlannerActivities({
    Key? key,
    required this.currentSize,
  }) : super(key: key);

  final PlannerSize currentSize;

  @override
  State<PlannerActivities> createState() => _PlannerActivitiesState();
}

class _PlannerActivitiesState extends State<PlannerActivities> {
  late final ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activities = context.select(
      (PlannerBloc bloc) => bloc.state.activities,
    );
    final startHour = context.select(
      (AppBloc bloc) => bloc.state.timelineStartHour,
    );
    final endHour = context.select(
      (AppBloc bloc) => bloc.state.timelineEndHour,
    );

    final allDayActivities = List.of(activities)
      ..retainWhere(
        (activity) => activity.isAllDay,
      );

    final normalActivities = List.of(activities)
      ..removeWhere(
        (activity) => activity.isAllDay,
      );

    return ListView(
      controller: controller,
      padding: const EdgeInsets.all(20),
      children: [
        ...allDayActivities
            .map(
              (activity) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ActivityCard(
                  activity: activity,
                  currentSize: widget.currentSize,
                  isAllDay: true,
                ),
              ),
            )
            .toList(),
        const SizedBox(height: 10),
        DynamicTimeline(
          firstDateTime: DateTime(1970, 01, 01, startHour),
          lastDateTime: DateTime(1970, 01, 01, endHour),
          labelBuilder: DateFormat('HH:mm').format,
          intervalDuration: const Duration(hours: 1),
          resizable: false,
          intervalExtent: 80,
          items: normalActivities
              .map(
                (activity) => TimelineItem(
                  key: ValueKey(activity),
                  startDateTime: activity.startTime,
                  endDateTime: activity.endTime,
                  child: ActivityCard(
                    activity: activity,
                    currentSize: widget.currentSize,
                    isAllDay: false,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
