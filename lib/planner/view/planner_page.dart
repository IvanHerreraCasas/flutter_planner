import 'package:activities_repository/activities_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/activity/activity.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:go_router/go_router.dart';
import 'package:routines_repository/routines_repository.dart';
import 'package:table_calendar/table_calendar.dart';

class PlannerPage extends StatelessWidget {
  const PlannerPage({Key? key}) : super(key: key);

  static GoRoute route() {
    return GoRoute(
      path: '/planner',
      builder: (context, state) => const PlannerPage(),
      routes: [
        ActivityPage.route(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlannerBloc>(
      create: (context) => PlannerBloc(
        activitiesRepository: context.read<ActivitiesRepository>(),
        routinesRepository: context.read<RoutinesRepository>(),
      )..add(const PlannerSubscriptionRequested()),
      child: BlocListener<PlannerBloc, PlannerState>(
        listenWhen: (previous, current) => previous.size != current.size,
        listener: (context, state) {
          if (state.size == PlannerSize.large) {
            context
                .read<PlannerBloc>()
                .add(const PlannerCalendarFormatChanged(CalendarFormat.month));
          } else {
            context
                .read<PlannerBloc>()
                .add(const PlannerCalendarFormatChanged(CalendarFormat.week));
          }
        },
        child: PlannerLayoutBuilder(
          onResize: (currentSize, context) => context.read<PlannerBloc>().add(
                PlannerSizeChanged(currentSize),
              ),
          header: (currentSize) => PlannerHeader(currentSize: currentSize),
          calendar: (currentSize) => PlannerCalendar(currentSize: currentSize),
          activities: (currentSize) => PlannerActivities(
            currentSize: currentSize,
          ),
        ),
      ),
    );
  }
}
