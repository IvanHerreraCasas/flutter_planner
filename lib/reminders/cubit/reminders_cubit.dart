import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'reminders_state.dart';

class RemindersCubit extends Cubit<RemindersState> {
  RemindersCubit({
    required List<bool> reminderValues,
  }) : super(RemindersState(reminderValues: reminderValues));

  void changeReminderValue(int index) {
    final reminderValues = List.of(state.reminderValues);

    reminderValues[index] = !reminderValues[index];

    emit(state.copyWith(reminderValues: reminderValues));
  }
}
