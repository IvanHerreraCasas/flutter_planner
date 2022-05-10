part of 'activity_bloc.dart';

abstract class ActivityEvent extends Equatable {
  const ActivityEvent();

  @override
  List<Object?> get props => [];
}

class ActivitySaved extends ActivityEvent {
  const ActivitySaved();
}

class ActivityDeleted extends ActivityEvent {
  const ActivityDeleted();
}

class ActivityNameChanged extends ActivityEvent {
  const ActivityNameChanged(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

class ActivityDescriptionChanged extends ActivityEvent {
  const ActivityDescriptionChanged(this.description);

  final String description;

  @override
  List<Object?> get props => [description];
}

class ActivityDateChanged extends ActivityEvent {
  const ActivityDateChanged(this.date);

  final DateTime date;

  @override
  List<Object?> get props => [date];
}

class ActivityStartTimeChanged extends ActivityEvent {
  const ActivityStartTimeChanged(this.startTime);

  final DateTime startTime;

  @override
  List<Object?> get props => [startTime];
}

class ActivityEndTimeChanged extends ActivityEvent {
  const ActivityEndTimeChanged(this.endTime);

  final DateTime endTime;

  @override
  List<Object?> get props => [endTime];
}

class ActivityLinksChanged extends ActivityEvent {
  const ActivityLinksChanged(this.links);

  final List<String> links;

  @override
  List<Object?> get props => [links];
}
