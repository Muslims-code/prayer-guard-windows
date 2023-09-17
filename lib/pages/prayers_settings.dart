import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:salat/salat.dart';
import 'package:timezone/timezone.dart';

import 'package:prayer_guard_desktop/constants.dart';
import 'package:prayer_guard_desktop/settings_cubit/settings.dart';

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
                      onPressed: () async {
                        Phoenix.rebirth(context);
                      },
                      icon: const Icon(
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
                const Text(
                  "تفعيل الإيقاف التلقائي للحاسوب",
                  style: TextStyle(fontSize: 12),
                ),
              ])
            ],
          );
        }),
      ),
    );
  }
}

class InputDropDown extends StatefulWidget {
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

  @override
  State<InputDropDown> createState() => _InputDropDownState();
}

class _InputDropDownState extends State<InputDropDown> {
  String currentInput(BuildContext context) {
    if (widget.dropIndex == 0) {
      final alarmBefore = context.watch<SettingsCubit>().state.alarmBefore;
      return "$alarmBefore ${alarmBefore > 10 ? "دقيقة" : "دقائق"}";
    }
    if (widget.dropIndex == 1) {
      return context.watch<SettingsCubit>().state.calculationMethod;
    }
    if (widget.dropIndex == 2) {
      return context.watch<SettingsCubit>().state.timezone;
    } else {
      return context.watch<SettingsCubit>().state.asrMethod;
    }
  }

  List<String> matchQuery = [];

  @override
  void initState() {
    matchQuery = List<String>.from(widget.elements);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        widget.label,
        style: const TextStyle(fontSize: 12),
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
              Scaffold.of(widget.scaffoldContext).showBottomSheet(
                  (context) =>
                      StatefulBuilder(builder: (context, StateSetter setState) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3)),
                          height: 100,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                height: 50,
                                child: TextField(
                                  onChanged: (v) {
                                    matchQuery.clear();

                                    setState(() {
                                      for (var element in widget.elements) {
                                        if (element
                                            .toLowerCase()
                                            .contains(v.toLowerCase())) {
                                          matchQuery.add(element);
                                        }
                                      }
                                    });
                                  },

                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xFFFFFFFF),
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    /* -- Text and Icon -- */
                                    hintText: "بحث ...",
                                    hintStyle: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFFB3B1B1),
                                    ), // TextStyle
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      size: 15,
                                      color: Colors.black54,
                                    ),
                                    // Icon
                                    /* -- Border Styling -- */
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFFF0000),
                                      ), // BorderSide
                                    ), // OutlineInputBorder
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: const BorderSide(
                                        color: kDeepBlue,
                                      ), // BorderSide
                                    ), // OutlineInputBorder
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: const BorderSide(
                                        color: kDeepBlue,
                                      ), // BorderSide
                                    ), // OutlineInputBorder
                                  ), // InputDecoration
                                ),
                              ), // Te
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Center(
                                      child: ListTile(
                                        visualDensity: const VisualDensity(
                                            vertical: -4), // to compact
                                        onTap: () {
                                          if (widget.dropIndex == 0) {
                                            context
                                                .read<SettingsCubit>()
                                                .setAlarmBefore(int.parse(
                                                    matchQuery[index]
                                                        .replaceAll("دقائق", "")
                                                        .replaceAll("دقيقة", "")
                                                        .replaceAll(" ", "")));
                                          }
                                          if (widget.dropIndex == 1) {
                                            context
                                                .read<SettingsCubit>()
                                                .setCalculationMethod(
                                                    matchQuery[index]);
                                          }
                                          if (widget.dropIndex == 2) {
                                            context
                                                .read<SettingsCubit>()
                                                .setTimezoneMethod(
                                                    matchQuery[index]);
                                          }
                                          if (widget.dropIndex == 3) {
                                            context
                                                .read<SettingsCubit>()
                                                .setAsrMethod(
                                                    matchQuery[index]);
                                          }
                                          Navigator.pop(context);
                                        },
                                        title: Text(
                                          matchQuery[index],
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: matchQuery.length,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
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
