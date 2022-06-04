import 'package:activities_api/activities_api.dart';
import 'package:activities_repository/activities_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/activity/activity.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({
    Key? key,
    this.isDialog = false,
  }) : super(key: key);

  static GoRoute route() {
    return GoRoute(
      path: 'activity',
      builder: (context, state) => BlocProvider(
        create: (context) => ActivityBloc(
          activitiesRepository: context.read<ActivitiesRepository>(),
          initialActivity: state.extra! as Activity,
        ),
        child: const ActivityPage(),
      ),
    );
  }

  static Dialog dialog({required Activity activity}) {
    return Dialog(
      child: Container(
        height: 600,
        width: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: BlocProvider(
          create: (context) => ActivityBloc(
            activitiesRepository: context.read<ActivitiesRepository>(),
            initialActivity: activity,
          ),
          child: const ActivityPage(
            isDialog: true,
          ),
        ),
      ),
    );
  }

  final bool isDialog;

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: BlocListener<ActivityBloc, ActivityState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          switch (state.status) {
            case ActivityStatus.initial:
              break;
            case ActivityStatus.loading:
              context.loaderOverlay.show();
              break;
            case ActivityStatus.success:
              context.loaderOverlay.hide();
              Navigator.of(context).pop();
              break;
            case ActivityStatus.failure:
              context.loaderOverlay.hide();
              // TODO(ivan): Handle ActivityStatus.failure.
              break;
          }
        },
        child: ActivityLayoutBuilder(
          headerButtons: (_) => ActivityHeaderButtons(isDialog: isDialog),
          nameTextField: (_) => const ActivityNameTextField(),
          descriptionTextField: (_) => const ActivityDescriptionTextField(),
          datePicker: (_) => ActivityDatePicker(isDialog: isDialog),
          timePickers: (_) => const ActivityTimePickers(),
        ),
      ),
    );
  }
}
