import 'package:equatable/equatable.dart';

/// {@template user}
/// A user account
/// {@endtemplate}
class User extends Equatable {
  /// {@macro user}
  const User({
    required this.id,
    this.name,
    this.email,
    this.isEditable = true,
  });

  /// The users id
  final String id;

  /// The users name
  final String? name;

  /// The users emails address
  final String? email;

  /// Determines if the user can be edited
  final bool isEditable;

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        isEditable,
      ];
}
