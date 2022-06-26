import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/activity/activity.dart';
import 'package:flutter_planner/app/router/router.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';
import '../activity_mocks.dart';

void main() {
  group('ActivityHeaderButtons', () {
    late ActivityBloc activityBloc;
    late GoRouter goRouter;

    setUp(() {
      activityBloc = MockActivityBloc();
      goRouter = MockGoRouter();

      when(() => activityBloc.state).thenReturn(mockActivityState);
    });

    Widget buildSubject({bool isDialog = false}) {
      return InheritedGoRouter(
        goRouter: goRouter,
        child: BlocProvider.value(
          value: activityBloc,
          child: ActivityHeaderButtons(isDialog: isDialog),
        ),
      );
    }

    group('leading button', () {
      group('when is not a dialog', () {
        testWidgets('renders Icons.arrow', (tester) async {
          await tester.pumpApp(buildSubject());

          expect(find.byIcon(Icons.arrow_back), findsOneWidget);
        });

        testWidgets('pops when is pressed', (tester) async {
          await tester.pumpApp(buildSubject());

          await tester.tap(find.byIcon(Icons.arrow_back));

          verify(() => goRouter.pop()).called(1);
        });
      });

      group('when is a dialog', () {
        testWidgets('renders Icons.open_in_full', (tester) async {
          await tester.pumpApp(buildSubject(isDialog: true));

          expect(find.byIcon(Icons.open_in_full), findsOneWidget);
        });

        testWidgets('goes to activityPage with correct initialActivity',
            (tester) async {
          await tester.pumpApp(buildSubject(isDialog: true));

          await tester.tap(find.byIcon(Icons.open_in_full));

          verify(
            () => goRouter.goNamed(
              AppRoutes.activity,
              params: {'page': 'planner'},
              extra: mockActivityState.initialActivity,
            ),
          );
        });
      });
    });

    group('save button', () {
      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.text('Save'), findsOneWidget);
      });

      testWidgets(
          'add ActivitySaved '
          'to ActivityBloc '
          'when is pressed', (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.tap(find.text('Save'));

        verify(() => activityBloc.add(const ActivitySaved())).called(1);
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
          'add ActivityDeleted '
          'to ActivityBloc '
          'when delete item is Pressed', (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.tap(find.byType(PopupMenuButton<String>));

        await tester.pump();

        await tester.ensureVisible(find.text('Delete'));

        await tester.pumpAndSettle();

        await tester.tap(find.text('Delete'));

        verify(() => activityBloc.add(const ActivityDeleted())).called(1);
      });
    });
  });
}
