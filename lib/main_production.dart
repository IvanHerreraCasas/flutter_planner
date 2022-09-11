// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:activities_repository/activities_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/bootstrap.dart';
import 'package:isar/isar.dart';
import 'package:isar_activities_api/isar_activities_api.dart';
import 'package:isar_authentication_api/isar_authentication_api.dart';
import 'package:isar_routines_api/isar_routines_api.dart';
import 'package:isar_tasks_api/isar_tasks_api.dart';
import 'package:local_reminders_api/local_reminders_api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reminders_repository/reminders_repository.dart';
import 'package:routines_repository/routines_repository.dart';
import 'package:tasks_repository/tasks_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationSupportDirectory();

  final localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  const initializationSettingsIOS = IOSInitializationSettings();
  const initializationSettingsMacOS = MacOSInitializationSettings();

  const initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
    macOS: initializationSettingsMacOS,
  );

  final isNotificationPluginInitialized =
      (await localNotificationsPlugin.initialize(
            initializationSettings,
          )) ??
          false;

  final isar = await Isar.open(
    [
      IsarActivitySchema,
      IsarRoutineSchema,
      IsarTaskSchema,
    ],
    directory: dir.path,
  );

  const authenticationApi = IsarAuthenticationApi();

  final activitiesApi = IsarActivitiesApi(isar: isar);

  final routinesApi = IsarRoutinesApi(isar: isar);

  final tasksApi = IsarTasksApi(isar: isar);

  final remindersApi = LocalRemindersApi(
    localNotificationsPlugin: localNotificationsPlugin,
    notificationDetails: const NotificationDetails(
      android: AndroidNotificationDetails(
        'reminders-chanel-id',
        'Reminders',
      ),
      iOS: IOSNotificationDetails(),
    ),
    isInitialized: isNotificationPluginInitialized,
  );

  await bootstrap(
    () => App(
      authenticationRepository: const AuthenticationRepository(
        authenticationApi: authenticationApi,
      ),
      activitiesRepository: ActivitiesRepository(
        activitiesApi: activitiesApi,
      ),
      routinesRepository: RoutinesRepository(
        routinesApi: routinesApi,
      ),
      tasksRepository: TasksRepository(
        tasksApi: tasksApi,
      ),
      remindersRepository: RemindersRepository(
        remindersApi: remindersApi,
      ),
    ),
  );
}
