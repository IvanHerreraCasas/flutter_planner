import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_planner/routine/routine.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:routines_repository/routines_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group('RoutineBloc', () {
    late RoutinesRepository routinesRepository;
    final fakeInitialRoutine = Routine(
      userID: 'userID',
      name: '',
      day: 1,
      startTime: DateTime(1970, 1, 1, 7),
      endTime: DateTime(1970, 1, 1, 8),
    );
    final fakeInitialState = RoutineState(
      initialRoutine: fakeInitialRoutine,
      name: fakeInitialRoutine.name,
      day: fakeInitialRoutine.day,
      startTime: fakeInitialRoutine.startTime,
      endTime: fakeInitialRoutine.endTime,
    );

    setUp(() {
      routinesRepository = MockRoutinesRepository();
    });

    RoutineBloc buildBloc() {
      return RoutineBloc(
        routinesRepository: routinesRepository,
        initialRoutine: fakeInitialRoutine,
      );
    }

    group('constructor', () {
      test('works normally', () {
        expect(buildBloc, returnsNormally);
      });

      test('has correct initial state', () {
        expect(buildBloc().state, equals(fakeInitialState));
      });
    });

    group('RoutineNameChanged', () {
      blocTest<RoutineBloc, RoutineState>(
        'emits new state with updated name.',
        build: buildBloc,
        act: (bloc) => bloc.add(const RoutineNameChanged('new-name')),
        expect: () => <RoutineState>[
          fakeInitialState.copyWith(name: 'new-name'),
        ],
      );
    });

    group('RoutineDayChanged', () {
      blocTest<RoutineBloc, RoutineState>(
        'emits new state with updated day.',
        build: buildBloc,
        act: (bloc) => bloc.add(const RoutineDayChanged(5)),
        expect: () => <RoutineState>[
          fakeInitialState.copyWith(day: 5),
        ],
      );
    });

    group('RoutineStartTimeChanged', () {
      final startTime = DateTime(1970, 1, 1, 12);
      blocTest<RoutineBloc, RoutineState>(
        'emits new state with updated startTime',
        build: buildBloc,
        act: (bloc) => bloc.add(RoutineStartTimeChanged(startTime)),
        expect: () =>
            <RoutineState>[fakeInitialState.copyWith(startTime: startTime)],
      );
    });

    group('RoutineEndTimeChanged', () {
      final endTime = DateTime(1970, 1, 1, 4);
      blocTest<RoutineBloc, RoutineState>(
        'emits new state with updated endTime.',
        build: buildBloc,
        act: (bloc) => bloc.add(RoutineEndTimeChanged(endTime)),
        expect: () =>
            <RoutineState>[fakeInitialState.copyWith(endTime: endTime)],
      );
    });

    group('RoutineSaved', () {
      final fakeState = fakeInitialState.copyWith(
        name: 'new-name',
        day: 7,
        startTime: DateTime(1970, 1, 1, 11),
        endTime: DateTime(1970, 1, 1, 4),
      );

      final fakeRoutine = fakeState.initialRoutine.copyWith(
        name: fakeState.name,
        day: fakeState.day,
        startTime: fakeState.startTime,
        endTime: fakeState.endTime,
      );

      blocTest<RoutineBloc, RoutineState>(
        'attempts to save updated routine.',
        setUp: () {
          when(() => routinesRepository.saveRoutine(fakeRoutine))
              .thenAnswer((_) => Future.value(fakeRoutine));
        },
        build: buildBloc,
        seed: () => fakeState,
        act: (bloc) => bloc.add(const RoutineSaved()),
        expect: () => <RoutineState>[
          fakeState.copyWith(status: RoutineStatus.loading),
          fakeState.copyWith(
            status: RoutineStatus.success,
            initialRoutine: fakeRoutine,
          ),
        ],
        verify: (bloc) {
          verify(() => routinesRepository.saveRoutine(fakeRoutine)).called(1);
        },
      );

      blocTest<RoutineBloc, RoutineState>(
        'emits new state with error if save routine fails.',
        setUp: () {
          when(() => routinesRepository.saveRoutine(fakeRoutine))
              .thenThrow(Exception('opps'));
        },
        build: buildBloc,
        seed: () => fakeState,
        act: (bloc) => bloc.add(const RoutineSaved()),
        expect: () => <RoutineState>[
          fakeState.copyWith(status: RoutineStatus.loading),
          fakeState.copyWith(
            status: RoutineStatus.failure,
            errorMessage: 'error: activity could not be saved',
          ),
        ],
      );
    });

    group('RoutineDeleted', () {
      final fakeRoutine = fakeInitialRoutine.copyWith(id: 1);
      final fakeState = fakeInitialState.copyWith(initialRoutine: fakeRoutine);

      blocTest<RoutineBloc, RoutineState>(
        "not attempts to delete routine if initial routine's id is null",
        build: buildBloc,
        act: (bloc) => bloc.add(const RoutineDeleted()),
        expect: () => const <RoutineState>[],
        verify: (bloc) {
          verifyNever(() => routinesRepository.deleteRoutine(any()));
        },
      );

      blocTest<RoutineBloc, RoutineState>(
        "attempts to delete routine if initial routine's id is non-null",
        setUp: () {
          when(() => routinesRepository.deleteRoutine(1))
              .thenAnswer((_) async {});
        },
        build: buildBloc,
        seed: () => fakeState,
        act: (bloc) => bloc.add(const RoutineDeleted()),
        expect: () => <RoutineState>[
          fakeState.copyWith(status: RoutineStatus.loading),
          fakeState.copyWith(status: RoutineStatus.success),
        ],
        verify: (bloc) {
          verify(() => routinesRepository.deleteRoutine(1)).called(1);
        },
      );

      blocTest<RoutineBloc, RoutineState>(
        'emits new state with error if delete routine fails',
        setUp: () {
          when(() => routinesRepository.deleteRoutine(1))
              .thenThrow(Exception('ops'));
        },
        build: buildBloc,
        seed: () => fakeState,
        act: (bloc) => bloc.add(const RoutineDeleted()),
        expect: () => <RoutineState>[
          fakeState.copyWith(status: RoutineStatus.loading),
          fakeState.copyWith(
            status: RoutineStatus.failure,
            errorMessage: 'error: activity could not be deleted',
          ),
        ],
      );
    });
  });
}
