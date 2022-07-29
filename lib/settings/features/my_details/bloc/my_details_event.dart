part of 'my_details_bloc.dart';

abstract class MyDetailsEvent extends Equatable {
  const MyDetailsEvent();

  @override
  List<Object?> get props => [];
}

class MyDetailsUserNameChanged extends MyDetailsEvent {
  const MyDetailsUserNameChanged(this.userName);

  final String userName;

  @override
  List<Object?> get props => [userName];
}

class MyDetailsEmailChanged extends MyDetailsEvent {
  const MyDetailsEmailChanged(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

class MyDetailsUserNameSaved extends MyDetailsEvent {
  const MyDetailsUserNameSaved();
}

class MyDetailsEmailSaved extends MyDetailsEvent {
  const MyDetailsEmailSaved();
}

class MyDetailsSaved extends MyDetailsEvent {
  const MyDetailsSaved();
}
