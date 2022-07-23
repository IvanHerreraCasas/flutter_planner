import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/schedule/schedule.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:routines_repository/routines_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ScheduleHeader', () {
    late GoRouter goRouter;
    late ScheduleBloc scheduleBloc;
    late AuthenticationBloc authenticationBloc;

    const user = User(id: 'userID');
    final newRoutine = Routine(
      userID: user.id,
      name: '',
      day: 1,
      startTime: DateTime(1970, 1, 1, 7),
      endTime: DateTime(1970, 1, 1, 9),
    );

    setUp(() {
      goRouter = MockGoRouter();
      scheduleBloc = MockScheduleBloc();
      authenticationBloc = MockAuthenticationBloc();

      when(() => scheduleBloc.state).thenReturn(const ScheduleState());
      when(() => authenticationBloc.state).thenReturn(
        const AuthenticationState.authenticated(user),
      );
    });

    Widget buildSubject({
      ScheduleSize currentSize = ScheduleSize.small,
    }) {
      return InheritedGoRouter(
        goRouter: goRouter,
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: scheduleBloc),
            BlocProvider.value(value: authenticationBloc),
          ],
          child: ScheduleHeader(
            currentSize: currentSize,
          ),
        ),
      );
    }

    testWidgets('renders a ElevatedButton with correct text', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.widgetWithText(ElevatedButton, 'Add'), findsOneWidget);
    });

    group('when ElevatedButton is pressed', () {
      testWidgets(
          'add ScheduleSelectedRoutineChanged '
          'to ScheduleBloc '
          'when currentSize is large', (tester) async {
        await tester.pumpApp(buildSubject(currentSize: ScheduleSize.large));

        await tester.tap(find.byType(ElevatedButton));

        verify(
          () => scheduleBloc.add(ScheduleSelectedRoutineChanged(newRoutine)),
        );
      });

      testWidgets(
          'goes to RoutinePage '
          'with extra newRoutine '
          'when currentSize is not large', (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.tap(find.byType(ElevatedButton));

        verify(
          () => goRouter.goNamed(
            AppRoutes.routine,
            params: {'page': 'schedule'},
            extra: newRoutine,
          ),
        ).called(1);
      });
    });
  });
}
