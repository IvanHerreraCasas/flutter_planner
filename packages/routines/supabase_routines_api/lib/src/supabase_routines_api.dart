import 'package:routines_api/routines_api.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// {@template supabase_routines_api}
/// A Flutter implementation of the [RoutinesApi] that uses supabase.
/// {@endtemplate}
class SupabaseRoutinesApi extends RoutinesApi {
  /// {@macro supabase_routines_api}
  const SupabaseRoutinesApi({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  @override
  Future<List<Routine>> fetchRoutines() async {
    final res = await _supabaseClient.from('routines').select().execute();

    if (res.hasError) {
      throw Exception(res.error);
    }
    return (res.data as List)
        .cast<Map<String, dynamic>>()
        .map(Routine.fromJson)
        .toList();
  }

  @override
  Stream<List<Routine>> streamRoutines() {
    final res = _supabaseClient.from('routines').stream(['id']).execute();

    return res.map((routines) => routines.map(Routine.fromJson).toList());
  }

  @override
  Future<Routine> saveRoutine(Routine routine) async {
    if (routine.id == null) {
      final res = await _supabaseClient.from('routines').insert(
        [routine.toJson()..remove('id')],
      ).execute();

      if (res.hasError) {
        throw Exception(res.error);
      }
      return Routine.fromJson(
        (res.data as List).cast<Map<String, dynamic>>().first,
      );
    } else {
      final res = await _supabaseClient
          .from('routines')
          .update(
            routine.toJson(),
          )
          .eq('id', routine.id)
          .execute();

      if (res.hasError) {
        throw Exception(res.error);
      }
      return Routine.fromJson(
        (res.data as List).cast<Map<String, dynamic>>().first,
      );
    }
  }

  @override
  Future<void> deleteRoutine(int id) async {
    final res = await _supabaseClient
        .from('routines')
        .delete(returning: ReturningOption.minimal)
        .eq('id', id)
        .execute();

    if (res.hasError) {
      throw Exception(res.error);
    }
  }

  @override
  Future<void> dispose() async {
    final subs = _supabaseClient.getSubscriptions();

    for (final sub in subs) {
      if (sub.topic.startsWith('realtime:public:routines')) {
        await _supabaseClient.removeSubscription(sub);
      }
    }
  }
}
