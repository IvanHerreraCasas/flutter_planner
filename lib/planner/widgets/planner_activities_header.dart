import 'package:activities_repository/activities_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/activity/activity.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:go_router/go_router.dart';

class PlannerActivitiesHeader extends StatelessWidget {
  const PlannerActivitiesHeader({
    Key? key,
    required this.currentSize,
  }) : super(key: key);

  final PlannerSize currentSize;

  void _onAdd({
    required PlannerSize currentSize,
    required BuildContext context,
    required DateTime selectedDay,
  }) {
    final newActivity = Activity(
      userID: context.read<AuthenticationBloc>().state.user!.id,
      date: selectedDay,
      startTime: DateTime(1970, 1, 1, 7),
      endTime: DateTime(1970, 1, 1, 8),
    );
    if (currentSize == PlannerSize.large) {
      showDialog<Object>(
        context: context,
        builder: (context) => ActivityPage.dialog(
          activity: newActivity,
        ),
      );
    } else {
      context.goNamed(
        AppRoutes.activity,
        params: {'page': 'planner'},
        extra: newActivity,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedDay = context.select(
      (PlannerBloc bloc) => bloc.state.selectedDay,
    );

    return Row(
      children: [
        Expanded(
          child: Text(
            'Activities',
            style: Theme.of(context).textTheme.headline5,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        ElevatedButton(
          onPressed: () => context.read<PlannerBloc>().add(
                const PlannerAddRoutines(),
              ),
          child: const Text('Add routines'),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () => _onAdd(
            currentSize: currentSize,
            context: context,
            selectedDay: selectedDay,
          ),
          child: const Text('Add'),
        ),
      ],
    );
  }
}
