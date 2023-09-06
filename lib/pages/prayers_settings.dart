import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                    child: InputDropDown(
                      scaffoldContext: scaffoldContext,
                      label: "تنبيه قبل الأذان ب:",
                      elements: [
                        "5 دقائق",
                        "10 دقائق",
                        "15 دقائق",
                        "20 دقائق",
                        "25 دقائق",
                        "30 دقائق",
                      ],
                    )),
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

class InputDropDown extends StatelessWidget {
  final BuildContext scaffoldContext;
  final String label;
  final List<String> elements;
  const InputDropDown({
    super.key,
    required this.label,
    required this.scaffoldContext,
    required this.elements,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label),
      Container(
        height: 25,
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
                              context
                                  .read<SettingsCubit>()
                                  .setAlarmBefore(int.parse(
                                      elements[index]
                                          .replaceAll("دقائق", "")
                                          .replaceAll(" ", "")));
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
                "${context.watch<SettingsCubit>().state.alarmBefore} دقائق",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      )
    ]);
  }
}
