import 'package:activities_api/activities_api.dart';
import 'package:isar/isar.dart';
import 'package:isar_activities_api/src/models/models.dart';

/// {@template isar_activities_api}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class IsarActivitiesApi extends ActivitiesApi {
  /// {@macro isar_activities_api}
  IsarActivitiesApi({required Isar isar})
      : _isar = isar,
        _activitiesCollection = isar.isarActivitys;

  final Isar _isar;
  final IsarCollection<IsarActivity> _activitiesCollection;

  @override
  Future<List<Activity>> fetchActivities({required DateTime date}) async {
    final isarActivities =
        await _activitiesCollection.filter().dateEqualTo(date).findAll();

    return isarActivities
        .map((isarActivity) => isarActivity.toActivity())
        .toList();
  }

  @override
  Stream<List<Activity>> streamActivities({required DateTime date}) async* {
    final isarActivitiesStream = _activitiesCollection
        .filter()
        .dateEqualTo(date)
        .build()
        .watch(initialReturn: true);

    yield* isarActivitiesStream.map(
      (isarActivities) => isarActivities.map((e) => e.toActivity()).toList(),
    );
  }

  @override
  Stream<List<Activity>> streamEvents({
    required DateTime lower,
    required DateTime upper,
  }) async* {
    final isarEventsStream = _activitiesCollection
        .filter()
        .typeEqualTo(1)
        .dateBetween(lower, upper)
        .build()
        .watch(initialReturn: true);

    yield* isarEventsStream.map(
      (isarEvents) => isarEvents.map((e) => e.toActivity()).toList(),
    );
  }

  @override
  Future<Activity> saveActivity(Activity activity) async {
    return _isar.writeTxn<Activity>(() async {
      final id = await _activitiesCollection.put(activity.toIsarModel());

      return activity.copyWith(id: id);
    });
  }

  @override
  Future<void> insertActivities(List<Activity> activities) {
    final isarActivities = activities.map((e) => e.toIsarModel()).toList();
    return _isar.writeTxn<void>(
      () => _activitiesCollection.putAll(isarActivities),
    );
  }

  @override
  Future<void> deleteActivity(int id) {
    return _isar.writeTxn<void>(() => _activitiesCollection.delete(id));
  }

  @override
  Future<void> dispose() async {}
}
