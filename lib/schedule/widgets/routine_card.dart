import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/router/router.dart';
import 'package:flutter_planner/schedule/schedule.dart';
import 'package:go_router/go_router.dart';
import 'package:routines_api/routines_api.dart';

class RoutineCard extends StatelessWidget {
  const RoutineCard({
    Key? key,
    required this.routine,
    required this.currentSize,
  }) : super(key: key);

  final Routine routine;
  final ScheduleSize currentSize;

  void _onTap({required BuildContext context}) {
    if (currentSize == ScheduleSize.large) {
      context.read<ScheduleBloc>().add(ScheduleSelectedRoutineChanged(routine));
    } else {
      context.goNamed(
        AppRoutes.routine.name,
        params: {'page': 'schedule'},
        extra: routine,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _onTap(context: context),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          routine.name,
          style: theme.textTheme.bodyText2,
        ),
      ),
    );
  }
}
