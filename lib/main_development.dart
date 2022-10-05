// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:activities_repository/activities_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/bootstrap.dart';
import 'package:local_reminders_api/local_reminders_api.dart';
import 'package:reminders_repository/reminders_repository.dart';
import 'package:routines_repository/routines_repository.dart';
import 'package:supabase_activities_api/supabase_activities_api.dart';
import 'package:supabase_authentication_api/supabase_authentication_api.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_routines_api/supabase_routines_api.dart';
import 'package:supabase_tasks_api/supabase_tasks_api.dart';
import 'package:tasks_repository/tasks_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

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

  await localNotificationsPlugin.initialize(
    initializationSettings,
  );

  final supabase = await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'],
    anonKey: dotenv.env['SUPABASE_ANON_KEY'],
  );
  final supabaseClient = supabase.client;

  final authenticationApi = SupabaseAuthenticationApi(
    supabaseClient: supabaseClient,
  );

  final activitiesApi = SupabaseActivitiesApi(
    supabaseClient: supabaseClient,
  );

  final routinesApi = SupabaseRoutinesApi(
    supabaseClient: supabaseClient,
  );

  final tasksApi = SupabaseTasksApi(
    supabaseClient: supabaseClient,
  );

  final isNotificationPluginInitialized =
      (await localNotificationsPlugin.initialize(
            initializationSettings,
          )) ??
          false;

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
      authenticationRepository: AuthenticationRepository(
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
