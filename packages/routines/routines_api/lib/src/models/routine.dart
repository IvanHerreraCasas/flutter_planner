import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

/// {@template routine}
/// A model for the user's routines to be displayed in a timetable.
/// {@endtemplate}
class Routine extends Equatable {
  /// {@macro routine}
  const Routine({
    this.id,
    required this.userID,
    required this.name,
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  /// Deserializes the given json map into a [Routine].
  factory Routine.fromJson(Map<String, dynamic> jsonMap) {
    return Routine(
      id: jsonMap['id'] as int?,
      userID: jsonMap['user_id'] as String,
      name: jsonMap['name'] as String,
      day: jsonMap['day'] as int,
      startTime: DateFormat.Hms().parse(jsonMap['start_time'] as String),
      endTime: DateFormat.Hms().parse(jsonMap['end_time'] as String),
    );
  }

  /// Routine's id.
  final int? id;

  /// User's id.
  final String userID;

  /// Routine's name.
  final String name;

  /// Rotines's day.
  /// 1: Monday.
  /// ...
  /// 7: Sunday.
  final int day;

  /// Routine's start time.
  final DateTime startTime;

  /// Routine's end time.
  final DateTime endTime;

  /// Returns a copy of this [Routine] with the given values updated.
  ///
  /// {@macro routine}
  Routine copyWith({
    int? id,
    String? userID,
    String? name,
    int? day,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return Routine(
      id: id ?? this.id,
      userID: userID ?? this.userID,
      name: name ?? this.name,
      day: day ?? this.day,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  /// Convers this [Routine] into a Json map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'user_id': userID,
      'name': name,
      'day': day,
      'start_time': startTime.toString(),
      'end_time': endTime.toString(),
    };
  }

  @override
  List<Object?> get props {
    return [
      id,
      userID,
      name,
      day,
      startTime,
      endTime,
    ];
  }
}
