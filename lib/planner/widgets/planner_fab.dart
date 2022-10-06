import 'package:activities_repository/activities_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/router/router.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:go_router/go_router.dart';

class PlannerFab extends StatelessWidget {
  const PlannerFab({Key? key}) : super(key: key);

  void _onPressed({
    required BuildContext context,
    required int selectedTab,
    required DateTime selectedDay,
  }) {
    switch (selectedTab) {
      case 0:
        context.read<PlannerBloc>().add(
              const PlannerNewTaskAdded(),
            );
        break;
      case 1:
        final newActivity = Activity(
          userID: context.read<AuthenticationBloc>().state.user!.id,
          date: selectedDay,
          startTime: DateTime(1970, 1, 1, 7),
          endTime: DateTime(1970, 1, 1, 8),
        );
        context.goNamed(
          AppRoutes.activity,
          params: {'page': 'planner'},
          extra: newActivity,
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select(
      (PlannerBloc bloc) => bloc.state.selectedTab,
    );
    final selectedDay = context.select(
      (PlannerBloc bloc) => bloc.state.selectedDay,
    );

    return FloatingActionButton(
      onPressed: () => _onPressed(
        context: context,
        selectedTab: selectedTab,
        selectedDay: selectedDay,
      ),
      child: const Icon(Icons.add),
    );
  }
}
