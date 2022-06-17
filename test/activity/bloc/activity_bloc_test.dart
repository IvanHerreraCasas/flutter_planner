import 'package:activities_api/activities_api.dart';
import 'package:activities_repository/activities_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_planner/activity/activity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockActivitiesRepository extends Mock implements ActivitiesRepository {}

class FakeActivity extends Fake implements Activity {}

void main() {
  group('ActivityBloc', () {
    late ActivitiesRepository activitiesRepository;

    final fakeInitialActivity = Activity(
      userID: 'user_id',
      name: 'initial-name',
      description: 'initial-description',
      date: DateTime(1970),
      startTime: DateTime(1970, 1, 1, 7),
      endTime: DateTime(1970, 1, 1, 7),
    );

    final fakeInitialState = ActivityState(
      initialActivity: fakeInitialActivity,
      name: fakeInitialActivity.name,
      description: fakeInitialActivity.description,
      date: fakeInitialActivity.date,
      startTime: fakeInitialActivity.startTime,
      endTime: fakeInitialActivity.endTime,
    );

    setUpAll(() {
      registerFallbackValue(FakeActivity());
    });

    setUp(() {
      activitiesRepository = MockActivitiesRepository();
    });

    ActivityBloc buildBloc() {
      return ActivityBloc(
        activitiesRepository: activitiesRepository,
        initialActivity: fakeInitialActivity,
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

    group('NameChanged', () {
      blocTest<ActivityBloc, ActivityState>(
        'emits new state with updated name',
        build: buildBloc,
        act: (bloc) => bloc.add(const ActivityNameChanged('name')),
        expect: () => <ActivityState>[
          fakeInitialState.copyWith(name: 'name'),
        ],
      );
    });

    group('DescriptionChanged', () {
      blocTest<ActivityBloc, ActivityState>(
        'emits new state with updated description',
        build: buildBloc,
        act: (bloc) =>
            bloc.add(const ActivityDescriptionChanged('description')),
        expect: () => <ActivityState>[
          fakeInitialState.copyWith(description: 'description'),
        ],
      );
    });

    group('DateChanged', () {
      final fakeDate = DateTime(1970);
      blocTest<ActivityBloc, ActivityState>(
        'emits new state with updated date',
        build: buildBloc,
        act: (bloc) => bloc.add(ActivityDateChanged(fakeDate)),
        expect: () =>
            <ActivityState>[fakeInitialState.copyWith(date: fakeDate)],
      );
    });

    group('StartTimeChanged', () {
      final fakeStartTime = DateTime(1970, 1, 1, 10);

      blocTest<ActivityBloc, ActivityState>(
        'emits new state with updated start time',
        build: buildBloc,
        act: (bloc) => bloc.add(ActivityStartTimeChanged(fakeStartTime)),
        expect: () => <ActivityState>[
          fakeInitialState.copyWith(startTime: fakeStartTime),
        ],
      );
    });

    group('EndTimeChanged', () {
      final fakeEndTime = DateTime(1970, 1, 1, 12);

      blocTest<ActivityBloc, ActivityState>(
        'emits new state with updated end time',
        build: buildBloc,
        act: (bloc) => bloc.add(ActivityEndTimeChanged(fakeEndTime)),
        expect: () => <ActivityState>[
          fakeInitialState.copyWith(endTime: fakeEndTime),
        ],
      );
    });

    group('LinksChanged', () {
      final fakeLinks = <String>['1', '2'];

      blocTest<ActivityBloc, ActivityState>(
        'emits new state with update links',
        build: buildBloc,
        act: (bloc) => bloc.add(ActivityLinksChanged(fakeLinks)),
        expect: () => <ActivityState>[
          fakeInitialState.copyWith(links: fakeLinks),
        ],
      );
    });

    group('ActivitySaved', () {
      final fakeState = fakeInitialState.copyWith(
        name: 'name',
        description: 'description',
        date: DateTime(2022),
        startTime: DateTime(2022, 1, 1, 8),
        endTime: DateTime(2022, 1, 1, 10),
        links: ['links'],
      );

      final fakeActivity = fakeState.initialActivity.copyWith(
        name: fakeState.name,
        description: fakeState.description,
        date: fakeState.date,
        startTime: fakeState.startTime,
        endTime: fakeState.endTime,
        links: fakeState.links,
      );

      blocTest<ActivityBloc, ActivityState>(
        'attempts to save updated activity',
        setUp: () {
          when(() => activitiesRepository.saveActivity(fakeActivity))
              .thenAnswer((_) async => fakeActivity);
        },
        build: buildBloc,
        seed: () => fakeState,
        act: (bloc) => bloc.add(const ActivitySaved()),
        expect: () => <ActivityState>[
          fakeState.copyWith(status: ActivityStatus.loading),
          fakeState.copyWith(status: ActivityStatus.success),
        ],
        verify: (bloc) {
          verify(() => activitiesRepository.saveActivity(fakeActivity));
        },
      );

      blocTest<ActivityBloc, ActivityState>(
        'emits new state with error if save activity fails',
        setUp: () {
          when(() => activitiesRepository.saveActivity(fakeActivity))
              .thenThrow(Exception('oops'));
        },
        build: buildBloc,
        seed: () => fakeState,
        act: (bloc) => bloc.add(const ActivitySaved()),
        expect: () => <ActivityState>[
          fakeState.copyWith(status: ActivityStatus.loading),
          fakeState.copyWith(status: ActivityStatus.failure),
        ],
      );
    });

    group('ActivityDeleted', () {
      blocTest<ActivityBloc, ActivityState>(
        "not attempt to delete activity if initial activity's id is null",
        build: buildBloc,
        act: (bloc) => bloc.add(const ActivityDeleted()),
        expect: () => const <ActivityState>[],
        verify: (bloc) {
          verifyNever(() => activitiesRepository.deleteActivity(any()));
        },
      );

      final fakeActivity = Activity(
        id: 1,
        userID: 'user_id',
        date: DateTime(2022),
        startTime: DateTime(2022, 1, 1, 10),
        endTime: DateTime(2022, 1, 1, 12),
      );

      final fakeState =
          fakeInitialState.copyWith(initialActivity: fakeActivity);

      blocTest<ActivityBloc, ActivityState>(
        "attempts to delete activity if initial activity's id is non-null",
        build: buildBloc,
        setUp: () {
          when(() => activitiesRepository.deleteActivity(1))
              .thenAnswer((_) async {});
        },
        seed: () => fakeState,
        act: (bloc) => bloc.add(const ActivityDeleted()),
        expect: () => <ActivityState>[
          fakeState.copyWith(status: ActivityStatus.loading),
          fakeState.copyWith(status: ActivityStatus.success),
        ],
        verify: (bloc) {
          verify(() => activitiesRepository.deleteActivity(1));
        },
      );

      blocTest<ActivityBloc, ActivityState>(
        'emits new state with error if delete activity fails',
        build: buildBloc,
        setUp: () {
          when(() => activitiesRepository.deleteActivity(1))
              .thenThrow(Exception('ooprs'));
        },
        seed: () => fakeState,
        act: (bloc) => bloc.add(const ActivityDeleted()),
        expect: () => <ActivityState>[
          fakeState.copyWith(status: ActivityStatus.loading),
          fakeState.copyWith(status: ActivityStatus.failure),
        ],
      );
    });
  });
}
