import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const SignInState()) {
    on<SignInEmailChanged>(_onSignInEmailChanged);
    on<SignInPasswordChanged>(_onSignInPasswordChanged);
    on<SignInPasswordVisibilityChanged>(_onPasswordVisibilityChanged);
    on<SignInRequested>(_onSignInRequested);
  }

  final AuthenticationRepository _authenticationRepository;

  void _onSignInEmailChanged(
    SignInEmailChanged event,
    Emitter<SignInState> emit,
  ) {
    emit(state.copyWith(email: event.email));
  }

  void _onSignInPasswordChanged(
    SignInPasswordChanged event,
    Emitter<SignInState> emit,
  ) {
    emit(state.copyWith(password: event.password));
  }

  void _onPasswordVisibilityChanged(
    SignInPasswordVisibilityChanged event,
    Emitter<SignInState> emit,
  ) {
    emit(state.copyWith(passwordVisibility: event.passwordVisibility));
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<SignInState> emit,
  ) async {
    emit(state.copyWith(status: SignInStatus.loading));
    try {
      await _authenticationRepository.signIn(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: SignInStatus.success));
    } on AuthenticationFailure catch (e) {
      emit(
        state.copyWith(
          status: SignInStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SignInStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
