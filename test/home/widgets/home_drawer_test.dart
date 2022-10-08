import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/home/home.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

void main() {
  group('HomeDrawer', () {
    late GoRouter goRouter;
    late MockNavigator navigator;
    late AppBloc appBloc;

    setUp(() {
      navigator = MockNavigator();
      goRouter = MockGoRouter();
      appBloc = MockAppBloc();
    });

    Widget buildSubject() {
      return MockNavigatorProvider(
        navigator: navigator,
        child: InheritedGoRouter(
          goRouter: goRouter,
          child: BlocProvider.value(
            value: appBloc,
            child: Scaffold(
              appBar: AppBar(),
              drawer: const HomeDrawer(),
            ),
          ),
        ),
      );
    }

    testWidgets('renders Planner ListTile', (tester) async {
      await tester.pumpApp(buildSubject());

      await tester.dragFrom(Offset.zero, const Offset(200, 0));

      await tester.pump();

      expect(find.widgetWithText(ListTile, 'Planner'), findsOneWidget);
    });

    testWidgets('renders Schedule ListTile', (tester) async {
      await tester.pumpApp(buildSubject());

      await tester.dragFrom(Offset.zero, const Offset(200, 0));

      await tester.pump();

      expect(find.widgetWithText(ListTile, 'Schedule'), findsOneWidget);
    });

    testWidgets('renders Settings ListTile', (tester) async {
      await tester.pumpApp(buildSubject());

      await tester.dragFrom(Offset.zero, const Offset(200, 0));

      await tester.pump();

      expect(find.widgetWithText(ListTile, 'Settings'), findsOneWidget);
    });

    testWidgets(
        'pops and goes to PlannerPage '
        'when planner is selected', (tester) async {
      when(
        () => goRouter.namedLocation(
          AppRoutes.home,
          params: {'page': 'planner'},
        ),
      ).thenReturn('/home/planner');

      await tester.pumpApp(buildSubject());

      await tester.dragFrom(Offset.zero, const Offset(200, 0));

      await tester.pump();

      await tester.tap(find.widgetWithText(ListTile, 'Planner'));

      verify(() => navigator.pop());
      verify(() => goRouter.go('/home/planner'));
    });

    testWidgets(
        'pops and goes to SchedulePage '
        'when planner is selected', (tester) async {
      when(
        () => goRouter.namedLocation(
          AppRoutes.home,
          params: {'page': 'schedule'},
        ),
      ).thenReturn('/home/schedule');

      await tester.pumpApp(buildSubject());

      await tester.dragFrom(Offset.zero, const Offset(200, 0));

      await tester.pump();

      await tester.tap(find.widgetWithText(ListTile, 'Schedule'));

      verify(() => navigator.pop());
      verify(() => goRouter.go('/home/schedule'));
    });

    testWidgets(
        'pops and goes to SettingsPage '
        'when settings is selected', (tester) async {
      when(
        () => goRouter.namedLocation(
          AppRoutes.home,
          params: {'page': 'settings'},
        ),
      ).thenReturn('/home/settings');

      await tester.pumpApp(buildSubject());

      await tester.dragFrom(Offset.zero, const Offset(200, 0));

      await tester.pump();

      await tester.tap(find.widgetWithText(ListTile, 'Settings'));

      verify(() => navigator.pop());
      verify(() => goRouter.go('/home/settings'));
    });
  });
}
