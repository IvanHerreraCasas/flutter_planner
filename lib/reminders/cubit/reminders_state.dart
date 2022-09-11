part of 'reminders_cubit.dart';

class RemindersState extends Equatable {
  const RemindersState({
    this.reminderValues = const [],
  });

  final List<bool> reminderValues;

  RemindersState copyWith({
    List<bool>? reminderValues,
  }) {
    return RemindersState(
      reminderValues: reminderValues ?? this.reminderValues,
    );
  }

  @override
  List<Object?> get props => [reminderValues];
}
