import 'package:activities_api/activities_api.dart';

/// {@template activities_repository}
/// A repository that handles activity related requests.
/// {@endtemplate}
class ActivitiesRepository {
  /// {@macro activities_repository}
  const ActivitiesRepository({
    required ActivitiesApi activitiesApi,
  }) : _activitiesApi = activitiesApi;

  final ActivitiesApi _activitiesApi;

  /// Return the activities from a [date].
  Future<List<Activity>> fetchActivities({required DateTime date}) =>
      _activitiesApi.fetchActivities(date: date);

  /// Provides a [Stream] of activities from a [date]
  Stream<List<Activity>> streamActivities({required DateTime date}) =>
      _activitiesApi.streamActivities(date: date).asBroadcastStream();

  /// Provides a [Stream] of event activities
  /// between the given range [lower], [upper]
  Stream<List<Activity>> streamEvents({
    required DateTime lower,
    required DateTime upper,
  }) =>
      _activitiesApi
          .streamEvents(lower: lower, upper: upper)
          .asBroadcastStream();

  /// Saves an [activity]
  ///
  /// If an [activity] with the same id exists, it will be replaced
  Future<Activity> saveActivity(Activity activity) =>
      _activitiesApi.saveActivity(activity);

  /// Insert the given [activities]
  ///
  /// Used to insert the routines (converted to activities) of a day.
  Future<void> insertActivities(List<Activity> activities) =>
      _activitiesApi.insertActivities(activities);

  /// Deletes the activity with the given id
  Future<void> deleteActivity(int id) => _activitiesApi.deleteActivity(id);

  /// Dispose the stream controller if exists one
  Future<void> dispose() => _activitiesApi.dispose();
}
