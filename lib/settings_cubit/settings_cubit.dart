import 'dart:async';
import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:prayer_guard_desktop/settings_cubit/settings.dart';
// ignore: depend_on_referenced_packages
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
    updateNextPrayer();
  }

  void initialize() async {
    await setPrayers();
    await updateNextPrayer();
    updateMinutesUntilNextPrayer();
    shutDownOnPrayer();
    alarm();
  }

  Future<void> alarm() async {
    while (true) {
      final DateTime now = DateTime.now();
      final nextPrayer = state.nextPrayer!.values.first
          .subtract(Duration(minutes: state.alarmBefore));
      final sleepDuration = nextPrayer.difference(now);
      await Future.delayed(sleepDuration);
      appWindow.show();
      await Future.delayed(Duration(minutes: state.alarmBefore));
    }
  }

  Future<void> updateNextPrayer() async {
    state.prayers!.nextPrayer().then((value) {
      emit(state.copyWith(nextPrayer: value));
    });
  }

  Future<void> shutDownOnPrayer() async {
    while (state.isAutoShutdown) {
      final DateTime now = DateTime.now();
      final sleepDuration = state.nextPrayer!.values.first.difference(now);
      await Future.delayed(sleepDuration);
      await Process.run(
          'rundll32.exe', ['powrprof.dll,SetSuspendState', 'Sleep']);
    }
  }

  void updateMinutesUntilNextPrayer() async {
    while (true) {
      updateNextPrayer();
      final DateTime now = DateTime.now();
      final minutesUntilNextPrayer =
          state.nextPrayer!.values.first.difference(now);
      emit(state.copyWith(minutesUntilNextPrayer: minutesUntilNextPrayer));
      await Future.delayed(const Duration(minutes: 1));
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
