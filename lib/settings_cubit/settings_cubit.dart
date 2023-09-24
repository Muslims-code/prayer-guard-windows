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
  }

  void setAsrMethod(String asrMethod) {
    emit(state.copyWith(asrMethod: asrMethod));
  }

  void setIsAutoShutdown(bool isAutoShutdown) {
    emit(state.copyWith(isAutoShutdown: isAutoShutdown));
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
    alarm();
    updateMinutesUntilNextPrayer();
    shutDownOnPrayer();
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
    await setPrayers();
    final pr = await state.prayers!.nextPrayer();
    emit(state.copyWith(nextPrayer: pr));
  }

  Future<void> shutDownOnPrayer() async {
    while (true) {
      await updateNextPrayer();
      final DateTime now = DateTime.now();
      if (state.nextPrayer!.values.first.isAfter(now)) {
        final sleepDuration = state.nextPrayer!.values.first.difference(now);
        if (state.isAutoShutdown) {
          await Future.delayed(sleepDuration);
          await Process.run(
              'rundll32.exe', ['powrprof.dll,SetSuspendState', 'Sleep']);
        } else {
          await Future.delayed(sleepDuration);
        }
      } else {
        await Future.delayed(const Duration(seconds: 10));
      }
    }
  }

  void updateMinutesUntilNextPrayer()async {
    final DateTime now = DateTime.now();
    final minutesUntilNextPrayer =
        state.nextPrayer!.values.first.difference(now);
    emit(state.copyWith(minutesUntilNextPrayer: minutesUntilNextPrayer));

     Timer.periodic(const Duration(minutes: 1), (timer) async{
      final DateTime now = DateTime.now();
      var minutesUntilNextPrayer =
          state.nextPrayer!.values.first.difference(now);
      emit(state.copyWith(minutesUntilNextPrayer: minutesUntilNextPrayer));
    });
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
