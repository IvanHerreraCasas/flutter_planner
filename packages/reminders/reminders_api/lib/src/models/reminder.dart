/// {@template reminder}
/// A model for reminders
/// {@endtemplate}
class Reminder {
  /// {@macro reminder}
  const Reminder({
    required this.id,
    required this.title,
    required this.dateTime,
    this.body,
  });

  /// reminder's id
  final int id;

  /// reminder's title
  final String title;

  /// reminder's dateTime
  final DateTime dateTime;

  /// reminder's body
  final String? body;

}
