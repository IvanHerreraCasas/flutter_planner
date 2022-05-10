import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/routine/view/routine_page.dart';
import 'package:flutter_planner/schedule/schedule.dart';
import 'package:go_router/go_router.dart';
import 'package:routines_repository/routines_repository.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({Key? key}) : super(key: key);

  static GoRoute route() {
    return GoRoute(
      path: 'schedule',
      builder: (context, state) => const SchedulePage(),
      routes: [RoutinePage.route()],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScheduleBloc>(
      create: (context) =>
          ScheduleBloc(routinesRepository: context.read<RoutinesRepository>())
            ..add(const ScheduleSubscriptionRequested()),
      child: ScheduleLayoutBuilder(
        header: (currentSize) => ScheduleHeader(currentSize: currentSize),
        timetable: (currentSize) => ScheduleTimetable(currentSize: currentSize),
        sidePane: (_) => const ScheduleSidePane(),
      ),
    );
  }
}
