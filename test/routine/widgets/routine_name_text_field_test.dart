import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/routine/routine.dart';
import 'package:flutter_planner/widgets/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';
import '../routine_mocks.dart';

void main() {
  group('RoutineNameTextField', () {
    late RoutineBloc routineBloc;

    setUp(() {
      routineBloc = MockRoutineBloc();

      when(() => routineBloc.state).thenReturn(mockRoutineState);
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: routineBloc,
        child: const RoutineNameTextField(),
      );
    }

    testWidgets('renders NameTextField with correct name', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(NameTextField), findsOneWidget);
      expect(find.text(mockRoutineState.name), findsOneWidget);
    });

    testWidgets(
        'add RoutineNameChanged '
        'to RoutineBloc '
        'when a new value is entered', (tester) async {
      await tester.pumpApp(buildSubject());

      const newName = 'new name';

      await tester.enterText(find.byType(NameTextField), newName);

      verify(() => routineBloc.add(const RoutineNameChanged(newName)))
          .called(1);
    });
  });
}
