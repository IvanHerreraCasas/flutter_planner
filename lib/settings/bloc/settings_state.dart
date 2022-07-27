part of 'settings_bloc.dart';


class SettingsState extends Equatable {
  const SettingsState({
    this.selectedIndex = 0,
  });

  final int selectedIndex;

 
  SettingsState copyWith({
    int? selectedIndex,
  }) {
    return SettingsState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object> get props => [selectedIndex];
}
