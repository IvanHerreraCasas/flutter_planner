import 'package:authentication_api/authentication_api.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/schedule/schedule.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:routines_api/routines_api.dart';

import '../../helpers/helpers.dart';
import '../schedule_mocks.dart';

void main() {
  group('ScheduleHeader', () {
    late GoRouter goRouter;
    late ScheduleBloc scheduleBloc;
    late AuthenticationRepository authenticationRepository;

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
      authenticationRepository = MockAuthenticationRepository();

      when(() => scheduleBloc.state).thenReturn(const ScheduleState());
      when(() => authenticationRepository.user).thenReturn(user);
    });

    Widget buildSubject({
      ScheduleSize currentSize = ScheduleSize.small,
    }) {
      return InheritedGoRouter(
        goRouter: goRouter,
        child: BlocProvider.value(
          value: scheduleBloc,
          child: ScheduleHeader(
            currentSize: currentSize,
          ),
        ),
      );
    }

    testWidgets('renders a ElevatedButton with correct text', (tester) async {
      await tester.pumpApp(
        buildSubject(),
        authenticationRepository: authenticationRepository,
      );

      expect(find.widgetWithText(ElevatedButton, 'Add'), findsOneWidget);
    });

    group('when ElevatedButton is pressed', () {
      testWidgets(
          'add ScheduleSelectedRoutineChanged '
          'to ScheduleBloc '
          'when currentSize is large', (tester) async {
        await tester.pumpApp(
          buildSubject(currentSize: ScheduleSize.large),
          authenticationRepository: authenticationRepository,
        );

        await tester.tap(find.byType(ElevatedButton));

        verify(
          () => scheduleBloc.add(ScheduleSelectedRoutineChanged(newRoutine)),
        );
      });

      testWidgets(
          'goes to /home/schedule/routine '
          'with extra newRoutine '
          'when currentSize is not large', (tester) async {
        await tester.pumpApp(
          buildSubject(),
          authenticationRepository: authenticationRepository,
        );

        await tester.tap(find.byType(ElevatedButton));

        verify(
          () => goRouter.go(
            '/home/schedule/routine',
            extra: newRoutine,
          ),
        ).called(1);
      });
    });
  });
}
