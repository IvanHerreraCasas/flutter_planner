import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/settings/settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../../helpers/helpers.dart';

void main() {
  late AppBloc appBloc;

  setUp(() {
    appBloc = MockAppBloc();

    when(() => appBloc.state).thenReturn(const AppState());
  });
  group('AppearancePage', () {
    Widget buildSubject({bool isPage = true}) {
      return BlocProvider.value(
        value: appBloc,
        child: AppearancePage(isPage: isPage),
      );
    }

    testWidgets('renders AppearanceView', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(AppearanceView), findsOneWidget);
    });
  });

  group('AppearanceView', () {
    Widget buildSubject({bool isPage = true}) {
      return BlocProvider.value(
        value: appBloc,
        child: AppearancePage(isPage: isPage),
      );
    }

    testWidgets('renders correct widgets', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(AppearanceHeader), findsOneWidget);
      expect(find.byType(AppearanceTheme), findsOneWidget);
      expect(find.byType(AppearanceTimeline), findsOneWidget);
    });
  });
}
