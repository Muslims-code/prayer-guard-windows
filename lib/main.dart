import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'settings_cubit/settings.dart';
import 'pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

  launchAtStartup.setup(
    appName: packageInfo.appName,
    appPath: Platform.resolvedExecutable,
  );

  
  await launchAtStartup.enable();
  final path = Directory(
      "${(await getApplicationDocumentsDirectory()).path}/prayer_guard");
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: path,
  );

  runApp(const MyApp());
  tz.initializeTimeZones();
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
    return Phoenix(
      child: BlocProvider<SettingsCubit>(
        lazy: false,
        create: (context) => SettingsCubit()..initialize(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'prayer guard',
          theme: ThemeData(useMaterial3: true, fontFamily: "Tajawal"),
          home: const MainPage(),
        ),
      ),
    );
  }
}
