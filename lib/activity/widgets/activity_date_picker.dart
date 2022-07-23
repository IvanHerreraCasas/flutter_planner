import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/activity/activity.dart';
import 'package:flutter_planner/widgets/widgets.dart';

class ActivityDatePicker extends StatelessWidget {
  const ActivityDatePicker({
    Key? key,
    required this.isDialog,
  }) : super(key: key);

  final bool isDialog;

  @override
  Widget build(BuildContext context) {
    final date = context.select(
      (ActivityBloc bloc) => bloc.state.date,
    );

    return CustomDatePicker(
      date: date,
      enabled: !isDialog,
      onChangeDate: (date) => context.read<ActivityBloc>().add(
            ActivityDateChanged(date),
          ),
    );
  }
}
