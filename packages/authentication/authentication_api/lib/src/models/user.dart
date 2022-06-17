import 'package:equatable/equatable.dart';

/// {@template user}
/// A user account
/// {@endtemplate}
class User extends Equatable {
  /// {@macro user}
  const User({
    required this.id,
    this.email,
  });

  /// The users id
  final String id;

  /// The users emails address
  final String? email;

  @override
  List<Object?> get props => [id, email];
}
