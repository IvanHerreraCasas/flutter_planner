part of 'my_details_bloc.dart';

enum MyDetailsStatus { initial, loading, failure, success }

class MyDetailsState extends Equatable {
  const MyDetailsState({
    this.status = MyDetailsStatus.initial,
    this.userName = '',
    this.email = '',
    this.errorMessage = '',
  });

  final MyDetailsStatus status;
  final String userName;
  final String email;
  final String errorMessage;

  MyDetailsState copyWith({
    MyDetailsStatus? status,
    String? userName,
    String? email,
    String? errorMessage,
  }) {
    return MyDetailsState(
      status: status ?? this.status,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        status,
        userName,
        email,
        errorMessage,
      ];
}
