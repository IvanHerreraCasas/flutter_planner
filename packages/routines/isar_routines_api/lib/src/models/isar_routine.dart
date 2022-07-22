// ignore_for_file: public_member_api_docs

import 'package:isar/isar.dart';
import 'package:routines_api/routines_api.dart';

part 'isar_routine.g.dart';

extension Converting on Routine {
  IsarRoutine toIsarModel() {
    return IsarRoutine()
      ..id = id
      ..userID = userID
      ..name = name
      ..day = day
      ..startTime = startTime
      ..endTime = endTime;
  }
}

@Collection()
class IsarRoutine {
  Id? id = Isar.autoIncrement;

  late String userID;

  late String name;

  late int day;

  late DateTime startTime;

  late DateTime endTime;

  Routine toRoutine() {
    return Routine(
      id: id,
      userID: userID,
      name: name,
      day: day,
      startTime: startTime,
      endTime: endTime,
    );
  }
}
