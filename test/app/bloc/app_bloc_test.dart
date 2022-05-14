import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('AppBloc', () {
    group('constructor', () {
      test('works normally', () {
        mockHydratedStorage(() => expect(AppBloc.new, returnsNormally));
      });

      test('has correct initial state', () {
        mockHydratedStorage(
          () => expect(AppBloc().state, equals(const AppState())),
        );
      });
    });

    group('RouteChanged', () {
      late AppBloc appBloc;

      setUp(() async {
        appBloc = await mockHydratedStorage(AppBloc.new);
      });

      blocTest<AppBloc, AppState>(
        'emits new state with updated route',
        build: () => appBloc,
        act: (bloc) => bloc.add(const AppRouteChanged('/home')),
        expect: () => const <AppState>[
          AppState(route: '/home'),
        ],
      );
    });

    test('fromJson/toJson work properly', () {
      mockHydratedStorage(() {
        final appBloc = AppBloc();

        expect(
          appBloc.fromJson(appBloc.toJson(appBloc.state)!),
          equals(appBloc.state),
        );
      });
    });
  });
}
