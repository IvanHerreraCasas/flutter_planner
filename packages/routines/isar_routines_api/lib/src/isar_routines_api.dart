import 'package:isar/isar.dart';
import 'package:isar_routines_api/src/models/isar_routine.dart';
import 'package:routines_api/routines_api.dart';

/// {@template isar_routines_api}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class IsarRoutinesApi extends RoutinesApi {
  /// {@macro isar_routines_api}
  IsarRoutinesApi({
    required Isar isar,
  })  : _isar = isar,
        _routinesCollection = isar.isarRoutines;

  final Isar _isar;
  final IsarCollection<IsarRoutine> _routinesCollection;

  @override
  Future<List<Routine>> fetchRoutines() async {
    final isarRoutines = await _routinesCollection.where().findAll();

    return isarRoutines.map((e) => e.toRoutine()).toList();
  }

  @override
  Stream<List<Routine>> streamRoutines() async* {
    final isarRoutinesStream =
        _routinesCollection.where().build().watch(initialReturn: true);

    yield* isarRoutinesStream.map(
      (isarRoutines) => isarRoutines.map((e) => e.toRoutine()).toList(),
    );
  }

  @override
  Future<Routine> saveRoutine(Routine routine) async {
    return _isar.writeTxn<Routine>(() async {
      final id = await _routinesCollection.put(routine.toIsarModel());

      return routine.copyWith(id: id);
    });
  }

  @override
  Future<void> deleteRoutine(int id) {
    return _isar.writeTxn(() => _routinesCollection.delete(id));
  }

  @override
  Future<void> dispose() async {}
}
