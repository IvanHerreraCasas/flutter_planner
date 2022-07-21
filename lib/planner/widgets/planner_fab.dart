import 'package:activities_api/activities_api.dart';
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
  }) {
    switch (selectedTab) {
      case 0:
        context.read<PlannerBloc>().add(
              const PlannerNewTaskAdded(),
            );
        break;
      case 1:
        final currentDate = DateTime.now();
        final newActivity = Activity(
          userID: context.read<AuthenticationBloc>().state.user!.id,
          date: DateTime(
            currentDate.year,
            currentDate.month,
            currentDate.day,
          ),
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
    return FloatingActionButton(
      onPressed: () => _onPressed(context: context, selectedTab: selectedTab),
      child: const Icon(Icons.add),
    );
  }
}
