import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/schedule/schedule.dart';
import 'package:routines_repository/routines_repository.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScheduleBloc>(
      create: (context) =>
          ScheduleBloc(routinesRepository: context.read<RoutinesRepository>())
            ..add(const ScheduleSubscriptionRequested()),
      child: const ScheduleView(),
    );
  }
}

class ScheduleView extends StatelessWidget {
  const ScheduleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScheduleBloc, ScheduleState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        switch (state.status) {
          case ScheduleStatus.initial:
            break;
          case ScheduleStatus.loading:
            break;
          case ScheduleStatus.success:
            break;
          case ScheduleStatus.failure:
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
      child: ScheduleLayoutBuilder(
        header: (currentSize) => ScheduleHeader(currentSize: currentSize),
        timetable: (currentSize) => ScheduleTimetable(currentSize: currentSize),
        sidePane: (currentSize) => ScheduleSidePane(currentSize: currentSize),
      ),
    );
  }
}
