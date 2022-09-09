import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reminders_api/reminders_api.dart';
import 'package:timezone/timezone.dart' as tz;

/// {@template local_reminders_api}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class LocalRemindersApi implements RemindersApi {
  /// {@macro local_reminders_api}
  const LocalRemindersApi({
    required FlutterLocalNotificationsPlugin localNotificationsPlugin,
    required NotificationDetails notificationDetails,
    required bool isInitialized,
  })  : _localNotificationsPlugin = localNotificationsPlugin,
        _notificationDetails = notificationDetails,
        _isInitialized = isInitialized;

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin;
  final NotificationDetails _notificationDetails;
  final bool _isInitialized;

  @override
  bool get isAllowed =>
      _isInitialized && (Platform.isAndroid || Platform.isIOS);

  @override
  Future<List<bool>> checkReminders({required List<int> ids}) async {
    final checkList = <bool>[];

    final pendingNotifications =
        await _localNotificationsPlugin.pendingNotificationRequests();

    final pendingNotificationIDs =
        pendingNotifications.map((notification) => notification.id).toList();

    for (final id in ids) {
      if (pendingNotificationIDs.contains(id)) {
        checkList.add(true);
      } else {
        checkList.add(false);
      }
    }

    return checkList;
  }

  @override
  Future<void> saveReminder({required Reminder reminder}) async {
    final now = tz.TZDateTime.now(tz.local);

    if (reminder.dateTime.isAfter(now)) {
      await _localNotificationsPlugin.zonedSchedule(
        reminder.id,
        reminder.title,
        reminder.body,
        tz.TZDateTime.from(reminder.dateTime, tz.local),
        _notificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  @override
  Future<void> deleteReminder({required int id}) async {
    await _localNotificationsPlugin.cancel(id);
  }
}
