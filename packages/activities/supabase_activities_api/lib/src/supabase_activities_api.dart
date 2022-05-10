import 'dart:async';

import 'package:activities_api/activities_api.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// {@template supabase_activities_api}
/// A Flutter implementation of the [ActivitiesApi] that uses supabase.
/// {@endtemplate}
class SupabaseActivitiesApi extends ActivitiesApi {
  /// {@macro supabase_activities_api}
  SupabaseActivitiesApi({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  @override
  Future<List<Activity>> fetchActivities({required DateTime date}) async {
    final res = await _supabaseClient
        .from('activities')
        .select()
        .eq('date', DateFormat('MM/dd/yyyy').format(date))
        .execute();
    if (res.hasError) {
      throw Exception(res.error);
    }
    return (res.data as List)
        .cast<Map<String, dynamic>>()
        .map(Activity.fromJson)
        .toList();
  }

  @override
  Stream<List<Activity>> streamActivities({required DateTime date}) {
    final res = _supabaseClient
        .from('activities:date=eq.${DateFormat('MM/dd/yyyy').format(date)}')
        .stream(['id']).execute();

    return res.map((activities) => activities.map(Activity.fromJson).toList());
  }

  @override
  Future<Activity> saveActivity(Activity activity) async {
    if (activity.id == null) {
      final res = await _supabaseClient.from('activities').insert(
        [activity.toJson()..remove('id')],
      ).execute();
      if (res.hasError) {
        throw Exception(res.error);
      }
      return Activity.fromJson(
        (res.data as List).cast<Map<String, dynamic>>().first,
      );
    } else {
      final res = await _supabaseClient
          .from('activities')
          .update(activity.toJson())
          .eq('id', activity.id)
          .execute();
      if (res.hasError) {
        throw Exception(res.error);
      }
      return Activity.fromJson(
        (res.data as List).cast<Map<String, dynamic>>().first,
      );
    }
  }

  @override
  Future<void> insertActivities(List<Activity> activities) async {
    final res = await _supabaseClient
        .from('activities')
        .insert(
          activities
              .map((activity) => activity.toJson()..remove('id'))
              .toList(),
        )
        .execute();

    if (res.hasError) {
      throw Exception(res.error);
    }
  }

  @override
  Future<void> deleteActivity(int id) async {
    final res = await _supabaseClient
        .from('activities')
        .delete()
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
      if (sub.topic.startsWith('realtime:public:activities')) {
        await _supabaseClient.removeSubscription(sub);
      }
    }
  }
}
