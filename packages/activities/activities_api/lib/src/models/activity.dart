import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

/// {@template activity}
/// A model for the user's activities to be displayed in a day timeline.
/// {@endtemplate}
class Activity extends Equatable {
  /// {@macro activity}
  Activity({
    this.id,
    required this.userID,
    this.name = '',
    this.type = 0,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.description = '',
    this.links = const [],
    this.routineID,
  }) : assert(
          date.isUtc &&
              date.hour == 0 &&
              date.minute == 0 &&
              date.second == 0 &&
              date.millisecond == 0 &&
              date.microsecond == 0,
          'date must be utc and cannot have time',
        );

  /// Deserializes the given json map into an [Activity].
  factory Activity.fromJson(Map<String, dynamic> jsonMap) {
    final date = DateTime.parse(jsonMap['date'] as String);
    return Activity(
      id: jsonMap['id'] as int?,
      userID: jsonMap['user_id'] as String,
      name: jsonMap['name'] as String? ?? '',
      type: jsonMap['type'] as int,
      date: DateTime.utc(date.year, date.month, date.day),
      startTime: DateFormat.Hms().parse(jsonMap['start_time'] as String),
      endTime: DateFormat.Hms().parse(jsonMap['end_time'] as String),
      description: jsonMap['description'] as String? ?? '',
      links: (jsonMap['links'] as List<dynamic>? ?? <String>[]).cast<String>(),
      routineID: jsonMap['routine_id'] as int?,
    );
  }

  /// Activity's id
  final int? id;

  /// User's id
  final String userID;

  /// Activity's name
  final String name;

  /// Activity's type:
  /// 0: task, 1: event, 2: routine
  final int type;

  /// Activity's date
  final DateTime date;

  /// Activity's start time: hour:minute.
  /// year, month and day are ignored.
  final DateTime startTime;

  /// Activity's end time: hour:minute.
  /// year, month and day are ignored.
  final DateTime endTime;

  /// Activity's description
  final String description;

  /// Activity's related links
  /// Usage example: meetings.
  final List<String> links;

  /// If type is 2: routine, this is their routine id associated
  ///
  /// Otherwise it will be null
  final int? routineID;

  /// it is true if start and time hours are 0
  bool get isAllDay =>
      startTime.hour == 0 &&
      startTime.minute == 0 &&
      endTime.hour == 0 &&
      endTime.minute == 0;

  /// Returns a copy of this activity with the given values updated.
  ///
  /// {@macro activity}
  Activity copyWith({
    int? id,
    String? name,
    int? type,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    String? description,
    List<String>? links,
    int? Function()? routineID,
  }) {
    return Activity(
      id: id ?? this.id,
      userID: userID,
      name: name ?? this.name,
      type: type ?? this.type,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      description: description ?? this.description,
      links: links ?? this.links,
      routineID: (routineID != null) ? routineID() : this.routineID,
    );
  }

  /// Convers this [Activity] into a Json map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'user_id': userID,
      'name': name,
      'type': type,
      'date': date.toString(),
      'start_time': startTime.toString(),
      'end_time': endTime.toString(),
      'description': description,
      'links': links,
      'routine_id': routineID,
    };
  }

  @override
  List<Object?> get props => [
        id,
        userID,
        name,
        type,
        date,
        startTime,
        endTime,
        description,
        links,
        routineID,
      ];
}
