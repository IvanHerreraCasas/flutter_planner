import 'package:reminders_api/reminders_api.dart';

/// {@template reminders_api}
/// The interface for an API to interact with reminders.
/// {@endtemplate}
abstract class RemindersApi {
  /// {@macro reminders_api}
  const RemindersApi();

  /// true if app has permission and platform is android or ios.
  bool get isAllowed;

  /// Saves a [reminder]
  ///
  /// If a [reminder] with the same id exists, it will be replaced.
  Future<void> saveReminder({required Reminder reminder});

  /// Delete a reminder with the given id
  Future<void> deleteReminder({required int id});

  /// Takes a list of ids and check if there exist and reminder for each id
  /// returns a list of boolean values (true==exists)
  Future<List<bool>> checkReminders({required List<int> ids});
}
