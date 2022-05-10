import 'package:routines_api/routines_api.dart';

/// {@template routines_repository}
/// A repository that handles routine related requests.
/// {@endtemplate}
class RoutinesRepository {
  /// {@macro routines_repository}
  const RoutinesRepository({required RoutinesApi routinesApi})
      : _routinesApi = routinesApi;

  final RoutinesApi _routinesApi;

  /// Returns the user's routines
  Future<List<Routine>> fetchRoutines() => _routinesApi.fetchRoutines();

  /// Provides a [Stream] of the routines.
  Stream<List<Routine>> streamRoutines() => _routinesApi.streamRoutines();

  /// Saves an [routine]
  ///
  /// If an [routine] with the same id exists, it will be replaced.
  Future<Routine> saveRoutine(Routine routine) =>
      _routinesApi.saveRoutine(routine);

  /// Deletes the routine with the given id
  Future<void> deleteRoutine(int id) => _routinesApi.deleteRoutine(id);

  /// Dispose the stream controller if exists one
  Future<void> dispose() => _routinesApi.dispose();
}
