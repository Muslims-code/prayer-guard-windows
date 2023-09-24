import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prayer_guard_desktop/pages/pages.dart';
import 'dart:async';
import 'dart:io';
import 'package:prayer_guard_desktop/settings_cubit/settings.dart';
import 'package:system_tray/system_tray.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:prayer_guard_desktop/widgets/widgets.dart';
import '../constants.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

String getTrayImagePath(String imageName) {
  return Platform.isWindows ? 'assets/$imageName.ico' : 'assets/$imageName.png';
}

class _MainPageState extends State<MainPage> {
  final AppWindow _appWindow = AppWindow();
  final SystemTray _systemTray = SystemTray();
  final Menu _menuMain = Menu();

  @override
  void initState() {
    super.initState();
    initSystemTray();
  }


  Future<void> initSystemTray() async {
    await _systemTray.initSystemTray(iconPath: getTrayImagePath('prayer_guard_logo'));
    _systemTray.setTitle("Prayer Guard");
    _systemTray.setToolTip("protecting your prayers...");

    _systemTray.registerSystemTrayEventHandler((eventName) {
      // debugPrint("eventName: $eventName");
      if (eventName == kSystemTrayEventClick) {
        Platform.isWindows ? _appWindow.show() : _systemTray.popUpContextMenu();
      } else if (eventName == kSystemTrayEventRightClick) {
        Platform.isWindows ? _systemTray.popUpContextMenu() : _appWindow.show();
      }
    });

    _systemTray.setContextMenu(_menuMain);
  }

  final closeButtonColors = WindowButtonColors(
      mouseOver: const Color(0xFFD32F2F),
      mouseDown: const Color(0xFFB71C1C),
      iconNormal: Colors.black,
      normal: const Color(0xffC0D1DD));

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: kShallowBlue,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CloseWindowButton(
                  colors: closeButtonColors,
                  onPressed: () {
                    appWindow.hide();
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: BlocBuilder<SettingsCubit, SettingsState>(
                
                  builder: (context, state) {
                if (state.minutesUntilNextPrayer == null) {
                  return const Center(child: Text("جاري التحميل... "));
                }
                final minutesUntilNextPrayer =
                    state.minutesUntilNextPrayer!.inMinutes;
                final mins =
                    "$minutesUntilNextPrayer ${minutesUntilNextPrayer > 10 ? "دقيقة" : "دقائق"}";
                return Text(
                  "موعد صلاة ${state.nextPrayer!.keys.first} بعد $mins استعد لتأديتها، توضأ و تأهب لملاقاة ربك",
                  style: const TextStyle(fontSize: 20, color: kDeepBlue),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  GreenButton(
                    text: 'إيقاف تشغيل الكمبيوتر',
                    onPressed: () async {
                      await Process.run('rundll32.exe',
                          ['powrprof.dll,SetSuspendState', 'Sleep']);
                    },
                  ),
                  BlueIconButton(
                    icon: Icons.list,
                    text: "الصلوات",
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const PrayersList()));
                    },
                  ),
                  BlueIconButton(
                    icon: Icons.settings,
                    text: "الإعدادات",
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const PrayersSettings()));
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
