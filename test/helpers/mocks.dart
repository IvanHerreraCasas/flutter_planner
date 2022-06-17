import 'package:activities_repository/activities_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:routines_repository/routines_repository.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockActivitiesRepository extends Mock implements ActivitiesRepository {}

class MockRoutinesRepository extends Mock implements RoutinesRepository {}

class MockGoRouter extends Mock implements GoRouter {}
