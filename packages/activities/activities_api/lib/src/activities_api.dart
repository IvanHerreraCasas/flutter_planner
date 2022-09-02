import 'package:activities_api/activities_api.dart';

/// {@template activities_api}
/// The interface for an API that provides access to a list of activities.
/// {@endtemplate}
abstract class ActivitiesApi {
  /// {@macro activities_api}
  const ActivitiesApi();

  /// Return the activities from a [date].
  Future<List<Activity>> fetchActivities({required DateTime date});

  /// Provides a [Stream] of activities from a [date]
  Stream<List<Activity>> streamActivities({required DateTime date});

  /// Provides a [Stream] of event activities
  /// between the given range [lower], [upper]
  Stream<List<Activity>> streamEvents({
    required DateTime lower,
    required DateTime upper,
  });

  /// Saves an [activity]
  ///
  /// If an [activity] with the same id exists, it will be replaced
  Future<Activity> saveActivity(Activity activity);

  /// Insert the given [activities]
  ///
  /// Used to insert the routines (converted to activities) of a day.
  Future<void> insertActivities(List<Activity> activities);

  /// Deletes the activity with the given [id]
  Future<void> deleteActivity(int id);

  /// Dispose the stream controller if exists one
  Future<void> dispose();
}
