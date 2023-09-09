import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salat/salat.dart';
import 'package:timezone/timezone.dart';
import '../constants.dart';

import '../cubits/settings_cubit.dart';

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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: kShallowBlue,
        body: Builder(builder: (BuildContext scaffoldContext) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                width: 440,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        InputDropDown(
                          dropIndex: 0,
                          scaffoldContext: scaffoldContext,
                          label: "تنبيه قبل الأذان ب:",
                          elements: const [
                            "5 دقائق",
                            "10 دقائق",
                            "15 دقيقة",
                            "20 دقيقة",
                            "25 دقيقة",
                            "30 دقيقة",
                          ],
                        ),
                        InputDropDown(
                          dropIndex: 1,
                          scaffoldContext: scaffoldContext,
                          label: "طريقة الحساب:",
                          elements: CalculationMethod.values
                              .map((e) => e.toString().split(".")[1])
                              .toList(),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        InputDropDown(
                          dropIndex: 2,
                          scaffoldContext: scaffoldContext,
                          label: "التوقيت المحلي:",
                          elements: timeZoneDatabase.locations.entries.map((e) {
                            return e.key;
                          }).toList(),
                        ),
                        InputDropDown(
                          dropIndex: 3,
                          scaffoldContext: scaffoldContext,
                          label: " طريقة حساب العصر:",
                          elements: AsrMethod.values
                              .map((e) => e.toString().split(".")[1])
                              .toList(),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.all(kDeepBlue),
                    value: context.watch<SettingsCubit>().state.isAutoShutdown,
                    onChanged: (v) {
                      context.read<SettingsCubit>().setIsAutoShutdown(v!);
                    }),
                Text(
                  "تفعيل الإيقاف التلقائي للحاسوب",
                  style: const TextStyle(fontSize: 12),
                ),
              ])
            ],
          );
        }),
      ),
    );
  }
}

class InputDropDown extends StatelessWidget {
  final BuildContext scaffoldContext;
  final String label;
  final List<String> elements;
  final int dropIndex;
  const InputDropDown({
    super.key,
    required this.label,
    required this.dropIndex,
    required this.scaffoldContext,
    required this.elements,
  });

  String currentInput(BuildContext context) {
    if (dropIndex == 0) {
      final alarmBefore = context.watch<SettingsCubit>().state.alarmBefore;
      return "${alarmBefore} ${alarmBefore > 10 ? "دقيقة" : "دقائق"}";
    }
    if (dropIndex == 1) {
      return context.watch<SettingsCubit>().state.calculationMethod;
    }
    if (dropIndex == 2) {
      return context.watch<SettingsCubit>().state.timezone;
    } else {
      return context.watch<SettingsCubit>().state.asrMethod;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        label,
        style: TextStyle(fontSize: 12),
      ),
      Container(
        height: 20,
        width: 200,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
        child: Material(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          color: kDeepBlue,
          child: InkWell(
            splashColor: kDeepSplashBlue,
            onTap: () {
              Scaffold.of(scaffoldContext).showBottomSheet(
                  (context) => Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3)),
                        height: 100,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return Center(
                              child: ListTile(
                                visualDensity: const VisualDensity(
                                    vertical: -4), // to compact
                                onTap: () {
                                  if (dropIndex == 0) {
                                    context
                                        .read<SettingsCubit>()
                                        .setAlarmBefore(int.parse(
                                            elements[index]
                                                .replaceAll("دقائق", "")
                                                .replaceAll("دقيقة", "")
                                                .replaceAll(" ", "")));
                                  }
                                  if (dropIndex == 1) {
                                    context
                                        .read<SettingsCubit>()
                                        .setCalculationMethod(elements[index]);
                                  }
                                  if (dropIndex == 2) {
                                    context
                                        .read<SettingsCubit>()
                                        .setTimezoneMethod(elements[index]);
                                  }
                                  if (dropIndex == 3) {
                                    context
                                        .read<SettingsCubit>()
                                        .setAsrMethod(elements[index]);
                                  }
                                  Navigator.pop(context);
                                },
                                title: Text(
                                  elements[index],
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            );
                          },
                          itemCount: elements.length,
                        ),
                      ),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  backgroundColor: Colors.white);
            },
            child: Center(
              child: Text(
                currentInput(context),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      )
    ]);
  }
}
