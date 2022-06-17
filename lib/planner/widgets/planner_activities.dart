import 'package:dynamic_timeline/dynamic_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  final double intervalExtent = 80;

  @override
  void initState() {
    super.initState();
    final currentHour = DateTime.now().hour;
    controller = ScrollController(
      initialScrollOffset: intervalExtent * (currentHour - 7),
    );
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

    return SingleChildScrollView(
      controller: controller,
      padding: const EdgeInsets.all(20),
      child: Align(
        alignment: Alignment.topLeft,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = constraints.maxWidth - 80;
            return DynamicTimeline(
              firstDateTime: DateTime(1970, 01, 01, 7),
              lastDateTime: DateTime(1970, 01, 01, 22),
              labelBuilder: DateFormat('HH:mm').format,
              intervalDuration: const Duration(hours: 1),
              resizable: false,
              maxCrossAxisItemExtent: itemWidth,
              intervalExtent: intervalExtent,
              items: activities
                  .map(
                    (activity) => TimelineItem(
                      key: ValueKey(activity),
                      startDateTime: activity.startTime,
                      endDateTime: activity.endTime,
                      child: ActivityCard(
                        activity: activity,
                        currentSize: widget.currentSize,
                        width: itemWidth,
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}
