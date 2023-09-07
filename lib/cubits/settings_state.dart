// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final String timezone;
  final String calculationMethod;
  final int alarmBefore;

  const SettingsState({
    this.timezone = "Africa/Casablanca" ,
    this.calculationMethod = "MWL" ,
    this.alarmBefore = 5,
  });

  @override
  List<Object> get props => [timezone, calculationMethod, alarmBefore];

  SettingsState copyWith({
    String? timezone,
    String? calculationMethod,
    int? alarmBefore,
  }) {
    return SettingsState(
      timezone: timezone ?? this.timezone,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      alarmBefore: alarmBefore ?? this.alarmBefore,
    );
  }
}
