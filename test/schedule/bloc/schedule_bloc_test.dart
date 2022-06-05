import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_planner/schedule/schedule.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:routines_api/routines_api.dart';
import 'package:routines_repository/routines_repository.dart';

class MockRoutinesRepository extends Mock implements RoutinesRepository {}

void main() {
  group('ScheduleBloc', () {
    late RoutinesRepository routinesRepository;

    final fakeRoutine = Routine(
      id: 1,
      userID: 'userID',
      name: 'name',
      day: 1,
      startTime: DateTime(1970, 1, 1, 7),
      endTime: DateTime(1970, 1, 1, 10),
    );

    setUp(() {
      routinesRepository = MockRoutinesRepository();
      when(() => routinesRepository.dispose())
          .thenAnswer((invocation) async {});
    });

    ScheduleBloc buildBloc() {
      return ScheduleBloc(routinesRepository: routinesRepository);
    }

    group('constructor', () {
      test('works normally', () {
        expect(buildBloc, returnsNormally);
      });

      test('has correct initial state', () {
        expect(buildBloc().state, const ScheduleState());
      });
    });

    group('ScheduleSubscriptionRequested', () {
      blocTest<ScheduleBloc, ScheduleState>(
        'starts listening to repository streamRoutines',
        setUp: () {
          when(() => routinesRepository.streamRoutines())
              .thenAnswer((_) => Stream.value([fakeRoutine]));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const ScheduleSubscriptionRequested()),
        verify: (bloc) {
          verify(() => routinesRepository.streamRoutines()).called(1);
        },
      );

      blocTest<ScheduleBloc, ScheduleState>(
        'emits state with updated routines '
        'when repository strem routines emits new activities',
        setUp: () {
          when(() => routinesRepository.streamRoutines())
              .thenAnswer((_) => Stream.value([fakeRoutine]));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const ScheduleSubscriptionRequested()),
        expect: () => <ScheduleState>[
          ScheduleState(routines: [fakeRoutine]),
        ],
      );
    });

    group('ScheduleRoutineChanged', () {
      blocTest<ScheduleBloc, ScheduleState>(
        'attempts to save updated routine',
        setUp: () {
          when(() => routinesRepository.saveRoutine(fakeRoutine))
              .thenAnswer((_) => Future.value(fakeRoutine));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(ScheduleRoutineChanged(fakeRoutine)),
        verify: (bloc) {
          verify(() => routinesRepository.saveRoutine(fakeRoutine)).called(1);
        },
      );

      blocTest<ScheduleBloc, ScheduleState>(
        'if saved routine is the same as selected one, update it',
        setUp: () {
          when(() => routinesRepository.saveRoutine(fakeRoutine))
              .thenAnswer((_) => Future.value(fakeRoutine));
        },
        build: buildBloc,
        // selected routine must have the same id, but different object.
        seed: () => ScheduleState(
          selectedRoutine: fakeRoutine.copyWith(
            startTime: DateTime(1970, 1, 1, 8),
          ),
        ),
        act: (bloc) => bloc.add(
          ScheduleRoutineChanged(fakeRoutine),
        ),
        expect: () => <ScheduleState>[
          ScheduleState(selectedRoutine: fakeRoutine),
        ],
      );
    });

    group('ScheduleSelectedRoutineChanged', () {
      blocTest<ScheduleBloc, ScheduleState>(
        'emits new state with updated selectedRoutine.',
        build: buildBloc,
        act: (bloc) => bloc.add(ScheduleSelectedRoutineChanged(fakeRoutine)),
        expect: () => <ScheduleState>[
          ScheduleState(selectedRoutine: fakeRoutine),
        ],
      );
    });
  });
}