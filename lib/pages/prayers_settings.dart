import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:intl/intl.dart' as ntl;
import 'package:salat/salat.dart';

import '../constants.dart';
import '../services/services.dart';

class PrayersSettings extends StatefulWidget {
  const PrayersSettings({super.key});

  @override
  State<PrayersSettings> createState() => _PrayersSettingsState();
}

class _PrayersSettingsState extends State<PrayersSettings> {
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
        body: Builder(builder: (BuildContext scaffoldContext) {
          return Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    width: 300,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("تنبيه قبل الأذان ب:"),
                          Container(
                            height: 25,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3)),
                            child: Material(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3)),
                              color: kDeepBlue,
                              child: InkWell(
                                splashColor: kDeepSplashBlue,
                                onTap: () {
                                  Scaffold.of(scaffoldContext).showBottomSheet(
                                      (context) => Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(3)),
                                            height: 100,
                                            child: ListView.builder(itemBuilder: (context,index){

                                            }),
                                          ),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10))),
                                      backgroundColor: kDeepSplashBlue);
                                },
                                child: const Center(
                                  child: Text(
                                    "5 دقائق",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ])),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CloseWindowButton(
                    colors: closeButtonColors,
                    onPressed: () {
                      appWindow.hide();
                    },
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_forward_rounded,
                      )),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
