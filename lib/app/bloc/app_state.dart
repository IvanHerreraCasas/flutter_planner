part of 'app_bloc.dart';

class AppState extends Equatable {
  const AppState({
    this.route = '/sign-in',
  });

  factory AppState.fromJson(Map<String, dynamic> jsonMap) {
    return AppState(
      route: jsonMap['route'] as String? ?? '',
    );
  }

  final String route;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'route': route,
    };
  }

  AppState copyWith({
    String? route,
  }) {
    return AppState(
      route: route ?? this.route,
    );
  }

  @override
  List<Object?> get props => [route];
}
