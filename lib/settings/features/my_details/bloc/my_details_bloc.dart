import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'my_details_event.dart';
part 'my_details_state.dart';

class MyDetailsBloc extends Bloc<MyDetailsEvent, MyDetailsState> {
  MyDetailsBloc({
    required User user,
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(
          MyDetailsState(
            userName: user.name ?? '',
            email: user.email ?? '',
          ),
        ) {
    on<MyDetailsUserNameChanged>(_onUserNameChanged);
    on<MyDetailsEmailChanged>(_onEmailChanged);
    on<MyDetailsUserNameSaved>(_onUserNameSaved);
    on<MyDetailsEmailSaved>(_onEmailSaved);
    on<MyDetailsSaved>(_onSaved);
  }

  final AuthenticationRepository _authenticationRepository;

  void _onUserNameChanged(
    MyDetailsUserNameChanged event,
    Emitter<MyDetailsState> emit,
  ) {
    emit(state.copyWith(userName: event.userName));
  }

  void _onEmailChanged(
    MyDetailsEmailChanged event,
    Emitter<MyDetailsState> emit,
  ) {
    emit(state.copyWith(email: event.email));
  }

  Future<void> _onUserNameSaved(
    MyDetailsUserNameSaved event,
    Emitter<MyDetailsState> emit,
  ) async {
    emit(state.copyWith(status: MyDetailsStatus.loading));
    try {
      await _authenticationRepository.changeName(name: state.userName);
      emit(state.copyWith(status: MyDetailsStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: MyDetailsStatus.failure,
          errorMessage: 'error: the name could not be changed',
        ),
      );
    }
  }

  Future<void> _onEmailSaved(
    MyDetailsEmailSaved event,
    Emitter<MyDetailsState> emit,
  ) async {
    emit(state.copyWith(status: MyDetailsStatus.loading));
    try {
      await _authenticationRepository.changeEmail(email: state.email);
      emit(state.copyWith(status: MyDetailsStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: MyDetailsStatus.failure,
          errorMessage: 'error: the email could not be changed',
        ),
      );
    }
  }

  Future<void> _onSaved(
    MyDetailsSaved event,
    Emitter<MyDetailsState> emit,
  ) async {
    emit(state.copyWith(status: MyDetailsStatus.loading));
    try {
      await _authenticationRepository.changeName(name: state.userName);
      await _authenticationRepository.changeEmail(email: state.email);
      emit(state.copyWith(status: MyDetailsStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: MyDetailsStatus.failure,
          errorMessage: 'error: details could not be changed',
        ),
      );
    }
  }
}
