import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<SettingsSelectedIndexChanged>(_onSelectedIndexChanged);
  }

  void _onSelectedIndexChanged(
    SettingsSelectedIndexChanged event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(selectedIndex: event.selectedIndex));
  }
}
