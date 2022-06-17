// ignore_for_file: prefer_const_constructors

import 'package:flutter_planner/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppEvent', () {
    group('AppRouteChanged', () {
      test('supports value equality', () {
        expect(AppRouteChanged('/home'), equals(AppRouteChanged('/home')));
      });

      test('props are correct', () {
        expect(AppRouteChanged('/home').props, equals(['/home']));
      });
    });
  });
}
