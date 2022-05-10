import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:routines_api/routines_api.dart';
import 'package:routines_repository/routines_repository.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc({required RoutinesRepository routinesRepository})
      : _routinesRepository = routinesRepository,
        super(const ScheduleState()) {
    on<ScheduleSubscriptionRequested>(_onSubscriptionRequested);
    on<ScheduleRoutineChanged>(_onRoutineChanged);
    on<ScheduleSelectedRoutineChanged>(_onSelectedRoutineChanged);
  }

  final RoutinesRepository _routinesRepository;

  Future<void> _onSubscriptionRequested(
    ScheduleSubscriptionRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    await emit.forEach<List<Routine>>(
      _routinesRepository.streamRoutines(),
      onData: (routines) => state.copyWith(routines: routines),
      onError: (error, stack) {
        log(error.toString());
        return state;
      },
    );
  }

  Future<void> _onRoutineChanged(
    ScheduleRoutineChanged event,
    Emitter<ScheduleState> emit,
  ) async {
    final routine = event.routine;
    try {
      await _routinesRepository.saveRoutine(routine);
      if (routine.id == state.selectedRoutine?.id) {
        add(ScheduleSelectedRoutineChanged(routine));
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void _onSelectedRoutineChanged(
    ScheduleSelectedRoutineChanged event,
    Emitter<ScheduleState> emit,
  ) {
    emit(
      state.copyWith(
        selectedRoutine: () => event.selectedRoutine,
      ),
    );
  }

  @override
  Future<void> close() {
    _routinesRepository.dispose();
    return super.close();
  }
}
