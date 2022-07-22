import 'package:equatable/equatable.dart';

/// {@template task}
/// A model for the user's tasks
/// {@endtemplate}
class Task extends Equatable {
  /// {@macro task}
  Task({
    this.id,
    required this.userID,
    this.title = '',
    required this.date,
    required this.completed,
  }) : assert(
          date.isUtc &&
              date.hour == 0 &&
              date.minute == 0 &&
              date.second == 0 &&
              date.millisecond == 0 &&
              date.microsecond == 0,
          'date must be utc and cannot have time',
        );

  /// Creates an empty task (new)
  Task.empty({required this.userID})
      : id = null,
        title = '',
        date = DateTime.utc(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        ),
        completed = false;

  /// Deserializes the given json map into a [Task].
  factory Task.fromJson(Map<String, dynamic> jsonMap) {
    final date = DateTime.parse(jsonMap['date'] as String);
    return Task(
      id: jsonMap['id'] as int?,
      userID: jsonMap['user_id'] as String,
      title: jsonMap['title'] as String,
      date: DateTime.utc(date.year, date.month, date.day),
      completed: jsonMap['completed'] as bool,
    );
  }

  /// Task's id
  final int? id;

  /// User's id
  final String userID;

  /// Task's title
  final String title;

  /// Task's date
  final DateTime date;

  /// Task's status
  final bool completed;

  /// Returns a copy of this task with the given values updated.
  ///
  /// {@macro activity}
  Task copyWith({
    int? id,
    String? title,
    DateTime? date,
    bool? completed,
  }) {
    return Task(
      id: id ?? this.id,
      userID: userID,
      title: title ?? this.title,
      date: date ?? this.date,
      completed: completed ?? this.completed,
    );
  }

  /// Converts this [Task] into a map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userID,
      'title': title,
      'date': date.toString(),
      'completed': completed,
    };
  }

  @override
  List<Object?> get props => [
        id,
        userID,
        title,
        date,
        completed,
      ];
}
