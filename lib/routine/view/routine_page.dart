import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/routine/routine.dart';
import 'package:flutter_planner/schedule/schedule.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';

class RoutinePage extends StatelessWidget {
  const RoutinePage({
    Key? key,
    this.isPage = false,
  }) : super(key: key);

  final bool isPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoaderOverlay(
        child: BlocListener<RoutineBloc, RoutineState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            switch (state.status) {
              case RoutineStatus.initial:
                break;
              case RoutineStatus.loading:
                context.loaderOverlay.show();
                break;
              case RoutineStatus.success:
                context.loaderOverlay.hide();
                if (isPage) {
                  context.pop();
                } else {
                  context
                      .read<ScheduleBloc>()
                      .add(const ScheduleSelectedRoutineChanged(null));
                }
                break;
              case RoutineStatus.failure:
                context.loaderOverlay.hide();
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
          child: RoutineLayoutBuilder(
            headerButtons: () => RoutineHeaderButtons(isPage: isPage),
            nameTextField: () => const RoutineNameTextField(),
            dayPicker: () => const RoutineDayPicker(),
            timePickers: () => const RoutineTimePickers(),
          ),
        ),
      ),
    );
  }
}
