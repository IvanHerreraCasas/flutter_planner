part of 'schedule_bloc.dart';

enum ScheduleStatus { initial, loading, success, failure }

class ScheduleState extends Equatable {
  const ScheduleState({
    this.status = ScheduleStatus.initial,
    this.routines = const [],
    this.selectedRoutine,
    this.errorMessage = '',
  });

  final ScheduleStatus status;
  final List<Routine> routines;
  final Routine? selectedRoutine;
  final String errorMessage;

  ScheduleState copyWith({
    ScheduleStatus? status,
    List<Routine>? routines,
    Routine? Function()? selectedRoutine,
    String? errorMessage,
  }) {
    return ScheduleState(
      status: status ?? this.status,
      routines: routines ?? this.routines,
      selectedRoutine:
          (selectedRoutine != null) ? selectedRoutine() : this.selectedRoutine,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        routines,
        selectedRoutine,
        errorMessage,
      ];
}
