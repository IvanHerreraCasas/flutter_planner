import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/settings/features/features.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../../helpers/helpers.dart';

void main() {
  late AuthenticationBloc authenticationBloc;

  const mockUser = User(
    id: 'id',
    name: 'name',
    email: 'email@example.com',
  );

  setUp(() {
    authenticationBloc = MockAuthenticationBloc();

    when(() => authenticationBloc.state).thenReturn(
      const AuthenticationState.authenticated(mockUser),
    );
  });
  group('MyDetailsPage', () {
    Widget buildSubject({bool isPage = true}) {
      return BlocProvider.value(
        value: authenticationBloc,
        child: MyDetailsPage(isPage: isPage),
      );
    }

    testWidgets('renders MyDetailsView', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(MyDetailsView), findsOneWidget);
    });
  });

  group('MyDetailsView', () {
    late MyDetailsBloc myDetailsBloc;

    setUp(() {
      myDetailsBloc = MockMyDetailsBloc();

      when(() => myDetailsBloc.state).thenReturn(
        MyDetailsState(
          userName: mockUser.name ?? '',
          email: mockUser.email ?? '',
        ),
      );
    });

    Widget buildSubject({bool isPage = true}) {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: authenticationBloc),
          BlocProvider.value(value: myDetailsBloc)
        ],
        child: MyDetailsView(isPage: isPage),
      );
    }

    testWidgets('renders correct widgets', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(MyDetailsHeader), findsOneWidget);
      expect(find.byType(MyDetailsUserName), findsOneWidget);
      expect(find.byType(MyDetailsEmail), findsOneWidget);
    });

    group('BlocListener', () {
      testWidgets('shows snackBar when status changes to failure',
          (tester) async {
        whenListen(
          myDetailsBloc,
          Stream.fromIterable(const [
            MyDetailsState(
              status: MyDetailsStatus.loading,
              userName: 'name',
              email: 'email@example.com',
            ),
            MyDetailsState(
              status: MyDetailsStatus.failure,
              userName: 'name',
              email: 'email@example.com',
              errorMessage: 'error',
            ),
          ]),
        );

        await tester.pumpApp(buildSubject());

        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);
      });

      testWidgets('shows snackBar when errorMessage changes', (tester) async {
        whenListen(
          myDetailsBloc,
          Stream.fromIterable(const [
            MyDetailsState(
              status: MyDetailsStatus.failure,
              userName: 'name',
              email: 'email@example.com',
              errorMessage: 'error',
            ),
            MyDetailsState(
              status: MyDetailsStatus.failure,
              userName: 'name',
              email: 'email@example.com',
              errorMessage: 'new error',
            ),
          ]),
        );

        await tester.pumpApp(buildSubject());

        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);
      });

      testWidgets('shows snackBar when status changes to success',
          (tester) async {
        whenListen(
          myDetailsBloc,
          Stream.fromIterable(const [
            MyDetailsState(
              status: MyDetailsStatus.loading,
              userName: 'name',
              email: 'email@example.com',
            ),
            MyDetailsState(
              status: MyDetailsStatus.success,
              userName: 'name',
              email: 'email@example.com',
            ),
          ]),
        );

        await tester.pumpApp(buildSubject());

        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);
      });
    });
  });
}
