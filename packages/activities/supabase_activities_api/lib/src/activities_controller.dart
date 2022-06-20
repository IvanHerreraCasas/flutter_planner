// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:activities_api/activities_api.dart';
import 'package:rxdart/rxdart.dart';

class ActivitiesController {
  ActivitiesController();

  final _streamController = BehaviorSubject<List<Activity>>();

  List<Activity> get activities => _streamController.value;

  Stream<List<Activity>> get stream => _streamController.stream;

  void update(List<Activity> activities) {
    _streamController.add(activities);
  }

  void addActivity(Activity activity) {
    final _activities = [..._streamController.value, activity];

    _streamController.add(_activities);
  }

  void addActivities(List<Activity> activities) {
    final _activities = [..._streamController.value, ...activities];

    _streamController.add(_activities);
  }

  void updateActivity(Activity newActivity) {
    final _activities = List.of(_streamController.value)
      ..removeWhere((activity) => activity.id == newActivity.id)
      ..add(newActivity);

    _streamController.add(_activities);
  }

  void delete(int id) {
    final _activities = List.of(_streamController.value)
      ..removeWhere((activity) => activity.id == id);

    _streamController.add(_activities);
  }
}
