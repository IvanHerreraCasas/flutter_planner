import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_planner/settings/settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SettingsBloc', () {
    SettingsBloc buildBloc() {
      return SettingsBloc();
    }

    group('constructor', () {
      test('works normally', () {
        expect(buildBloc, returnsNormally);
      });

      test('has correct initial state', () {
        expect(buildBloc().state, equals(const SettingsState()));
      });
    });

    group('SelectedIndexChanged', () {
      blocTest<SettingsBloc, SettingsState>(
        'emits new state with update selectedIndex',
        build: buildBloc,
        act: (bloc) => bloc.add(const SettingsSelectedIndexChanged(1)),
        expect: () => const <SettingsState>[
          SettingsState(selectedIndex: 1),
        ],
      );
    });
  });
}
