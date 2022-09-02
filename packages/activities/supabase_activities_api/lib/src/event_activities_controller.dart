// ignore_for_file: public_member_api_docs

import 'package:activities_api/activities_api.dart';
import 'package:rxdart/rxdart.dart';

class EventActivitiesController {
  EventActivitiesController();

  final _streamController = BehaviorSubject<List<Activity>>();

  List<Activity> get eventActivities => _streamController.value;

  Stream<List<Activity>> get stream => _streamController.stream;

  void update(List<Activity> eventActivities) {
    _streamController.add(eventActivities);
  }

  void addEventActivity(Activity eventActivity) {
    if (eventActivity.type != 1) return;
    final _eventActivities = [...eventActivities, eventActivity];

    _streamController.add(_eventActivities);
  }

  void updateEventActivity(Activity newEventActivity) {
    if (newEventActivity.type != 1) return;
    final _eventActivities = List.of(eventActivities)
      ..removeWhere((activity) => activity.id == newEventActivity.id)
      ..add(newEventActivity);

    _streamController.add(_eventActivities);
  }

  void delete(int id) {
    final _eventActivities = List.of(eventActivities)
      ..removeWhere((activity) => activity.id == id);

    _streamController.add(_eventActivities);
  }
}
