import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/home/home.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  group('HomeNavRail', () {
    late GoRouter goRouter;
    late AppBloc appBloc;

    setUp(() {
      goRouter = MockGoRouter();
      appBloc = MockAppBloc();
    });

    Widget buildSubject({
      HomeSize currentSize = HomeSize.large,
      int selectedIndex = 0,
    }) {
      return InheritedGoRouter(
        goRouter: goRouter,
        child: BlocProvider.value(
          value: appBloc,
          child: HomeNavRail(
            currentSize: currentSize,
            selectedIndex: selectedIndex,
          ),
        ),
      );
    }

    group('Planner destination', () {
      testWidgets('renders Planner text when size is large', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(
          find.text('Planner'),
          findsOneWidget,
        );
      });

      testWidgets(
          'renders calendar_today icon '
          'when size is not large', (tester) async {
        await tester.pumpApp(buildSubject(currentSize: HomeSize.small));

        expect(
          find.byIcon(Icons.calendar_today),
          findsOneWidget,
        );
      });

      testWidgets('goes to PlannerPage when is selected', (tester) async {
        when(
          () => goRouter.namedLocation(
            AppRoutes.home,
            params: {'page': 'planner'},
          ),
        ).thenReturn('/home/planner');

        await tester.pumpApp(buildSubject());

        await tester.tap(find.text('Planner'));

        verify(() => goRouter.go('/home/planner'));
      });
    });

    group('Schedule destination', () {
      testWidgets('renders Schedule text when size is large', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(
          find.text('Schedule'),
          findsOneWidget,
        );
      });

      testWidgets(
          'renders schedule icon '
          'when size is not large', (tester) async {
        await tester.pumpApp(buildSubject(currentSize: HomeSize.small));

        expect(
          find.byIcon(Icons.schedule),
          findsOneWidget,
        );
      });

      testWidgets('goes to SchedulePage when is selected', (tester) async {
        when(
          () => goRouter.namedLocation(
            AppRoutes.home,
            params: {'page': 'schedule'},
          ),
        ).thenReturn('/home/schedule');

        await tester.pumpApp(buildSubject());

        await tester.tap(find.text('Schedule'));

        verify(() => goRouter.go('/home/schedule'));
      });
    });

    group('Settings destination', () {
      testWidgets('renders Settings text when size is large', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(
          find.text('Settings'),
          findsOneWidget,
        );
      });

      testWidgets(
          'renders settings icon '
          'when size is not large', (tester) async {
        await tester.pumpApp(buildSubject(currentSize: HomeSize.small));

        expect(
          find.byIcon(Icons.settings),
          findsOneWidget,
        );
      });

      testWidgets('goes to SettingsPage when is selected', (tester) async {
        when(
          () => goRouter.namedLocation(
            AppRoutes.home,
            params: {'page': 'settings'},
          ),
        ).thenReturn('/home/settings');

        await tester.pumpApp(buildSubject());

        await tester.tap(find.text('Settings'));

        verify(() => goRouter.go('/home/settings'));
      });
    });
  });
}
