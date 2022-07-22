// ignore_for_file: public_member_api_docs

import 'package:isar/isar.dart';
import 'package:tasks_api/tasks_api.dart';

part 'isar_task.g.dart';

extension Converting on Task {
  IsarTask toIsarModel() {
    return IsarTask()
      ..id = id
      ..userID = userID
      ..title = title
      ..date = date
      ..completed = completed;
  }
}

@Collection()
class IsarTask {
  Id? id = Isar.autoIncrement;

  late String userID;

  late String title;

  late DateTime date;

  late bool completed;

  Task toTask() {
    return Task(
      id: id,
      userID: userID,
      title: title,
      date: date.toUtc(),
      completed: completed,
    );
  }
}
