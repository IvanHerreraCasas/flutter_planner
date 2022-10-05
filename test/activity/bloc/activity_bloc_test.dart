import 'package:activities_repository/activities_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_planner/activity/activity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:reminders_repository/reminders_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ActivityBloc', () {
    late ActivitiesRepository activitiesRepository;
    late RemindersRepository remindersRepository;

    final fakeInitialActivity = Activity(
      userID: 'user_id',
      name: 'initial-name',
      description: 'initial-description',
      type: 1,
      date: DateTime.utc(2022),
      startTime: DateTime(1970, 1, 1, 7),
      endTime: DateTime(1970, 1, 1, 7),
    );

    final fakeInitialState = ActivityState(
      initialActivity: fakeInitialActivity,
      name: fakeInitialActivity.name,
      type: fakeInitialActivity.type,
      description: fakeInitialActivity.description,
      date: fakeInitialActivity.date,
      startTime: fakeInitialActivity.startTime,
      endTime: fakeInitialActivity.endTime,
    );

    setUp(() {
      activitiesRepository = MockActivitiesRepository();
      remindersRepository = MockRemindersRepository();
    });

    ActivityBloc buildBloc() {
      return ActivityBloc(
        activitiesRepository: activitiesRepository,
        initialActivity: fakeInitialActivity,
        remindersRepository: remindersRepository,
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

    group('RemindersRequested', () {
      // when activity id is 0
      // its reminder ids will be [100,...,119]
      final ids = List.generate(20, (index) => 100 + index);

      // fake reminder values
      final reminderValues = List.generate(20, (index) => index.isEven);
      blocTest<ActivityBloc, ActivityState>(
        'checks the existence of the correspondat activity reminder IDs '
        'when initialActivity id is not null '
        'and emit the values returned by the reminders repository',
        setUp: () {
          when(
            () => remindersRepository.checkReminders(ids: ids),
          ).thenAnswer((_) async => reminderValues);
        },
        build: buildBloc,
        seed: () => ActivityState(
          initialActivity: fakeInitialActivity.copyWith(id: 0),
          date: fakeInitialActivity.date,
          startTime: fakeInitialActivity.startTime,
          endTime: fakeInitialActivity.endTime,
        ),
        act: (bloc) => bloc.add(const ActivityRemindersRequested()),
        expect: () => <ActivityState>[
          ActivityState(
            initialActivity: fakeInitialActivity.copyWith(id: 0),
            date: fakeInitialActivity.date,
            startTime: fakeInitialActivity.startTime,
            endTime: fakeInitialActivity.endTime,
            reminderValues: reminderValues,
          ),
        ],
        verify: (bloc) {
          verify(
            () => remindersRepository.checkReminders(ids: ids),
          ).called(1);
        },
      );

      blocTest<ActivityBloc, ActivityState>(
        'emits a new state with 20 false reminder values.',
        build: buildBloc,
        act: (bloc) => bloc.add(const ActivityRemindersRequested()),
        expect: () => <ActivityState>[
          fakeInitialState.copyWith(
            reminderValues: List.generate(20, (index) => false),
          ),
        ],
      );
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

    group('TypeChanged', () {
      blocTest<ActivityBloc, ActivityState>(
        'emits new state with updated type',
        build: buildBloc,
        act: (bloc) => bloc.add(const ActivityTypeChanged(1)),
        expect: () => <ActivityState>[
          fakeInitialState.copyWith(type: 1),
        ],
      );
    });

    group('AllDayToggled', () {
      blocTest<ActivityBloc, ActivityState>(
        'emits state with true isAllDay prop '
        'when previous state had false isAllDay prop.',
        build: buildBloc,
        seed: () => fakeInitialState.copyWith(isAllDay: false),
        act: (bloc) => bloc.add(const ActivityAllDayToggled()),
        expect: () =>
            <ActivityState>[fakeInitialState.copyWith(isAllDay: true)],
      );

      blocTest<ActivityBloc, ActivityState>(
        'emits state with false isAllDay prop '
        'when previous state had true isAllDay prop.',
        build: buildBloc,
        seed: () => fakeInitialState.copyWith(isAllDay: true),
        act: (bloc) => bloc.add(const ActivityAllDayToggled()),
        expect: () =>
            <ActivityState>[fakeInitialState.copyWith(isAllDay: false)],
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
      final fakeDate = DateTime.utc(1970);
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

    group('ReminderValuesChanged', () {
      final reminderValues = List.generate(20, (index) => false);

      blocTest<ActivityBloc, ActivityState>(
        'emits new state with updated start time',
        build: buildBloc,
        act: (bloc) => bloc.add(ActivityReminderValuesChanged(reminderValues)),
        expect: () => <ActivityState>[
          fakeInitialState.copyWith(
            reminderValues: reminderValues,
          ),
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
      final fakeState = ActivityState(
        initialActivity: fakeInitialActivity,
        name: 'name',
        type: 2,
        description: 'description',
        date: DateTime.utc(2022, 10, 4),
        startTime: DateTime(1970, 1, 1, 8),
        endTime: DateTime(1970, 1, 1, 10),
        links: const ['links'],
      );

      final fakeActivity = Activity(
        userID: fakeInitialActivity.userID,
        name: 'name',
        type: 2,
        description: 'description',
        date: DateTime.utc(2022, 10, 4),
        startTime: DateTime(1970, 1, 1, 8),
        endTime: DateTime(1970, 1, 1, 10),
        links: const ['links'],
      );

      blocTest<ActivityBloc, ActivityState>(
        'attempts to save updated activity and its reminders',
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

      group('save reminders', () {
        late List<bool> reminderValues;
        setUp(() {
          when(
            () => remindersRepository.deleteReminder(id: any<int>(named: 'id')),
          ).thenAnswer((_) async {});
        });
        group('when activity is all day', () {
          setUp(() {
            when(
              () => activitiesRepository.saveActivity(
                fakeActivity.copyWith(
                  startTime: DateTime(1970),
                  endTime: DateTime(1970),
                ),
              ),
            ).thenAnswer((_) async => fakeActivity.copyWith(id: 0));
          });
          blocTest<ActivityBloc, ActivityState>(
            'attempts to save reminder the same day at 8:00 '
            'when first value is true',
            setUp: () {
              reminderValues = List.generate(20, (index) => index == 0);
              when(
                () => remindersRepository.saveReminder(
                  reminder: Reminder(
                    id: 100,
                    title: 'name',
                    dateTime: DateTime(2022, 10, 4, 8),
                    body: 'October 4',
                  ),
                ),
              ).thenAnswer((_) async {});
            },
            build: buildBloc,
            seed: () => fakeState.copyWith(
              isAllDay: true,
              reminderValues: reminderValues,
            ),
            act: (bloc) => bloc.add(const ActivitySaved()),
            verify: (bloc) {
              verify(
                () => remindersRepository.saveReminder(
                  reminder: Reminder(
                    id: 100,
                    title: 'name',
                    dateTime: DateTime(2022, 10, 4, 8),
                    body: 'October 4',
                  ),
                ),
              ).called(1);
            },
          );
          blocTest<ActivityBloc, ActivityState>(
            'attempts to save reminder the day before at 8:00 '
            'when second value is true',
            setUp: () {
              reminderValues = List.generate(20, (index) => index == 1);
              when(
                () => remindersRepository.saveReminder(
                  reminder: Reminder(
                    id: 101,
                    title: 'name',
                    dateTime: DateTime(2022, 10, 3, 8),
                    body: 'October 4',
                  ),
                ),
              ).thenAnswer((_) async {});
            },
            build: buildBloc,
            seed: () => fakeState.copyWith(
              isAllDay: true,
              reminderValues: reminderValues,
            ),
            act: (bloc) => bloc.add(const ActivitySaved()),
            verify: (bloc) {
              verify(
                () => remindersRepository.saveReminder(
                  reminder: Reminder(
                    id: 101,
                    title: 'name',
                    dateTime: DateTime(2022, 10, 3, 8),
                    body: 'October 4',
                  ),
                ),
              ).called(1);
            },
          );
          blocTest<ActivityBloc, ActivityState>(
            'attempts to save reminder 2 days before at 8:00 '
            'when third value is true',
            setUp: () {
              reminderValues = List.generate(20, (index) => index == 2);
              when(
                () => remindersRepository.saveReminder(
                  reminder: Reminder(
                    id: 102,
                    title: 'name',
                    dateTime: DateTime(2022, 10, 2, 8),
                    body: 'October 4',
                  ),
                ),
              ).thenAnswer((_) async {});
            },
            build: buildBloc,
            seed: () => fakeState.copyWith(
              isAllDay: true,
              reminderValues: reminderValues,
            ),
            act: (bloc) => bloc.add(const ActivitySaved()),
            verify: (bloc) {
              verify(
                () => remindersRepository.saveReminder(
                  reminder: Reminder(
                    id: 102,
                    title: 'name',
                    dateTime: DateTime(2022, 10, 2, 8),
                    body: 'October 4',
                  ),
                ),
              ).called(1);
            },
          );
          blocTest<ActivityBloc, ActivityState>(
            'attempts to save reminder 3 days before at 8:00 '
            'when fourth value is true',
            setUp: () {
              reminderValues = List.generate(20, (index) => index == 3);
              when(
                () => remindersRepository.saveReminder(
                  reminder: Reminder(
                    id: 103,
                    title: 'name',
                    dateTime: DateTime(2022, 10, 1, 8),
                    body: 'October 4',
                  ),
                ),
              ).thenAnswer((_) async {});
            },
            build: buildBloc,
            seed: () => fakeState.copyWith(
              isAllDay: true,
              reminderValues: reminderValues,
            ),
            act: (bloc) => bloc.add(const ActivitySaved()),
            verify: (bloc) {
              verify(
                () => remindersRepository.saveReminder(
                  reminder: Reminder(
                    id: 103,
                    title: 'name',
                    dateTime: DateTime(2022, 10, 1, 8),
                    body: 'October 4',
                  ),
                ),
              ).called(1);
            },
          );
          blocTest<ActivityBloc, ActivityState>(
            'attempts to save reminder 7 days before at 8:00 '
            'when fifth value is true',
            setUp: () {
              reminderValues = List.generate(20, (index) => index == 4);
              when(
                () => remindersRepository.saveReminder(
                  reminder: Reminder(
                    id: 104,
                    title: 'name',
                    dateTime: DateTime(2022, 9, 27, 8),
                    body: 'October 4',
                  ),
                ),
              ).thenAnswer((_) async {});
            },
            build: buildBloc,
            seed: () => fakeState.copyWith(
              isAllDay: true,
              reminderValues: reminderValues,
            ),
            act: (bloc) => bloc.add(const ActivitySaved()),
            verify: (bloc) {
              verify(
                () => remindersRepository.saveReminder(
                  reminder: Reminder(
                    id: 104,
                    title: 'name',
                    dateTime: DateTime(2022, 9, 27, 8),
                    body: 'October 4',
                  ),
                ),
              ).called(1);
            },
          );
        });

        group('when activity is not all day', () {
          setUp(() {
            when(
              () => activitiesRepository.saveActivity(fakeActivity),
            ).thenAnswer((_) async => fakeActivity.copyWith(id: 0));
          });

          blocTest<ActivityBloc, ActivityState>(
            'attempts to save reminder the same day and time '
            'when first value is true',
            setUp: () {
              reminderValues = List.generate(20, (index) => index == 0);
              when(
                () => remindersRepository.saveReminder(
                  reminder: Reminder(
                    id: 100,
                    title: 'name',
                    dateTime: DateTime(2022, 10, 4, 8),
                    body: 'October 4 - 08:00',
                  ),
                ),
              ).thenAnswer((_) async {});
            },
            build: buildBloc,
            seed: () => fakeState.copyWith(
              reminderValues: reminderValues,
            ),
            act: (bloc) => bloc.add(const ActivitySaved()),
            verify: (bloc) {
              verify(
                () => remindersRepository.saveReminder(
                  reminder: Reminder(
                    id: 100,
                    title: 'name',
                    dateTime: DateTime(2022, 10, 4, 8),
                    body: 'October 4 - 08:00',
                  ),
                ),
              ).called(1);
            },
          );
          blocTest<ActivityBloc, ActivityState>(
            'attempts to save reminder the same day and five minutes before '
            'when second value is true',
            setUp: () {
              reminderValues = List.generate(20, (index) => index == 1);
              when(
                () => remindersRepository.saveReminder(
                  reminder: Reminder(
                    id: 101,
                    title: 'name',
                    dateTime: DateTime(2022, 10, 4, 7, 55),
                    body: 'October 4 - 08:00',
                  ),
                ),
              ).thenAnswer((_) async {});
            },
            build: buildBloc,
            seed: () => fakeState.copyWith(
              reminderValues: reminderValues,
            ),
            act: (bloc) => bloc.add(const ActivitySaved()),
            verify: (bloc) {
              verify(
                () => remindersRepository.saveReminder(
                  reminder: Reminder(
                    id: 101,
                    title: 'name',
                    dateTime: DateTime(2022, 10, 4, 7, 55),
                    body: 'October 4 - 08:00',
                  ),
                ),
              ).called(1);
            },
          );
          blocTest<ActivityBloc, ActivityState>(
            'attempts to save reminder the same day and 15 minutes before '
            'when third value is true',
            setUp: () {
              reminderValues = List.generate(20, (index) => index == 2);
              when(
                () => remindersRepository.saveReminder(
                  reminder: Reminder(
                    id: 102,
                    title: 'name',
                    dateTime: DateTime(2022, 10, 4, 7, 45),
                    body: 'October 4 - 08:00',
                  ),
                ),
              ).thenAnswer((_) async {});
            },
            build: buildBloc,
            seed: () => fakeState.copyWith(
              reminderValues: reminderValues,
            ),
            act: (bloc) => bloc.add(const ActivitySaved()),
            verify: (bloc) {
              verify(
                () => remindersRepository.saveReminder(
                  reminder: Reminder(
                    id: 102,
                    title: 'name',
                    dateTime: DateTime(2022, 10, 4, 7, 45),
                    body: 'October 4 - 08:00',
                  ),
                ),
              ).called(1);
            },
          );
          blocTest<ActivityBloc, ActivityState>(
            'attempts to save reminder the same day and 30 minutes before '
            'when fourth value is true',
            setUp: () {
              reminderValues = List.generate(20, (index) => index == 3);
              when(
                () => remindersRepository.saveReminder(
                  reminder: Reminder(
                    id: 103,
                    title: 'name',
                    dateTime: DateTime(2022, 10, 4, 7, 30),
                    body: 'October 4 - 08:00',
                  ),
                ),
              ).thenAnswer((_) async {});
            },
            build: buildBloc,
            seed: () => fakeState.copyWith(
              reminderValues: reminderValues,
            ),
            act: (bloc) => bloc.add(const ActivitySaved()),
            verify: (bloc) {
              verify(
                () => remindersRepository.saveReminder(
                  reminder: Reminder(
                    id: 103,
                    title: 'name',
                    dateTime: DateTime(2022, 10, 4, 7, 30),
                    body: 'October 4 - 08:00',
                  ),
                ),
              ).called(1);
            },
          );
          blocTest<ActivityBloc, ActivityState>(
            'attempts to save reminder the same day and 1 hour before '
            'when fifth value is true',
            setUp: () {
              reminderValues = List.generate(20, (index) => index == 4);
              when(
                () => remindersRepository.saveReminder(
                  reminder: Reminder(
                    id: 104,
                    title: 'name',
                    dateTime: DateTime(2022, 10, 4, 7),
                    body: 'October 4 - 08:00',
                  ),
                ),
              ).thenAnswer((_) async {});
            },
            build: buildBloc,
            seed: () => fakeState.copyWith(
              reminderValues: reminderValues,
            ),
            act: (bloc) => bloc.add(const ActivitySaved()),
            verify: (bloc) {
              verify(
                () => remindersRepository.saveReminder(
                  reminder: Reminder(
                    id: 104,
                    title: 'name',
                    dateTime: DateTime(2022, 10, 4, 7),
                    body: 'October 4 - 08:00',
                  ),
                ),
              ).called(1);
            },
          );
          blocTest<ActivityBloc, ActivityState>(
            'attempts to save reminder the same day and 4 hours before '
            'when sixth value is true',
            setUp: () {
              reminderValues = List.generate(20, (index) => index == 5);
              when(
                () => remindersRepository.saveReminder(
                  reminder: Reminder(
                    id: 105,
                    title: 'name',
                    dateTime: DateTime(2022, 10, 4, 4),
                    body: 'October 4 - 08:00',
                  ),
                ),
              ).thenAnswer((_) async {});
            },
            build: buildBloc,
            seed: () => fakeState.copyWith(
              reminderValues: reminderValues,
            ),
            act: (bloc) => bloc.add(const ActivitySaved()),
            verify: (bloc) {
              verify(
                () => remindersRepository.saveReminder(
                  reminder: Reminder(
                    id: 105,
                    title: 'name',
                    dateTime: DateTime(2022, 10, 4, 4),
                    body: 'October 4 - 08:00',
                  ),
                ),
              ).called(1);
            },
          );
          blocTest<ActivityBloc, ActivityState>(
            'attempts to save reminder 1 day before '
            'when Seventh value is true',
            setUp: () {
              reminderValues = List.generate(20, (index) => index == 6);
              when(
                () => remindersRepository.saveReminder(
                  reminder: Reminder(
                    id: 106,
                    title: 'name',
                    dateTime: DateTime(2022, 10, 3, 8),
                    body: 'October 4 - 08:00',
                  ),
                ),
              ).thenAnswer((_) async {});
            },
            build: buildBloc,
            seed: () => fakeState.copyWith(
              reminderValues: reminderValues,
            ),
            act: (bloc) => bloc.add(const ActivitySaved()),
            verify: (bloc) {
              verify(
                () => remindersRepository.saveReminder(
                  reminder: Reminder(
                    id: 106,
                    title: 'name',
                    dateTime: DateTime(2022, 10, 3, 8),
                    body: 'October 4 - 08:00',
                  ),
                ),
              ).called(1);
            },
          );
          blocTest<ActivityBloc, ActivityState>(
            'attempts to save reminder 2 days before '
            'when eigthth value is true',
            setUp: () {
              reminderValues = List.generate(20, (index) => index == 7);
              when(
                () => remindersRepository.saveReminder(
                  reminder: Reminder(
                    id: 107,
                    title: 'name',
                    dateTime: DateTime(2022, 10, 2, 8),
                    body: 'October 4 - 08:00',
                  ),
                ),
              ).thenAnswer((_) async {});
            },
            build: buildBloc,
            seed: () => fakeState.copyWith(
              reminderValues: reminderValues,
            ),
            act: (bloc) => bloc.add(const ActivitySaved()),
            verify: (bloc) {
              verify(
                () => remindersRepository.saveReminder(
                  reminder: Reminder(
                    id: 107,
                    title: 'name',
                    dateTime: DateTime(2022, 10, 2, 8),
                    body: 'October 4 - 08:00',
                  ),
                ),
              ).called(1);
            },
          );
          blocTest<ActivityBloc, ActivityState>(
            'attempts to save reminder 7 days before '
            'when nineth value is true',
            setUp: () {
              reminderValues = List.generate(20, (index) => index == 8);
              when(
                () => remindersRepository.saveReminder(
                  reminder: Reminder(
                    id: 108,
                    title: 'name',
                    dateTime: DateTime(2022, 9, 27, 8),
                    body: 'October 4 - 08:00',
                  ),
                ),
              ).thenAnswer((_) async {});
            },
            build: buildBloc,
            seed: () => fakeState.copyWith(
              reminderValues: reminderValues,
            ),
            act: (bloc) => bloc.add(const ActivitySaved()),
            verify: (bloc) {
              verify(
                () => remindersRepository.saveReminder(
                  reminder: Reminder(
                    id: 108,
                    title: 'name',
                    dateTime: DateTime(2022, 9, 27, 8),
                    body: 'October 4 - 08:00',
                  ),
                ),
              ).called(1);
            },
          );
        });
      });

      blocTest<ActivityBloc, ActivityState>(
        'attempts to save updated activity with '
        'zero start and end time (DateTime(1970)) '
        'when it is all day',
        setUp: () {
          when(
            () => activitiesRepository.saveActivity(
              fakeActivity.copyWith(
                startTime: DateTime(1970),
                endTime: DateTime(1970),
              ),
            ),
          ).thenAnswer((_) async => fakeActivity.copyWith(id: 0));
        },
        build: buildBloc,
        seed: () => fakeState.copyWith(isAllDay: true),
        act: (bloc) => bloc.add(const ActivitySaved()),
        expect: () => <ActivityState>[
          fakeState.copyWith(
            status: ActivityStatus.loading,
            isAllDay: true,
          ),
          fakeState.copyWith(
            status: ActivityStatus.success,
            isAllDay: true,
          ),
        ],
        verify: (bloc) {
          verify(
            () => activitiesRepository.saveActivity(
              fakeActivity.copyWith(
                startTime: DateTime(1970),
                endTime: DateTime(1970),
              ),
            ),
          );
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
          fakeState.copyWith(
            status: ActivityStatus.failure,
            errorMessage: 'error: activity could not be saved',
          ),
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
        date: DateTime.utc(2022),
        startTime: DateTime(2022, 1, 1, 10),
        endTime: DateTime(2022, 1, 1, 12),
      );

      final fakeState =
          fakeInitialState.copyWith(initialActivity: fakeActivity);

      final reminderValues = List.generate(20, (index) => true);

      blocTest<ActivityBloc, ActivityState>(
        "attempts to delete activity if initial activity's id is non-null",
        build: buildBloc,
        setUp: () {
          when(() => activitiesRepository.deleteActivity(1))
              .thenAnswer((_) async {});
          when(
            () => remindersRepository.deleteReminder(id: any<int>(named: 'id')),
          ).thenAnswer((_) async {});
        },
        seed: () => fakeState.copyWith(reminderValues: reminderValues),
        act: (bloc) => bloc.add(const ActivityDeleted()),
        expect: () => <ActivityState>[
          fakeState.copyWith(
            status: ActivityStatus.loading,
            reminderValues: reminderValues,
          ),
          fakeState.copyWith(
            status: ActivityStatus.success,
            reminderValues: reminderValues,
          ),
        ],
        verify: (bloc) {
          verify(() => activitiesRepository.deleteActivity(1));
          verify(() => remindersRepository.deleteReminder(id: 121));
          verify(() => remindersRepository.deleteReminder(id: 139));
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
          fakeState.copyWith(
            status: ActivityStatus.failure,
            errorMessage: 'error: activity could not be deleted',
          ),
        ],
      );
    });
  });
}
