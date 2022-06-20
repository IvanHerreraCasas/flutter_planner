import 'dart:async';

import 'package:activities_api/activities_api.dart';
import 'package:intl/intl.dart';
import 'package:supabase_activities_api/src/activities_controller.dart';
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

  final _activitiesController = ActivitiesController();
  DateTime? _date;

  Future<void> _updateData({required DateTime date}) async {
    final res = await _supabaseClient
        .from('activities')
        .select()
        .eq('date', DateFormat('MM/dd/yyyy').format(date))
        .execute();

    if (res.hasError) throw Exception(res.error);

    final activities = (res.data as List)
        .cast<Map<String, dynamic>>()
        .map(Activity.fromJson)
        .toList();

    _date = date;
    _activitiesController.update(activities);
  }

  @override
  Future<List<Activity>> fetchActivities({required DateTime date}) async {
    if (_date != date) {
      await _updateData(date: date);
    }

    return _activitiesController.activities;
  }

  @override
  Stream<List<Activity>> streamActivities({required DateTime date}) async* {
    if (_date != date) {
      await _updateData(date: date);
    }

    yield* _activitiesController.stream;
  }

  @override
  Future<Activity> saveActivity(Activity activity) async {
    late Activity _activity;
    if (activity.id == null) {
      final res = await _supabaseClient.from('activities').insert(
        [activity.toJson()..remove('id')],
      ).execute();

      if (res.hasError) throw Exception(res.error);

      _activity = Activity.fromJson(
        (res.data as List).cast<Map<String, dynamic>>().first,
      );

      _activitiesController.addActivity(_activity);
    } else {
      final res = await _supabaseClient
          .from('activities')
          .update(activity.toJson())
          .eq('id', activity.id)
          .execute();

      if (res.hasError) throw Exception(res.error);

      _activity = Activity.fromJson(
        (res.data as List).cast<Map<String, dynamic>>().first,
      );

      _activitiesController.updateActivity(_activity);
    }

    return _activity;
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

    if (res.hasError) throw Exception(res.error);

    _activitiesController.addActivities(
      (res.data as List)
          .cast<Map<String, dynamic>>()
          .map(Activity.fromJson)
          .toList(),
    );
  }

  @override
  Future<void> deleteActivity(int id) async {
    final res = await _supabaseClient
        .from('activities')
        .delete()
        .eq('id', id)
        .execute();

    if (res.hasError) throw Exception(res.error);

    _activitiesController.delete(id);
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
