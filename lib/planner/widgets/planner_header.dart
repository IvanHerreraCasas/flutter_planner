import 'package:activities_api/activities_api.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/activity/activity.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:go_router/go_router.dart';

class PlannerHeader extends StatelessWidget {
  const PlannerHeader({
    Key? key,
    required this.currentSize,
  }) : super(key: key);

  final PlannerSize currentSize;

  void _onAdd({
    required PlannerSize currentSize,
    required BuildContext context,
  }) {
    final newActivity = Activity(
      userID: context.read<AuthenticationRepository>().user!.id,
      date: DateTime.now(),
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
      context.go(
        '/home/planner/activity',
        extra: newActivity,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Activities',
          style: Theme.of(context).textTheme.headline5,
        ),
        const Spacer(),
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
          ),
          child: const Text('Add'),
        ),
      ],
    );
  }
}
