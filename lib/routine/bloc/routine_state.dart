part of 'routine_bloc.dart';

enum RoutineStatus { initial, loading, success, failure }

class RoutineState extends Equatable {
  const RoutineState({
    this.status = RoutineStatus.initial,
    required this.initialRoutine,
    this.name = '',
    this.day = 1,
    required this.startTime,
    required this.endTime,
    this.errorMessage = '',
  });

  final RoutineStatus status;
  final Routine initialRoutine;
  final String name;
  final int day;
  final DateTime startTime;
  final DateTime endTime;
  final String errorMessage;

  RoutineState copyWith({
    RoutineStatus? status,
    Routine? initialRoutine,
    String? name,
    int? day,
    DateTime? startTime,
    DateTime? endTime,
    String? errorMessage,
  }) {
    return RoutineState(
      status: status ?? this.status,
      initialRoutine: initialRoutine ?? this.initialRoutine,
      name: name ?? this.name,
      day: day ?? this.day,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        initialRoutine,
        name,
        day,
        startTime,
        endTime,
        errorMessage,
      ];
}
