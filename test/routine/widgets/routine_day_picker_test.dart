import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/routine/routine.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';
import '../routine_mocks.dart';

void main() {
  group('RoutineDayPicker', () {
    late RoutineBloc routineBloc;

    setUp(() {
      routineBloc = MockRoutineBloc();

      when(() => routineBloc.state).thenReturn(mockRoutineState);
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: routineBloc,
        child: const RoutineDayPicker(),
      );
    }

    testWidgets('renders a DropdownButton2 ', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(DropdownButton2<int>), findsOneWidget);
    });

    testWidgets('renders correct day', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.text('Monday'), findsOneWidget);
    });

    testWidgets(
        'add RoutineDayChanged '
        'to RoutineBloc '
        'when a new day is selected', (tester) async {
      await tester.pumpApp(buildSubject());

      await tester.tap(find.text('Monday'));

      await tester.pumpAndSettle();

      await tester.tap(find.text('Tuesday').hitTestable());

      verify(() => routineBloc.add(const RoutineDayChanged(2))).called(1);
    });
  });
}
