// ignore_for_file: prefer_const_constructors

import 'package:flutter_planner/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

class MockAppEvent extends AppEvent {}

void main() {
  group('AppEvent', () {
    group('BaseAppEvent', () {
      test('supports value equality', () {
        expect(MockAppEvent(), equals(MockAppEvent()));
      });

      test('props are correct', () {
        expect(MockAppEvent().props, equals(<Object?>[]));
      });
    });
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
