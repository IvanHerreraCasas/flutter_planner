part of 'schedule_bloc.dart';

class ScheduleState extends Equatable {
  const ScheduleState({
    this.routines = const [],
    this.selectedRoutine,
  });

  final List<Routine> routines;
  final Routine? selectedRoutine;

  ScheduleState copyWith({
    List<Routine>? routines,
    Routine? Function()? selectedRoutine,
  }) {
    return ScheduleState(
      routines: routines ?? this.routines,
      selectedRoutine:
          (selectedRoutine != null) ? selectedRoutine() : this.selectedRoutine,
    );
  }

  @override
  List<Object?> get props => [routines, selectedRoutine];
}
