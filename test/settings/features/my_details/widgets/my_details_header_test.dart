import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/settings/settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('MyDetailsHeader', () {
    late MyDetailsBloc myDetailsBloc;
    late AuthenticationBloc authenticationBloc;
    late GoRouter goRouter;

    const mockUser = User(id: 'id');

    setUp(() {
      goRouter = MockGoRouter();
      myDetailsBloc = MockMyDetailsBloc();
      authenticationBloc = MockAuthenticationBloc();

      when(() => authenticationBloc.state).thenReturn(
        const AuthenticationState.authenticated(mockUser),
      );
    });

    Widget buildSubject({bool isPage = true}) {
      return InheritedGoRouter(
        goRouter: goRouter,
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: authenticationBloc),
            BlocProvider.value(value: myDetailsBloc),
          ],
          child: MyDetailsHeader(isPage: isPage),
        ),
      );
    }

    group('Leading icon', () {
      testWidgets('is rendered when my details is a page', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      });

      testWidgets('is not rendered when my details is not a page',
          (tester) async {
        await tester.pumpApp(buildSubject(isPage: false));

        expect(find.byIcon(Icons.arrow_back), findsNothing);
      });

      testWidgets('pops when is pressed', (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.tap(find.byIcon(Icons.arrow_back));

        verify(() => goRouter.pop()).called(1);
      });
    });

    group('Save button', () {
      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(
          find.widgetWithText(ElevatedButton, 'Save'),
          findsOneWidget,
        );
      });

      testWidgets(
          'add MyDetailsSaved to MyDetailsBloc '
          'when is pressed and user is editable', (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));

        verify(
          () => myDetailsBloc.add(const MyDetailsSaved()),
        ).called(1);
      });

      testWidgets('can not be pressed when user is not editable',
          (tester) async {
        when(() => authenticationBloc.state).thenReturn(
          const AuthenticationState.authenticated(
            User(id: 'id', isEditable: false),
          ),
        );
        await tester.pumpApp(buildSubject());

        final saveButton = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'Save'),
        );

        expect(
          saveButton.onPressed,
          equals(null),
        );
      });
    });
  });
}
