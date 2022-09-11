import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/reminders/reminders.dart';

class RemindersPage extends StatelessWidget {
  const RemindersPage({
    Key? key,
    required this.reminderValues,
    required this.isAllDay,
  }) : super(key: key);

  final List<bool> reminderValues;
  final bool isAllDay;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: RemindersCubit(reminderValues: reminderValues),
      child: RemindersView(isAllDay: isAllDay),
    );
  }
}

class RemindersView extends StatelessWidget {
  const RemindersView({
    Key? key,
    required this.isAllDay,
  }) : super(key: key);

  final bool isAllDay;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final reminderValues =
            context.read<RemindersCubit>().state.reminderValues;
        Navigator.of(context).pop(reminderValues);
        return false;
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RemindersHeader(),
            const SizedBox(height: 10),
            Expanded(
              child: RemindersList(isAllDay: isAllDay),
            ),
          ],
        ),
      ),
    );
  }
}
