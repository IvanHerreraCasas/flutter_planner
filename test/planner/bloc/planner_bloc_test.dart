import 'package:activities_api/activities_api.dart';
import 'package:activities_repository/activities_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:routines_repository/routines_repository.dart';
import 'package:table_calendar/table_calendar.dart';

class MockActivitiesRepository extends Mock implements ActivitiesRepository {}

class MockRoutinesRepository extends Mock implements RoutinesRepository {}

void main() {
  group('PlannerBloc', () {
    late ActivitiesRepository activitiesRepository;
    late RoutinesRepository routinesRepository;

    final date = DateTime.utc(2022, 5, 25);

    final mockActivities = [
      Activity(
        userID: 'userID',
        name: 'activity 1',
        date: date,
        startTime: DateTime(1970, 1, 1, 8),
        endTime: DateTime(1970, 1, 1, 10),
      ),
      Activity(
        userID: 'userID',
        name: 'activity 2',
        date: date,
        startTime: DateTime(1970, 1, 1, 11),
        endTime: DateTime(1970, 1, 1, 12),
      ),
    ];

    setUp(() {
      activitiesRepository = MockActivitiesRepository();
      routinesRepository = MockRoutinesRepository();

      when(() => activitiesRepository.dispose())
          .thenAnswer((invocation) async {});
    });

    PlannerBloc buildBloc() {
      return PlannerBloc(
        activitiesRepository: activitiesRepository,
        routinesRepository: routinesRepository,
      );
    }

    group('constructor', () {
      test('works normally', () {
        expect(buildBloc, returnsNormally);
      });

      test('has correct initial state', () {
        expect(buildBloc().state, PlannerState());
      });
    });

    group('PlannerSubscriptionRequested', () {
      blocTest<PlannerBloc, PlannerState>(
        'starts listening to repository streamActivities',
        setUp: () {
          when(() => activitiesRepository.streamActivities(date: date))
              .thenAnswer((_) => Stream.value(mockActivities));
        },
        build: buildBloc,
        seed: () => PlannerState(
          selectedDay: date,
          focusedDay: date,
        ),
        act: (bloc) => bloc.add(const PlannerSubscriptionRequested()),
        verify: (bloc) {
          verify(() => activitiesRepository.streamActivities(date: date))
              .called(1);
        },
      );

      blocTest<PlannerBloc, PlannerState>(
        'emits state with updated activities '
        'when repository strem activities emits new activities',
        setUp: () {
          when(() => activitiesRepository.streamActivities(date: date))
              .thenAnswer((_) => Stream.value(mockActivities));
        },
        build: buildBloc,
        seed: () => PlannerState(
          selectedDay: date,
          focusedDay: date,
        ),
        act: (bloc) => bloc.add(const PlannerSubscriptionRequested()),
        expect: () => <PlannerState>[
          PlannerState(
            selectedDay: date,
            focusedDay: date,
            activities: mockActivities,
          ),
        ],
      );
    });

    group('PlannerActivitiesUpdated', () {
      blocTest<PlannerBloc, PlannerState>(
        'fetch activities from repository',
        setUp: () {
          when(() => activitiesRepository.fetchActivities(date: date))
              .thenAnswer((_) => Future.value(mockActivities));
        },
        build: buildBloc,
        seed: () => PlannerState(selectedDay: date),
        act: (bloc) => bloc.add(const PlannerActivitiesUpdated()),
        verify: (bloc) {
          verify(() => activitiesRepository.fetchActivities(date: date))
              .called(1);
        },
      );

      blocTest<PlannerBloc, PlannerState>(
        'emits state with updated activities '
        'when repository fetch activities return new activities with success',
        setUp: () {
          when(() => activitiesRepository.fetchActivities(date: date))
              .thenAnswer((_) => Future.value(mockActivities));
        },
        build: buildBloc,
        seed: () => PlannerState(selectedDay: date),
        act: (bloc) => bloc.add(const PlannerActivitiesUpdated()),
        expect: () => <PlannerState>[
          PlannerState(
            selectedDay: date,
            activities: mockActivities,
          ),
        ],
      );
    });

    group('PlannerSelectedDayChanged', () {
      blocTest<PlannerBloc, PlannerState>(
        'emits state with updated selectedDay',
        build: buildBloc,
        act: (bloc) => bloc.add(PlannerSelectedDayChanged(date)),
        expect: () => <PlannerState>[
          PlannerState(selectedDay: date),
        ],
      );
    });

    group('PlannerFocusedDayChanged', () {
      blocTest<PlannerBloc, PlannerState>(
        'emits state with updated focusedDay.',
        build: buildBloc,
        act: (bloc) => bloc.add(PlannerFocusedDayChanged(date)),
        expect: () => <PlannerState>[PlannerState(focusedDay: date)],
      );
    });

    group('PlannerCalendarFormatChanged', () {
      const format = CalendarFormat.week;
      blocTest<PlannerBloc, PlannerState>(
        'emits state with updated calendar format.',
        build: buildBloc,
        act: (bloc) => bloc.add(const PlannerCalendarFormatChanged(format)),
        expect: () => <PlannerState>[
          PlannerState(calendarFormat: format),
        ],
      );
    });

    group('PlannerSizeChanged', () {
      const plannerSize = PlannerSize.medium;

      blocTest<PlannerBloc, PlannerState>(
        'emits state with updated size.',
        build: buildBloc,
        act: (bloc) => bloc.add(const PlannerSizeChanged(plannerSize)),
        expect: () => <PlannerState>[
          PlannerState(size: plannerSize),
        ],
      );
    });
  });
}
