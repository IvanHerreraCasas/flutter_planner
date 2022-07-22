import 'package:activities_api/activities_api.dart';
import 'package:isar/isar.dart';

part 'isar_activity.g.dart';

// ignore: public_member_api_docs
extension Converting on Activity {
  /// converst the current activity to a isar model
  IsarActivity toIsarModel() {
    return IsarActivity()
      ..id = id
      ..userID = userID
      ..name = name
      ..type = type
      ..date = date
      ..startTime = startTime
      ..endTime = endTime
      ..description = description
      ..links = links
      ..routineID = routineID;
  }
}

@Collection()

/// {@template isar_activity}
/// A model for the user's activities to be displayed in a day timeline.
/// {@endtemplate}
class IsarActivity {
  /// Activity's id
  Id? id = Isar.autoIncrement;

  /// User's id
  late String userID;

  /// Activity's name
  late String name;

  /// Activity's type:
  /// 0: task, 1: event, 2: routine
  late int type;

  /// Activity's date
  late DateTime date;

  /// Activity's start time: hour:minute.
  late DateTime startTime;

  /// Activity's end time: hour:minute.
  /// year, month and day are ignored.
  late DateTime endTime;

  /// Activity's description
  late String description;

  /// Activity's related links
  /// Usage example: meetings.
  late List<String> links;

  /// If type is 2: routine, this is their routine id associated
  ///
  /// Otherwise it will be null
  late int? routineID;

  /// converts the current [IsarActivity] to a simple [Activity]
  Activity toActivity() {
    return Activity(
      id: id,
      userID: userID,
      name: name,
      date: date.toUtc(),
      type: type,
      startTime: startTime,
      endTime: endTime,
      description: description,
      links: links,
      routineID: routineID,
    );
  }
}
