import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:prayer_guard_desktop/settings_cubit/settings_state.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:salat/salat.dart';

import '../services/services.dart';

class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  void setCalculationMethod(String method) {
    emit(state.copyWith(calculationMethod: method));
    setPrayers();
  }

  void setTimezoneMethod(String timezone) {
    emit(state.copyWith(timezone: timezone));
    setPrayers();
  }

  void setAlarmBefore(int alarmBefore) {
    emit(state.copyWith(alarmBefore: alarmBefore));
    setPrayers();
  }

  void setAsrMethod(String asrMethod) {
    emit(state.copyWith(asrMethod: asrMethod));
    setPrayers();
  }

  void setIsAutoShutdown(bool isAutoShutdown) {
    emit(state.copyWith(isAutoShutdown: isAutoShutdown));
    setPrayers();
  }

  Future<void> setPrayers() async {
    final GeolocatorPlatform geolocatorWindows = GeolocatorPlatform.instance;
    final position = await geolocatorWindows.getCurrentPosition();
    emit(state.copyWith(
        prayers: Prayers(
      date: DateTime.now(),
      timezone: state.timezone,
      method: CalculationMethod.values.firstWhere((e) =>
          e.toString() == 'CalculationMethod.${state.calculationMethod}'),
      asrMethod: AsrMethod.values
          .firstWhere((e) => e.toString() == 'AsrMethod.${state.asrMethod}'),
      longitude: position.longitude,
      latitude: position.latitude,
    )));
  }

  void initialize() async {
    await setPrayers();
    await updateNextPrayer();
    await shutDownOnPrayer();
  }

  Future<void> updateNextPrayer() async {
    state.prayers!.nextPrayer().then((value) {
      emit(state.copyWith(nextPrayer: value));
    });
  }

  Future<void> shutDownOnPrayer() async {
    while (state.isAutoShutdown) {
    print(state.nextPrayer!.keys.first);
      final DateTime now = DateTime.now() ;
      final sleepDuration = state.nextPrayer!.values.first.difference(now);
      await Future.delayed(sleepDuration);
      //! shutdown logic here
    }
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    return SettingsState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    return state.toMap();
  }
}
