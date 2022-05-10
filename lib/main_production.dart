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
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/bootstrap.dart';
import 'package:routines_repository/routines_repository.dart';
import 'package:supabase_activities_api/supabase_activities_api.dart';
import 'package:supabase_authentication_api/supabase_authentication_api.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_routines_api/supabase_routines_api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  final supabase = await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'],
    anonKey: dotenv.env['SUPABASE_ANON_KEY'],
  );
  final supabaseClient = supabase.client;

  final supabaseAuthApi = SupabaseAuthenticationApi(
    supabaseClient: supabaseClient,
  );

  final supabaseActivitiesApi = SupabaseActivitiesApi(
    supabaseClient: supabaseClient,
  );

  final routinesApi = SupabaseRoutinesApi(
    supabaseClient: supabaseClient,
  );

  await bootstrap(
    () => App(
      authenticationRepository: AuthenticationRepository(
        authenticationApi: supabaseAuthApi,
      ),
      activitiesRepository: ActivitiesRepository(
        activitiesApi: supabaseActivitiesApi,
      ),
      routinesRepository: RoutinesRepository(
        routinesApi: routinesApi,
      ),
    ),
  );
}
