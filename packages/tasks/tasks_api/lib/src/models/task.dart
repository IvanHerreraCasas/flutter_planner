import 'package:equatable/equatable.dart';

/// {@template task}
/// A model for the user's tasks
/// {@endtemplate}
class Task extends Equatable {
  /// {@macro task}
  const Task({
    this.id,
    required this.userID,
    this.title = '',
    required this.date,
    required this.completed,
  });

  /// Creates an empty task (new)
  Task.empty({required this.userID})
      : id = null,
        title = '',
        date = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        ),
        completed = false;

  /// Deserializes the given json map into a [Task].
  factory Task.fromJson(Map<String, dynamic> jsonMap) {
    return Task(
      id: jsonMap['id'] as int?,
      userID: jsonMap['user_id'] as String,
      title: jsonMap['title'] as String,
      date: DateTime.parse(jsonMap['date'] as String),
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
