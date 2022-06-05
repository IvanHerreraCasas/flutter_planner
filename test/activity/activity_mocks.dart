import 'package:activities_api/activities_api.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_planner/activity/activity.dart';

class MockActivityBloc extends MockBloc<ActivityEvent, ActivityState>
    implements ActivityBloc {}

final mockActivity = Activity(
  userID: 'user_id',
  name: 'name',
  description: 'description',
  date: DateTime(2022),
  startTime: DateTime(1970, 1, 1, 7),
  endTime: DateTime(1970, 1, 1, 8),
);

final mockActivityState = ActivityState(
  initialActivity: mockActivity,
  name: mockActivity.name,
  description: mockActivity.description,
  date: mockActivity.date,
  startTime: mockActivity.startTime,
  endTime: mockActivity.endTime,
);
