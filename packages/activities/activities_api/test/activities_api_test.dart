import 'package:activities_api/src/activities_api.dart';
import 'package:test/test.dart';

class TestActivitiesApi extends ActivitiesApi {
  TestActivitiesApi() : super();

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  group('ActivitiesApi', () {
    group('Constructor', () {
      test('can be constructed', () {
        expect(TestActivitiesApi.new, returnsNormally);
      });
    });
  });
}
