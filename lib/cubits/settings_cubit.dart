import 'package:bloc/bloc.dart';
import 'package:prayer_guard_desktop/cubits/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
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
}
