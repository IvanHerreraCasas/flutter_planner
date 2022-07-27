part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class SettingsSelectedIndexChanged extends SettingsEvent {
  const SettingsSelectedIndexChanged(this.selectedIndex);

  final int selectedIndex;

  @override
  List<Object?> get props => [selectedIndex];
}
