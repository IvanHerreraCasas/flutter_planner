// ignore_for_file: prefer_const_constructors

import 'package:flutter_planner/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

class MockAppEvent extends AppEvent {}

void main() {
  group('AppEvent', () {
    group('BaseAppEvent', () {
      test('supports value equality', () {
        expect(MockAppEvent(), equals(MockAppEvent()));
      });

      test('props are correct', () {
        expect(MockAppEvent().props, equals(<Object?>[]));
      });
    });
    group('AppRouteChanged', () {
      test('supports value equality', () {
        expect(AppRouteChanged('/home'), equals(AppRouteChanged('/home')));
      });

      test('props are correct', () {
        expect(AppRouteChanged('/home').props, equals(['/home']));
      });
    });

    group('AppThemeModeChanged', () {
      const index = 1;
      test('supports value equality', () {
        expect(
          AppThemeModeChanged(index),
          equals(AppThemeModeChanged(index)),
        );
      });

      test('props are correct', () {
        expect(AppThemeModeChanged(index).props, equals(<Object?>[index]));
      });
    });

    group('AppSettingsIndexChanged', () {
      const index = 1;

      test('supports value equality', () {
        expect(
          AppSettingsIndexChanged(index),
          equals(AppSettingsIndexChanged(index)),
        );
      });

      test('props are correct', () {
        expect(
          AppSettingsIndexChanged(index).props,
          equals(<Object?>[index]),
        );
      });
    });

    group('AppTimelineStartHourChanged', () {
      const hour = 8;

      test('supports value equality', () {
        expect(
          AppTimelineStartHourChanged(hour),
          equals(AppTimelineStartHourChanged(hour)),
        );
      });

      test('props are correct', () {
        expect(
          AppTimelineStartHourChanged(hour).props,
          equals(<Object?>[hour]),
        );
      });
    });

    group('AppTimelineEndHourChanged', () {
      const hour = 22;

      test('supports value equality', () {
        expect(
          AppTimelineEndHourChanged(hour),
          equals(AppTimelineEndHourChanged(hour)),
        );
      });

      test('props are correct', () {
        expect(
          AppTimelineEndHourChanged(hour).props,
          equals(<Object?>[hour]),
        );
      });
    });

    group('AppTasksRemindersAllowed', () {
      test('supports value equality', () {
        expect(
          AppTasksRemindersAllowed(),
          equals(AppTasksRemindersAllowed()),
        );
      });

      test('props are correct', () {
        expect(AppTasksRemindersAllowed().props, equals(<Object?>[]));
      });
    });

    group('AppTasksRemindersDisabled', () {
      test('supports value equality', () {
        expect(
          AppTasksRemindersDisabled(),
          equals(AppTasksRemindersDisabled()),
        );
      });

      test('props are correct', () {
        expect(AppTasksRemindersDisabled().props, equals(<Object?>[]));
      });
    });

    group('AppTaskReminderValueChanged', () {
      const index = 0;
      const value = true;

      test('supports value equality', () {
        expect(
          AppTaskReminderValueChanged(index: index, value: value),
          equals(AppTaskReminderValueChanged(index: index, value: value)),
        );
      });

      test('props are correct', () {
        expect(
          AppTaskReminderValueChanged(index: index, value: value).props,
          equals(<Object?>[index, value]),
        );
      });
    });

    group('AppTaskReminderTimeChanged', () {
      const index = 0;
      final time = DateTime(1970, 1, 1, 8);

      test('supports value equality', () {
        expect(
          AppTaskReminderTimeChanged(index: index, time: time),
          equals(AppTaskReminderTimeChanged(index: index, time: time)),
        );
      });

      test('props are correct', () {
        expect(
          AppTaskReminderTimeChanged(index: index, time: time).props,
          equals(<Object?>[index, time]),
        );
      });
    });
  });
}
