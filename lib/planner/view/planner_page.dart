import 'package:activities_repository/activities_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      )
        ..add(const PlannerSubscriptionRequested())
        ..add(const PlannerTasksSubRequested()),
      child: PlannerLayoutBuilder(
        header: (currentSize) => PlannerHeader(currentSize: currentSize),
        calendar: (currentSize) => PlannerCalendar(currentSize: currentSize),
        activities: (currentSize) => PlannerActivities(
          currentSize: currentSize,
        ),
      ),
    );
  }
}
