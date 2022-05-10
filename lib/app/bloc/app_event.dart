part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class AppRouteChanged extends AppEvent {
  const AppRouteChanged(this.route);

  final String route;

  @override
  List<Object?> get props => [route];
}
