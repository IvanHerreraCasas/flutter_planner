// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_planner/settings/settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MyDetailsState', () {
    MyDetailsState createSubject({
      MyDetailsStatus status = MyDetailsStatus.initial,
      String userName = '',
      String email = '',
      String errorMessage = '',
    }) {
      return MyDetailsState(
        status: status,
        userName: userName,
        email: email,
        errorMessage: errorMessage,
      );
    }

    test('supports value equality', () {
      expect(createSubject(), equals(createSubject()));
    });

    test('props are correct', () {
      expect(
        createSubject().props,
        equals(<Object?>[
          MyDetailsStatus.initial,
          '',
          '',
          '',
        ]),
      );
    });

    group('copyWith', () {
      test('return the same object if not arguments are provided', () {
        expect(createSubject().copyWith(), equals(createSubject()));
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(
          createSubject().copyWith(
            status: null,
            userName: null,
            email: null,
            errorMessage: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(
            status: MyDetailsStatus.failure,
            userName: 'user',
            email: 'email',
            errorMessage: 'error',
          ),
          equals(
            createSubject(
              status: MyDetailsStatus.failure,
              userName: 'user',
              email: 'email',
              errorMessage: 'error',
            ),
          ),
        );
      });
    });
  });
}
