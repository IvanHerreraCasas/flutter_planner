part of 'activity_bloc.dart';

enum ActivityStatus { initial, loading, success, failure }

class ActivityState extends Equatable {
  ActivityState({
    this.status = ActivityStatus.initial,
    required this.initialActivity,
    this.name = '',
    this.type = 0,
    this.description = '',
    required this.date,
    required this.startTime,
    required this.endTime,
    this.links = const [],
    this.errorMessage = '',
  }) : assert(
          date.isUtc &&
              date.hour == 0 &&
              date.minute == 0 &&
              date.second == 0 &&
              date.millisecond == 0 &&
              date.microsecond == 0,
          'date must be utc and cannot have time',
        );

  final ActivityStatus status;

  final Activity initialActivity;

  final String name;

  final int type;

  final String description;

  final DateTime date;

  final DateTime startTime;

  final DateTime endTime;

  final List<String> links;

  final String errorMessage;

  ActivityState copyWith({
    ActivityStatus? status,
    Activity? initialActivity,
    String? name,
    int? type,
    String? description,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    List<String>? links,
    String? errorMessage,
  }) {
    return ActivityState(
      status: status ?? this.status,
      initialActivity: initialActivity ?? this.initialActivity,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      links: links ?? this.links,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        initialActivity,
        name,
        type,
        description,
        date,
        startTime,
        endTime,
        links,
        errorMessage,
      ];
}
