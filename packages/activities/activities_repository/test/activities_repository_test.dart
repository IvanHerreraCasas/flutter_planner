import 'package:activities_api/activities_api.dart';
import 'package:activities_repository/activities_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockActivitiesApi extends Mock implements ActivitiesApi {}

class FakeActivity extends Fake implements Activity {}

void main() {
  group('ActivitiesRepository', () {
    late ActivitiesApi activitiesApi;

    final fakeDate = DateTime.utc(2022, 04, 19);

    final fakeNewActivity = Activity(
      id: 4,
      userID: 'user_id',
      name: 'activity 4',
      date: fakeDate,
      startTime: DateTime(2022, 04, 19, 20),
      endTime: DateTime(2022, 04, 19, 21),
    );

    final activities = [
      Activity(
        id: 1,
        userID: 'user_id',
        name: 'activity 1',
        date: fakeDate,
        startTime: DateTime.utc(2022, 04, 19, 8),
        endTime: DateTime(2022, 04, 19, 10),
      ),
      Activity(
        id: 2,
        userID: 'user_id',
        name: 'activity 2',
        date: fakeDate,
        startTime: DateTime.utc(2022, 04, 19, 10),
        endTime: DateTime(2022, 04, 19, 11),
      ),
      Activity(
        id: 3,
        userID: 'user_id',
        name: 'activity 3',
        date: DateTime.utc(2022, 04, 20),
        startTime: DateTime(2022, 04, 20, 16),
        endTime: DateTime(2022, 04, 20, 18),
      ),
    ];

    setUpAll(() {
      registerFallbackValue(FakeActivity());
    });

    setUp(() {
      activitiesApi = MockActivitiesApi();
      when(() => activitiesApi.streamActivities(date: fakeDate))
          .thenAnswer((_) => Stream.value(activities));
      when(() => activitiesApi.saveActivity(fakeNewActivity))
          .thenAnswer((_) async {
        return fakeNewActivity;
      });
      when(() => activitiesApi.deleteActivity(any())).thenAnswer((_) async {});
    });

    ActivitiesRepository createSubject() =>
        ActivitiesRepository(activitiesApi: activitiesApi);
    group('constructor', () {
      test('works properly', () {
        expect(createSubject, returnsNormally);
      });
    });

    group('getActivities', () {
      test('makes correct api request', () {
        expect(
          createSubject().streamActivities(date: fakeDate),
          isNot(throwsA(anything)),
        );

        verify(() => activitiesApi.streamActivities(date: fakeDate)).called(1);
      });
    });

    group('saveActivity', () {
      test('makes correct api request', () async {
        final newActivity = Activity(
          id: 4,
          userID: 'user_id',
          name: 'activity 4',
          date: fakeDate,
          startTime: DateTime(2022, 04, 19, 20),
          endTime: DateTime(2022, 04, 19, 21),
        );

        expect(
          await createSubject().saveActivity(newActivity),
          equals(fakeNewActivity),
        );

        verify(() => activitiesApi.saveActivity(newActivity)).called(1);
      });
    });

    group('deleteActivity', () {
      test('makes correct api request', () {
        expect(createSubject().deleteActivity(activities[0].id!), completes);

        verify(() => activitiesApi.deleteActivity(activities[0].id!)).called(1);
      });
    });
  });
}
