import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/routine/routine.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';
import '../routine_mocks.dart';

void main() {
  group('RoutineHeaderButtons', () {
    late RoutineBloc routineBloc;
    late GoRouter goRouter;

    setUp(() {
      routineBloc = MockRoutineBloc();
      goRouter = MockGoRouter();

      when(() => routineBloc.state).thenReturn(mockRoutineState);
    });

    Widget buildSubject({bool isPage = false}) {
      return InheritedGoRouter(
        goRouter: goRouter,
        child: BlocProvider.value(
          value: routineBloc,
          child: RoutineHeaderButtons(isPage: isPage),
        ),
      );
    }

    group('leading button', () {
      testWidgets('renders Icons arrow_back when is page', (tester) async {
        await tester.pumpApp(buildSubject(isPage: true));

        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      });

      testWidgets('pops when is pressed', (tester) async {
        await tester.pumpApp(buildSubject(isPage: true));

        await tester.tap(find.byIcon(Icons.arrow_back));

        verify(() => goRouter.pop()).called(1);
      });
    });

    group('save button', () {
      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.text('Save'), findsOneWidget);
      });

      testWidgets(
          'add RoutineSaved '
          'to RoutineBloc '
          'when is pressed', (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.tap(find.text('Save'));

        verify(() => routineBloc.add(const RoutineSaved())).called(1);
      });
    });

    group('menu button', () {
      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.byType(PopupMenuButton<String>), findsOneWidget);
      });

      testWidgets('renders delete item', (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.tap(find.byType(PopupMenuButton<String>));

        await tester.pump();

        expect(find.text('Delete'), findsOneWidget);
      });

      testWidgets(
          'add RoutineDeleted '
          'to RoutineBloc '
          'when delete item is Pressed', (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.tap(find.byType(PopupMenuButton<String>));

        await tester.pump();

        await tester.ensureVisible(find.text('Delete'));

        await tester.pumpAndSettle();

        await tester.tap(find.text('Delete'));

        verify(() => routineBloc.add(const RoutineDeleted())).called(1);
      });
    });
  });
}
