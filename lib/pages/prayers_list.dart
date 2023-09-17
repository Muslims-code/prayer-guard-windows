import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as ntl;

import 'package:prayer_guard_desktop/constants.dart';
import 'package:prayer_guard_desktop/settings_cubit/settings.dart';

class PrayersList extends StatefulWidget {
  const PrayersList({super.key});

  @override
  State<PrayersList> createState() => _PrayersListState();
}

class _PrayersListState extends State<PrayersList> {
  final closeButtonColors = WindowButtonColors(
      mouseOver: const Color(0xFFD32F2F),
      mouseDown: const Color(0xFFB71C1C),
      iconNormal: Colors.black,
      normal: const Color(0xffC0D1DD));

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SettingsCubit>().state;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: kShallowBlue,
        body: Stack(
          children: [
            Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 200,
                  child: Builder(builder: (context) {
                    if (state.prayers == null) {
                      return const Center(child: Text("جاري التحميل... "));
                    } else {
                      return Table(
                          border: TableBorder.all(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(6)),
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: context
                              .watch<SettingsCubit>()
                              .state
                              .prayers!
                              .timesToMapAr()
                              .entries
                              .map((e) {
                            String formattedTime =
                                "${ntl.DateFormat.Hm().format(e.value)} ";
                            return Trow(e.key, formattedTime);
                          }).toList());
                    }
                  }),
                )),
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
                    icon: const Icon(
                      Icons.arrow_forward_rounded,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow Trow(String text1, String text2) {
    return TableRow(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: kDeepBlue,
        ),
        children: [
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.top,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
              child: Text(
                text1,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            )),
          ),
          TableCell(
            child: Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
              child: Text(
                text2,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            )),
          ),
        ]);
  }
}
