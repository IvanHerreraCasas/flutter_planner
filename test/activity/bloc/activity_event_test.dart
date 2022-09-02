// ignore_for_file: prefer_const_constructors

import 'package:flutter_planner/activity/activity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActivityEvent', () {
    group('ActivitySaved', () {
      test('supports value equality', () {
        expect(ActivitySaved(), equals(ActivitySaved()));
      });

      test('props are correct', () {
        expect(ActivitySaved().props, equals(<Object?>[]));
      });
    });

    group('ActivityDeleted', () {
      test('supports value equality', () {
        expect(ActivityDeleted(), equals(ActivityDeleted()));
      });

      test('props are correct', () {
        expect(ActivityDeleted().props, equals(<Object?>[]));
      });
    });

    group('ActivityNameChanged', () {
      test('supports value equality', () {
        expect(
          ActivityNameChanged('name'),
          equals(ActivityNameChanged('name')),
        );
      });

      test('props are correct', () {
        expect(ActivityNameChanged('name').props, equals(['name']));
      });
    });

     group('ActivityTypeChanged', () {
      test('supports value equality', () {
        expect(
          ActivityTypeChanged(1),
          equals(ActivityTypeChanged(1)),
        );
      });

      test('props are correct', () {
        expect(ActivityTypeChanged(1).props, equals([1]));
      });
    });

    group('ActivityDescriptionChanged', () {
      test('supports value equality', () {
        expect(
          ActivityDescriptionChanged('desc'),
          equals(ActivityDescriptionChanged('desc')),
        );
      });

      test('props are correct', () {
        expect(ActivityDescriptionChanged('desc').props, equals(['desc']));
      });
    });

    group('ActivityDateChanged', () {
      final fakeDate = DateTime(1970);
      test('supports value equality', () {
        expect(
          ActivityDateChanged(fakeDate),
          equals(ActivityDateChanged(fakeDate)),
        );
      });

      test('props are correct', () {
        expect(ActivityDateChanged(fakeDate).props, equals([fakeDate]));
      });
    });

    group('ActivityStartTimeChanged', () {
      final fakeStartTime = DateTime(1970, 1, 1, 7);
      test('supports value equality', () {
        expect(
          ActivityStartTimeChanged(fakeStartTime),
          equals(ActivityStartTimeChanged(fakeStartTime)),
        );
      });

      test('props are correct', () {
        expect(
          ActivityStartTimeChanged(fakeStartTime).props,
          equals([fakeStartTime]),
        );
      });
    });

    group('ActivityEndTimeChanged', () {
      final fakeEndTime = DateTime(1970, 1, 1, 8);

      test('supports value equality', () {
        expect(
          ActivityEndTimeChanged(fakeEndTime),
          equals(ActivityEndTimeChanged(fakeEndTime)),
        );
      });

      test('props are correct', () {
        expect(
          ActivityEndTimeChanged(fakeEndTime).props,
          equals([fakeEndTime]),
        );
      });
    });

    group('ActivityLinksChanged', () {
      final fakeLinks = ['---'];

      test('supports value equality', () {
        expect(
          ActivityLinksChanged(fakeLinks),
          equals(ActivityLinksChanged(fakeLinks)),
        );
      });

      test('props are correct', () {
        expect(ActivityLinksChanged(fakeLinks).props, equals([fakeLinks]));
      });
    });
  });
}
