// ignore_for_file: prefer_const_constructors

import 'package:flutter_planner/settings/settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MyDetailsEvent', () {
    group('MyDetailsUserName', () {
      const userName = 'name';
      test('supports value equality', () {
        expect(
          MyDetailsUserNameChanged(userName),
          equals(MyDetailsUserNameChanged(userName)),
        );
      });

      test('props are correct', () {
        expect(
          MyDetailsUserNameChanged(userName).props,
          equals(<Object?>[userName]),
        );
      });
    });

    group('MyDetailsEmailChanged', () {
      const email = 'email';

      test('supports value equality', () {
        expect(
          MyDetailsEmailChanged(email),
          equals(MyDetailsEmailChanged(email)),
        );
      });

      test('props are correct', () {
        expect(
          MyDetailsEmailChanged(email).props,
          equals(<Object?>[email]),
        );
      });
    });

    group('MyDetailsUserNameSaved', () {
      test('supports value equality', () {
        expect(MyDetailsUserNameSaved(), equals(MyDetailsUserNameSaved()));
      });

      test('props are correct', () {
        expect(MyDetailsUserNameSaved().props, equals(<Object?>[]));
      });
    });

    group('MyDetailsEmailSaved', () {
      test('supports value equality', () {
        expect(MyDetailsEmailSaved(), equals(MyDetailsEmailSaved()));
      });

      test('props are correct', () {
        expect(MyDetailsEmailSaved().props, equals(<Object>[]));
      });
    });

    group('MyDetailsSaved', () {
      test('supports value equality', () {
        expect(MyDetailsSaved(), equals(MyDetailsSaved()));
      });

      test('props are correct', () {
        expect(MyDetailsSaved().props, equals(<Object?>[]));
      });
    });
  });
}
