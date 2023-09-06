import 'package:flutter/material.dart';
import 'package:prayer_guard_desktop/cubits/settings_cubit.dart';
import 'package:prayer_guard_desktop/pages/prayers_settings.dart';
import 'dart:async';
import 'dart:io';
import 'prayers_list.dart';
import 'package:system_tray/system_tray.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:prayer_guard_desktop/widgets/widgets.dart';
import '../constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertPopUp extends StatefulWidget {
  const AlertPopUp({super.key});

  @override
  State<AlertPopUp> createState() => _AlertPopUpState();
}

String getTrayImagePath(String imageName) {
  return Platform.isWindows ? 'assets/$imageName.ico' : 'assets/$imageName.png';
}

class _AlertPopUpState extends State<AlertPopUp> {
  final AppWindow _appWindow = AppWindow();
  final SystemTray _systemTray = SystemTray();
  final Menu _menuMain = Menu();

  @override
  void initState() {
    super.initState();
    initSystemTray();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initSystemTray() async {
    await _systemTray.initSystemTray(iconPath: getTrayImagePath('app_icon'));
    _systemTray.setTitle("Prayer Guard");
    _systemTray.setToolTip("protecting your prayers...");

    _systemTray.registerSystemTrayEventHandler((eventName) {
      debugPrint("eventName: $eventName");
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
              padding: const EdgeInsets.all(12),
              child: Text(
                "موعد صلاة العشاء بعد 5 دقائق استعد لتأديتها، توضأ و تأهب لملاقاة ربك",
                style: TextStyle(fontSize: 20, color: kDeepBlue),
              ),
            ),
            Row(
              children: [
                GreenButton(
                  text: 'إيقاف تشغيل الكمبيوتر',
                  onPressed: () {},
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
                            builder: (context) =>
                                 PrayersSettings()));
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
