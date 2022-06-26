import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_planner/authentication/authentication.dart';

class MockAuthenticationBloc
    extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}
