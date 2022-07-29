import 'package:authentication_api/authentication_api.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('User', () {
    User createSubject({
      String id = 'id',
      String name = 'user-name',
      String email = 'email.example.com',
      bool isEditable = true,
    }) {
      return User(
        id: id,
        email: email,
        name: name,
        isEditable: isEditable,
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
          'user-name', // name
          'email.example.com', // email
          true, //isEditable
        ]),
      );
    });
  });
}
