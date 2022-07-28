import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('AppBloc', () {
    late AppBloc appBloc;

    setUp(() async {
      appBloc = await mockHydratedStorage(AppBloc.new);
    });
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
      blocTest<AppBloc, AppState>(
        'emits new state with updated route',
        build: () => appBloc,
        act: (bloc) => bloc.add(const AppRouteChanged('/home')),
        expect: () => const <AppState>[
          AppState(route: '/home'),
        ],
      );
    });

    group('ThemeModeChanged', () {
      blocTest<AppBloc, AppState>(
        'emits new state with updated themeModeIndex.',
        build: () => appBloc,
        act: (bloc) => bloc.add(const AppThemeModeChanged(1)),
        expect: () => const <AppState>[
          AppState(themeModeIndex: 1),
        ],
      );
    });

    group('SettingsIndexChanged', () {
      blocTest<AppBloc, AppState>(
        'emits new state with updated settingsIndex.',
        build: () => appBloc,
        act: (bloc) => bloc.add(const AppSettingsIndexChanged(1)),
        expect: () => const <AppState>[
          AppState(settingsIndex: 1),
        ],
      );
    });

    group('TimelineStartHourChanged', () {
      blocTest<AppBloc, AppState>(
        'emits new state with updated settingsIndex.',
        build: () => appBloc,
        act: (bloc) => bloc.add(const AppTimelineStartHourChanged(8)),
        expect: () => const <AppState>[
          AppState(timelineStartHour: 8),
        ],
      );
    });

    group('TimelineEndHourChanged', () {
      blocTest<AppBloc, AppState>(
        'emits new state with updated settingsIndex.',
        build: () => appBloc,
        act: (bloc) => bloc.add(const AppTimelineEndHourChanged(24)),
        expect: () => const <AppState>[
          AppState(timelineEndHour: 24),
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
