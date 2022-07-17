import 'package:activities_repository/activities_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:routines_repository/routines_repository.dart';
import 'package:tasks_repository/tasks_repository.dart';

class PlannerPage extends StatelessWidget {
  const PlannerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlannerBloc>(
      create: (context) => PlannerBloc(
        activitiesRepository: context.read<ActivitiesRepository>(),
        routinesRepository: context.read<RoutinesRepository>(),
        tasksRepository: context.read<TasksRepository>(),
        userID: context.read<AuthenticationBloc>().state.user!.id,
      )
        ..add(const PlannerSubscriptionRequested())
        ..add(const PlannerTasksSubRequested()),
      child: PlannerLayoutBuilder(
        activitiesHeader: (currentSize) => PlannerActivitiesHeader(
          currentSize: currentSize,
        ),
        tasksHeader: (_) => const PlannerTasksHeader(),
        calendar: (currentSize) => PlannerCalendar(currentSize: currentSize),
        activities: (currentSize) => PlannerActivities(
          currentSize: currentSize,
        ),
        tasks: (_) => const PlannerTasks(),
      ),
    );
  }
}
