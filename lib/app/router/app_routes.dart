enum AppRoutes {
  signUp(name: 'signUp', path: '/sign-up'),
  signIn(name: 'signIn', path: '/sign-in'),
  home(name: 'home', path: '/home/:page'),
  activity(name: 'activity', path: 'activity'),
  routine(name: 'routine', path: 'routine');

  const AppRoutes({
    required this.path,
    required this.name,
  });

  final String path;
  final String name;
}
