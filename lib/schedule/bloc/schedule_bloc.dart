import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
    emit(state.copyWith(status: ScheduleStatus.loading));
    await emit.forEach<List<Routine>>(
      _routinesRepository.streamRoutines(),
      onData: (routines) => state.copyWith(
        status: ScheduleStatus.success,
        routines: routines,
      ),
      onError: (error, stack) {
        log('ScheduleBloc(31) --- error: ${error.toString()}');
        return state.copyWith(
          status: ScheduleStatus.failure,
          errorMessage: 'error: routines could not be loaded',
        );
      },
    );
  }

  Future<void> _onRoutineChanged(
    ScheduleRoutineChanged event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(state.copyWith(status: ScheduleStatus.loading));
    final routine = event.routine;
    try {
      await _routinesRepository.saveRoutine(routine);
      emit(state.copyWith(status: ScheduleStatus.success));
      if (routine.id == state.selectedRoutine?.id) {
        add(ScheduleSelectedRoutineChanged(routine));
      }
    } catch (e) {
      log('ScheduleBloc(56) --- error: ${e.toString()}');
      emit(
        state.copyWith(
          status: ScheduleStatus.failure,
          errorMessage: 'error: routines could not be saved',
        ),
      );
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
