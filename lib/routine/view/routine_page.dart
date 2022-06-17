import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/routine/routine.dart';
import 'package:flutter_planner/schedule/schedule.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:routines_api/routines_api.dart';
import 'package:routines_repository/routines_repository.dart';

class RoutinePage extends StatelessWidget {
  const RoutinePage({
    Key? key,
    this.isPage = false,
  }) : super(key: key);

  final bool isPage;

  static GoRoute route() {
    return GoRoute(
      path: 'routine',
      builder: (context, state) => BlocProvider(
        create: (context) => RoutineBloc(
          routinesRepository: context.read<RoutinesRepository>(),
          initialRoutine: state.extra! as Routine,
        ),
        child: const RoutinePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
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
              // TODO(ivan): Handle RoutineStatus.failure
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
    );
  }
}
