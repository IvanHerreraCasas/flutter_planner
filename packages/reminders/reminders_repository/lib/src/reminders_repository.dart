import 'package:reminders_api/reminders_api.dart';

/// {@template reminders_repository}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class RemindersRepository {
  /// {@macro reminders_repository}
  const RemindersRepository({required RemindersApi remindersApi})
      : _remindersApi = remindersApi;

  final RemindersApi _remindersApi;

  /// true if app has permission and platform is android or ios.
  bool get areAllowed => _remindersApi.isAllowed;

  /// Saves a [reminder]
  ///
  /// If a [reminder] with the same id exists, it will be replaced.
  Future<void> saveReminder({required Reminder reminder}) =>
      _remindersApi.saveReminder(reminder: reminder);

  /// Delete a reminder with the given id
  Future<void> deleteReminder({required int id}) =>
      _remindersApi.deleteReminder(id: id);

  /// Takes a list of ids and check if there exist and reminder for each id
  /// returns a list of boolean values (true==exists)
  Future<List<bool>> checkReminders({required List<int> ids}) =>
      _remindersApi.checkReminders(ids: ids);
}
