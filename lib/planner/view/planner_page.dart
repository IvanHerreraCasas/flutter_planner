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
        ..add(const PlannerEventsSubRequested())
        ..add(const PlannerTasksSubRequested()),
      child: const PlannerView(),
    );
  }
}

class PlannerView extends StatelessWidget {
  const PlannerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlannerBloc, PlannerState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        switch (state.status) {
          case PlannerStatus.initial:
            break;
          case PlannerStatus.loading:
            break;
          case PlannerStatus.success:
            break;
          case PlannerStatus.failure:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
              ),
            );
            break;
        }
      },
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
        tabs: (currentSize) => PlannerTabs(currentSize: currentSize),
        fab: (_) => const PlannerFab(),
      ),
    );
  }
}
