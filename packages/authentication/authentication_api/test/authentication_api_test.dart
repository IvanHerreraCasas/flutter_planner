// ignore_for_file: prefer_const_constructors
import 'package:authentication_api/authentication_api.dart';
import 'package:test/test.dart';

class TestAuthenticationApi extends AuthenticationApi {
  TestAuthenticationApi() : super();

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  group('AuthenticationApi', () {
    test('can be constructed', () {
      expect(TestAuthenticationApi.new, returnsNormally);
    });
  });
}
