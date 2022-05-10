part of 'activity_bloc.dart';

enum ActivityStatus { initial, loading, success, failure }

class ActivityState extends Equatable {
  const ActivityState({
    this.status = ActivityStatus.initial,
    required this.initialActivity,
    this.name = '',
    this.description = '',
    required this.date,
    required this.startTime,
    required this.endTime,
    this.links = const [],
  });

  final ActivityStatus status;

  final Activity initialActivity;

  final String name;

  final String description;

  final DateTime date;

  final DateTime startTime;

  final DateTime endTime;

  final List<String> links;

  ActivityState copyWith({
    ActivityStatus? status,
    Activity? initialActivity,
    String? name,
    String? description,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    List<String>? links,
  }) {
    return ActivityState(
      status: status ?? this.status,
      initialActivity: initialActivity ?? this.initialActivity,
      name: name ?? this.name,
      description: description ?? this.description,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      links: links ?? this.links,
    );
  }

  @override
  List<Object?> get props => [
        status,
        initialActivity,
        name,
        description,
        date,
        startTime,
        endTime,
        links,
      ];
}
