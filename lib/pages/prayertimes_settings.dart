import 'package:flutter/material.dart';
import '../constants.dart';

class PrayerTimeNSettings extends StatefulWidget {
  const PrayerTimeNSettings({super.key});

  @override
  State<PrayerTimeNSettings> createState() => _PrayerTimeNSettingsState();
}

class _PrayerTimeNSettingsState extends State<PrayerTimeNSettings> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          width: 200,
          height: 90,
          child: Table(
            border: TableBorder.all(
                color: Colors.black, borderRadius: BorderRadius.circular(6)),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: kDeepBlue,
                  ),
                  children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.top,
                      child: Center(
                          child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 20),
                        child: Text(
                          "الصلاة",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.top,
                      child: Center(
                          child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 20),
                        child: Text(
                          "الموعد",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )),
                    ),
                  ]),
            ],
          ),
        ),
        // body: Column(
        //   children: [
        //     Row(
        //       children: [
        //         Container(
        //           decoration: const BoxDecoration(color: kDeepBlue),
        //           child: Text("الإعدادات"),
        //         ),
        //         Container(
        //           decoration: const BoxDecoration(color: kDeepBlue),
        //           child: Text("الإعدادات"),
        //         ),
        //       ],
        //     ),
        //     Row(
        //       children: [

        //       ],
        //     )
        //   ],
        // ),
      ),
    );
  }
}
