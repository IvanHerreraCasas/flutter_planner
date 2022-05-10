import 'package:routines_api/routines_api.dart';

/// {@template routines_api}
/// The interface for an API that provides access to all routines of the user.
/// {@endtemplate}
abstract class RoutinesApi {
  /// {@macro routines_api}
  const RoutinesApi();

  /// Return the user's routines
  Future<List<Routine>> fetchRoutines();

  /// Provides a [Stream] of the routines
  Stream<List<Routine>> streamRoutines();

  /// Saves an [routine]
  ///
  /// If an [routine] with the same id exists, it will be replaced
  Future<Routine> saveRoutine(Routine routine);

  /// Deletes the routine with the given id
  Future<void> deleteRoutine(int id);

  /// Dispose the stream controller if exists one
  Future<void> dispose();
}
