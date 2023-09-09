// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final String timezone;
  final String calculationMethod;
  final String asrMethod;
  final int alarmBefore;
  final bool isAutoShutdown;

  const SettingsState({
    this.isAutoShutdown = false,
    this.timezone = "Africa/Casablanca",
    this.calculationMethod = "MWL",
    this.alarmBefore = 5,
    this.asrMethod = "Standard",
  });

  @override
  List<Object> get props =>
      [timezone, calculationMethod, alarmBefore, asrMethod, isAutoShutdown];

  SettingsState copyWith({
    String? timezone,
    String? calculationMethod,
    int? alarmBefore,
    String? asrMethod,
    bool? isAutoShutdown,
  }) {
    return SettingsState(
      isAutoShutdown: isAutoShutdown ?? this.isAutoShutdown,
      asrMethod: asrMethod ?? this.asrMethod,
      timezone: timezone ?? this.timezone,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      alarmBefore: alarmBefore ?? this.alarmBefore,
    );
  }
}
