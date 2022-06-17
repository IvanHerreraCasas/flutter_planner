import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_planner/routine/routine.dart';
import 'package:routines_api/routines_api.dart';

class MockRoutineBloc extends MockBloc<RoutineEvent, RoutineState>
    implements RoutineBloc {}

final mockRoutine = Routine(
  userID: 'userID',
  name: 'name',
  day: 1,
  startTime: DateTime(1970, 1, 1, 7),
  endTime: DateTime(1970, 1, 1, 9),
);

final mockRoutineState = RoutineState(
  initialRoutine: mockRoutine,
  day: mockRoutine.day,
  name: mockRoutine.name,
  startTime: mockRoutine.startTime,
  endTime: mockRoutine.endTime,
);
