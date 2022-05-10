import 'package:authentication_api/authentication_api.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('User', () {
    User createSubject({
      String id = 'id',
      String email = 'email.example.com',
    }) {
      return User(
        id: id,
        email: email,
      );
    }

    test('works properly', () {
      expect(createSubject, returnsNormally);
    });

    test('supports value equality', () {
      expect(createSubject(), equals(createSubject()));
    });

    test('props are correct', () {
      expect(
        createSubject().props,
        equals([
          'id', // id
          'email.example.com', // email
        ]),
      );
    });
  });
}
