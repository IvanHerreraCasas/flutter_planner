import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:reminders_repository/reminders_repository.dart';
import 'package:tasks_repository/tasks_repository.dart';

import '../../helpers/helpers.dart';

class FakeReminder extends Fake implements Reminder {}

void main() {
  group('AppBloc', () {
    late AppBloc appBloc;
    late TasksRepository tasksRepository;
    late RemindersRepository remindersRepository;
    late DateTime utcTodayDate;
    late DateTime utcTomorrowDate;

    late List<Task> mockTodayTasks;
    late List<Task> mockTomorrowTasks;

    final defaultTasksReminderTimes = [
      DateTime(1970, 1, 1, 8),
      DateTime(1970, 1, 1, 12),
      DateTime(1970, 1, 1, 20),
    ];

    final defaultTaskReminderValues = [false, false, false];

    registerFallbackValue(FakeReminder());

    void setMocks() {
      const userID = 'user-id';

      mockTodayTasks = [
        Task(
          userID: userID,
          date: utcTodayDate,
          completed: true,
        ),
        Task(
          userID: userID,
          date: utcTodayDate,
          completed: false,
        ),
        Task(
          userID: userID,
          date: utcTodayDate,
          completed: false,
        ),
      ];

      mockTomorrowTasks = [
        Task(
          userID: userID,
          date: utcTomorrowDate,
          completed: false,
        ),
        Task(
          userID: userID,
          date: utcTomorrowDate,
          completed: false,
        ),
        Task(
          userID: userID,
          date: utcTomorrowDate,
          completed: false,
        ),
      ];
    }

    setUp(() async {
      final currentDateTime = DateTime.now();
      utcTodayDate = DateTime.utc(
        currentDateTime.year,
        currentDateTime.month,
        currentDateTime.day,
      );

      utcTomorrowDate = DateTime.utc(
        currentDateTime.year,
        currentDateTime.month,
        currentDateTime.day + 1,
      );

      tasksRepository = MockTasksRepository();
      remindersRepository = MockRemindersRepository();

      setMocks();

      when(
        () => remindersRepository.deleteReminder(
          id: any<int>(named: 'id'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => remindersRepository.saveReminder(
          reminder: any<Reminder>(named: 'reminder'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => tasksRepository.streamTasks(date: utcTodayDate),
      ).thenAnswer((_) => Stream.value(mockTodayTasks));
      when(
        () => tasksRepository.streamTasks(date: utcTomorrowDate),
      ).thenAnswer((_) => Stream.value(mockTomorrowTasks));

      appBloc = await mockHydratedStorage(
        () => AppBloc(
          tasksRepository: tasksRepository,
          remindersRepository: remindersRepository,
        ),
      );
    });

    group('constructor', () {
      test('works normally', () {
        mockHydratedStorage(
          () => expect(
            () => AppBloc(
              tasksRepository: tasksRepository,
              remindersRepository: remindersRepository,
            ),
            returnsNormally,
          ),
        );
      });

      test('has correct initial state', () {
        mockHydratedStorage(
          () => expect(
            AppBloc(
              tasksRepository: tasksRepository,
              remindersRepository: remindersRepository,
            ).state,
            equals(const AppState()),
          ),
        );
      });

      test('subscribe to today and tomorrow tasks stram', () {
        mockHydratedStorage(
          () => AppBloc(
            tasksRepository: tasksRepository,
            remindersRepository: remindersRepository,
          ),
        );

        verify(() => tasksRepository.streamTasks(date: utcTodayDate));
        verify(() => tasksRepository.streamTasks(date: utcTomorrowDate));
      });
    });

    group('RouteChanged', () {
      blocTest<AppBloc, AppState>(
        'emits new state with updated route',
        build: () => appBloc,
        act: (bloc) => bloc.add(const AppRouteChanged('/home')),
        expect: () => const <AppState>[
          AppState(route: '/home'),
        ],
      );
    });

    group('ThemeModeChanged', () {
      blocTest<AppBloc, AppState>(
        'emits new state with updated themeModeIndex.',
        build: () => appBloc,
        act: (bloc) => bloc.add(const AppThemeModeChanged(1)),
        expect: () => const <AppState>[
          AppState(themeModeIndex: 1),
        ],
      );
    });

    group('SettingsIndexChanged', () {
      blocTest<AppBloc, AppState>(
        'emits new state with updated settingsIndex.',
        build: () => appBloc,
        act: (bloc) => bloc.add(const AppSettingsIndexChanged(1)),
        expect: () => const <AppState>[
          AppState(settingsIndex: 1),
        ],
      );
    });

    group('TimelineStartHourChanged', () {
      blocTest<AppBloc, AppState>(
        'emits new state with updated settingsIndex.',
        build: () => appBloc,
        act: (bloc) => bloc.add(const AppTimelineStartHourChanged(8)),
        expect: () => const <AppState>[
          AppState(timelineStartHour: 8),
        ],
      );
    });

    group('TimelineEndHourChanged', () {
      blocTest<AppBloc, AppState>(
        'emits new state with updated settingsIndex.',
        build: () => appBloc,
        act: (bloc) => bloc.add(const AppTimelineEndHourChanged(24)),
        expect: () => const <AppState>[
          AppState(timelineEndHour: 24),
        ],
      );
    });

    group('TasksRemindersAllowed', () {
      blocTest<AppBloc, AppState>(
        'emits new state with default reminder times and values.',
        build: () => appBloc,
        act: (bloc) => bloc.add(const AppTasksRemindersAllowed()),
        expect: () => <AppState>[
          AppState(
            tasksReminderTimes: defaultTasksReminderTimes,
            tasksReminderValues: defaultTaskReminderValues,
          ),
        ],
      );
    });

    group('TasksRemindersDisabled', () {
      blocTest<AppBloc, AppState>(
        'emits new state with empty reminder times and values lists '
        'and attempts to delete all reminders.',
        build: () => appBloc,
        seed: () => AppState(
          tasksReminderTimes: defaultTasksReminderTimes,
          tasksReminderValues: defaultTaskReminderValues,
        ),
        act: (bloc) => bloc.add(const AppTasksRemindersDisabled()),
        expect: () => const <AppState>[
          AppState(),
        ],
        verify: (bloc) {
          verify(
            () => remindersRepository.deleteReminder(id: 0),
          ).called(1);
          verify(
            () => remindersRepository.deleteReminder(id: 1),
          ).called(1);
          verify(
            () => remindersRepository.deleteReminder(id: 2),
          ).called(1);
          verify(
            () => remindersRepository.deleteReminder(id: 10),
          ).called(1);
          verify(
            () => remindersRepository.deleteReminder(id: 11),
          ).called(1);
          verify(
            () => remindersRepository.deleteReminder(id: 12),
          ).called(1);
        },
      );
    });

    group('TaskReminderValueChanged', () {
      blocTest<AppBloc, AppState>(
        'emits new state with update task reminder value '
        'and attempts to save and delete the reminders.',
        build: () => appBloc,
        seed: () => AppState(
          tasksReminderTimes: defaultTasksReminderTimes,
          tasksReminderValues: defaultTaskReminderValues,
        ),
        act: (bloc) => bloc.add(
          const AppTaskReminderValueChanged(index: 0, value: true),
        ),
        expect: () => <AppState>[
          AppState(
            tasksReminderTimes: defaultTasksReminderTimes,
            tasksReminderValues: const [true, false, false],
          )
        ],
        verify: (bloc) {
          verify(
            () => remindersRepository.saveReminder(
              reminder: Reminder(
                id: 0,
                title: 'Remainig tasks: 2',
                dateTime: DateTime(
                  utcTodayDate.year,
                  utcTodayDate.month,
                  utcTodayDate.day,
                  8,
                ),
              ),
            ),
          );

          verify(
            () => remindersRepository.saveReminder(
              reminder: Reminder(
                id: 10,
                title: 'Remainig tasks: 3',
                dateTime: DateTime(
                  utcTomorrowDate.year,
                  utcTomorrowDate.month,
                  utcTomorrowDate.day,
                  8,
                ),
              ),
            ),
          );

          verify(() => remindersRepository.deleteReminder(id: 1));
          verify(() => remindersRepository.deleteReminder(id: 2));
          verify(() => remindersRepository.deleteReminder(id: 11));
          verify(() => remindersRepository.deleteReminder(id: 12));
        },
      );
    });

    group('TaskReminderTimeChanged', () {
      blocTest<AppBloc, AppState>(
        'emits new state with update task reminder time '
        'and attempts to save and delete the reminders.',
        build: () => appBloc,
        seed: () => AppState(
          tasksReminderTimes: defaultTasksReminderTimes,
          tasksReminderValues: const [false, true, false],
        ),
        act: (bloc) => bloc.add(
          AppTaskReminderTimeChanged(
            index: 1,
            time: DateTime(1970, 1, 1, 10),
          ),
        ),
        expect: () => <AppState>[
          AppState(
            tasksReminderTimes: [
              DateTime(1970, 1, 1, 8),
              DateTime(1970, 1, 1, 10),
              DateTime(1970, 1, 1, 20),
            ],
            tasksReminderValues: const [false, true, false],
          )
        ],
        verify: (bloc) {
          verify(
            () => remindersRepository.saveReminder(
              reminder: Reminder(
                id: 1,
                title: 'Remainig tasks: 2',
                dateTime: DateTime(
                  utcTodayDate.year,
                  utcTodayDate.month,
                  utcTodayDate.day,
                  10,
                ),
              ),
            ),
          );

          verify(
            () => remindersRepository.saveReminder(
              reminder: Reminder(
                id: 11,
                title: 'Remainig tasks: 3',
                dateTime: DateTime(
                  utcTomorrowDate.year,
                  utcTomorrowDate.month,
                  utcTomorrowDate.day,
                  10,
                ),
              ),
            ),
          );

          verify(() => remindersRepository.deleteReminder(id: 0));
          verify(() => remindersRepository.deleteReminder(id: 2));
          verify(() => remindersRepository.deleteReminder(id: 10));
          verify(() => remindersRepository.deleteReminder(id: 12));
        },
      );
    });

    test('fromJson/toJson work properly', () {
      mockHydratedStorage(() {
        final appBloc = AppBloc(
          tasksRepository: tasksRepository,
          remindersRepository: remindersRepository,
        );

        expect(
          appBloc.fromJson(appBloc.toJson(appBloc.state)!),
          equals(appBloc.state),
        );
      });
    });
  });
}
