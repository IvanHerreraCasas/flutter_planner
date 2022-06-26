import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/activity/activity.dart';
import 'package:flutter_planner/app/router/router.dart';
import 'package:go_router/go_router.dart';

class ActivityHeaderButtons extends StatelessWidget {
  const ActivityHeaderButtons({
    Key? key,
    required this.isDialog,
  }) : super(key: key);

  final bool isDialog;

  void _onPressedLeadingIcon({
    required BuildContext context,
    required bool isDialog,
  }) {
    if (isDialog) {
      final state = context.read<ActivityBloc>().state;
      context.goNamed(
        AppRoutes.activity,
        params: {'page': 'planner'},
        extra: state.initialActivity.copyWith(
          name: state.name,
          date: state.date,
          description: state.description,
          startTime: state.startTime,
          endTime: state.endTime,
          links: state.links,
        ),
      );
    } else {
      context.pop();
    }
  }

  void _onPressedSaveButton({required BuildContext context}) {
    context.read<ActivityBloc>().add(const ActivitySaved());
  }

  void _onSelectedMenuButton({
    required BuildContext context,
    required String? value,
  }) {
    if (value == 'delete') {
      context.read<ActivityBloc>().add(const ActivityDeleted());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => _onPressedLeadingIcon(
            context: context,
            isDialog: isDialog,
          ),
          icon: Icon(isDialog ? Icons.open_in_full : Icons.arrow_back),
          tooltip: isDialog ? 'Open as a page' : null,
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () => _onPressedSaveButton(context: context),
          child: const Text('Save'),
        ),
        const SizedBox(width: 5),
        PopupMenuButton<String>(
          onSelected: (value) => _onSelectedMenuButton(
            context: context,
            value: value,
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'delete',
              child: Text(
                'Delete',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
