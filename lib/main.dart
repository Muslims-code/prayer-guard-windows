import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezone/timezone.dart';

import 'cubits/settings_cubit.dart';
import 'pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  runApp(const MyApp());
  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(450, 150);
    win.minSize = initialSize;
    win.maxSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.bottomRight;
    win.title = "Prayer Guard";
    win.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsCubit>(
      create: (context) => SettingsCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'prayer guard',
        theme: ThemeData(useMaterial3: true, fontFamily: "Tajawal"),
        home: const AlertPopUp(),
      ),
    );
  }
}
