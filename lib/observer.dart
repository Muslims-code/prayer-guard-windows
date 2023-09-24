import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:bloc/bloc.dart';
import 'package:path_provider/path_provider.dart';

/// {@template counter_observer}
/// [BlocObserver] for the counter application which
/// observes all state changes.
/// {@endtemplate}
class Observer extends BlocObserver {
  /// {@macro counter_observer}
  const Observer();

  // @override
  // void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
  //   super.onChange(bloc, change);
  //   // ignore: avoid_print
  //   print('${bloc.runtimeType} $change');
  // }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) async {
    print('onError -- ${bloc.runtimeType}, $error');
    final path = Directory(
        "${(await getApplicationDocumentsDirectory()).path}/prayer_guard");
    final errorString =
        "${DateFormat.Hm().format(DateTime.now())}$error $stackTrace \n";
    final file = File("${path.path}/errors.txt");
    file.writeAsStringSync(errorString, mode: FileMode.append);
    super.onError(bloc, error, stackTrace);
  }
}
