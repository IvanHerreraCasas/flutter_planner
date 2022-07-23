import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/home/home.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

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

    testWidgets(
        'pops and goes to PlannerPage '
        'when planner is selected', (tester) async {
      await tester.pumpApp(buildSubject());

      await tester.dragFrom(Offset.zero, const Offset(200, 0));

      await tester.pump();

      await tester.tap(find.widgetWithText(ListTile, 'Planner'));

      verify(() => navigator.pop()).called(1);
      verify(
        () => goRouter.goNamed(
          AppRoutes.home,
          params: {'page': 'planner'},
        ),
      ).called(1);
    });

    testWidgets(
        'pops and goes to SchedulePage '
        'when planner is selected', (tester) async {
      await tester.pumpApp(buildSubject());

      await tester.dragFrom(Offset.zero, const Offset(200, 0));

      await tester.pump();

      await tester.tap(find.widgetWithText(ListTile, 'Schedule'));

      verify(() => navigator.pop()).called(1);
      verify(
        () => goRouter.goNamed(
          AppRoutes.home,
          params: {'page': 'schedule'},
        ),
      ).called(1);
    });
  });
}
