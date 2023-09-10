import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:intl/intl.dart' as ntl;
import 'package:prayer_guard_desktop/cubits/settings_state.dart';
import 'package:salat/salat.dart';

import '../constants.dart';
import '../cubits/settings_cubit.dart';
import '../services/services.dart';

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
  final GeolocatorPlatform geolocatorWindows = GeolocatorPlatform.instance;
  // final Map<String, DateTime> prayersMap = Prayers(
  //         date: DateTime.now(),
  //         timezone: 'Africa/Casablanca',
  //         longitude: geolocatorWindows.getCurrentPosition().longitude,
  //         latitude: 33)
  //     .timesToMapAr();

  @override
  Widget build(BuildContext context) {
    final settingsState = context.read<SettingsCubit>().state;
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
                child: FutureBuilder(
                    future: geolocatorWindows.getCurrentPosition(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final Map<String, DateTime> prayersMap = Prayers(
                                date: DateTime.now(),
                                asrMethod: AsrMethod.values.firstWhere((e) => e.toString() == 'AsrMethod.${settingsState.asrMethod}'),
                                method: CalculationMethod.values.firstWhere((e) => e.toString() == 'CalculationMethod.${settingsState.calculationMethod}'),
                                timezone: settingsState.timezone,
                                longitude: snapshot.data!.longitude,
                                latitude: snapshot.data!.latitude)
                            .timesToMapAr();
                        return Table(
                            border: TableBorder.all(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(6)),
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: prayersMap.entries.map((e) {
                              String formattedTime =
                                  "${ntl.DateFormat.Hm().format(e.value)} ";
                              return Trow(e.key, formattedTime);
                            }).toList());
                      } else {
                        return Center(child: Text("جاري التحميل... "));
                      }
                    }),
              ),
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
              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 20),
              child: Text(
                text1,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )),
          ),
          TableCell(
            child: Center(
                child: Padding(
              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 20),
              child: Text(
                text2,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )),
          ),
        ]);
  }
}
