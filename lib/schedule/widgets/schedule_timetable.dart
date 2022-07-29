import 'package:dynamic_timeline/dynamic_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/schedule/schedule.dart';
import 'package:intl/intl.dart';
import 'package:routines_api/routines_api.dart';

class ScheduleTimetable extends StatefulWidget {
  const ScheduleTimetable({
    Key? key,
    required this.currentSize,
  }) : super(key: key);

  final ScheduleSize currentSize;

  @override
  State<ScheduleTimetable> createState() => _ScheduleTimetableState();
}

class _ScheduleTimetableState extends State<ScheduleTimetable> {
  late final ScrollController verticalController;
  late final ScrollController horizontalController;

  @override
  void initState() {
    super.initState();
    verticalController = ScrollController();
    horizontalController = ScrollController();
  }

  @override
  void dispose() {
    verticalController.dispose();
    horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final startHour = context.select(
      (AppBloc bloc) => bloc.state.timelineStartHour,
    );
    final endHour = context.select(
      (AppBloc bloc) => bloc.state.timelineEndHour,
    );

    return Padding(
      padding: const EdgeInsets.all(40),
      child: Scrollbar(
        thumbVisibility: true,
        controller: horizontalController,
        child: Scrollbar(
          controller: verticalController,
          child: SingleChildScrollView(
            controller: horizontalController,
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              controller: verticalController,
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 60),
                      ...List.generate(
                        7,
                        (index) => DayHeader(day: index),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  BlocSelector<ScheduleBloc, ScheduleState, List<Routine>>(
                    selector: (state) {
                      return state.routines;
                    },
                    builder: (context, routines) {
                      return DynamicTimeline(
                        firstDateTime: DateTime(1970, 01, 01, startHour),
                        lastDateTime: DateTime(1970, 01, 01, endHour),
                        labelBuilder: DateFormat('HH:mm').format,
                        intervalDuration: const Duration(hours: 1),
                        crossAxisCount: 7,
                        intervalExtent: 50,
                        minItemDuration: const Duration(minutes: 30),
                        maxCrossAxisItemExtent: 100,
                        items: routines
                            .map(
                              (routine) => TimelineItem(
                                key: ValueKey(routine),
                                startDateTime: routine.startTime,
                                endDateTime: routine.endTime,
                                position: routine.day - 1,
                                onStartDateTimeChanged: (startTime) =>
                                    context.read<ScheduleBloc>().add(
                                          ScheduleRoutineChanged(
                                            routine.copyWith(
                                              startTime: startTime,
                                            ),
                                          ),
                                        ),
                                onEndDateTimeChanged: (endTime) =>
                                    context.read<ScheduleBloc>().add(
                                          ScheduleRoutineChanged(
                                            routine.copyWith(
                                              endTime: endTime,
                                            ),
                                          ),
                                        ),
                                child: RoutineCard(
                                  routine: routine,
                                  currentSize: widget.currentSize,
                                ),
                              ),
                            )
                            .toList(),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
