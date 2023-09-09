import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:prayer_guard_desktop/cubits/settings_state.dart';

class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  void setCalculationMethod(String method) =>
      emit(state.copyWith(calculationMethod: method));

  void setTimezoneMethod(String timezone) =>
      emit(state.copyWith(timezone: timezone));

  void setAlarmBefore(int alarmBefore) =>
      emit(state.copyWith(alarmBefore: alarmBefore));

  void setAsrMethod(String asrMethod) =>
      emit(state.copyWith(asrMethod: asrMethod));

  void setIsAutoShutdown(bool isAutoShutdown) =>
      emit(state.copyWith(isAutoShutdown: isAutoShutdown));

  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    return SettingsState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    return state.toMap();
  }
}
