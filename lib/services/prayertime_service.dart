// ignore_for_file: public_member_api_docs, sort_constructors_first

// import 'package:geolocator/geolocator.dart';
import 'package:salat/salat.dart';

class Prayers {
  final DateTime _date;
  final String _timezone;
  final double _longitude;
  final double _latitude;
  final CalculationMethod _method;
  final AsrMethod _asrMethod ;
  late DateTime fajr;
  late DateTime dhuhr;
  late DateTime asr;
  late DateTime maghrib;
  late DateTime isha;
  Prayers({
    required DateTime date,
    required String timezone,
    required double longitude,
    required double latitude,
    CalculationMethod method = CalculationMethod.MWL,
    AsrMethod asrMethod = AsrMethod.STANDARD,
  })  : _latitude = latitude,
        _longitude = longitude,
        _timezone = timezone,
        _method = method,
        _asrMethod = asrMethod,
        _date = date {
    final pt = prayerTimes(method: method,asr: asrMethod);
    final times = pt.calcTime(
      date: _date,
      timezone: _timezone,
      longitude: _longitude,
      latitude: _latitude,
    );
    fajr = times['fajr']!;
    dhuhr = times['dhuhr']!;
    asr = times['asr']!;
    maghrib = times['maghrib']!;
    isha = times['isha']!;
  }

  // determines the next prayer
  Future<Map<String, DateTime>> nextPrayer() async {
    final pt = prayerTimes(method: _method,asr: _asrMethod);
    final times = pt.calcTime(
      date: _date,
      timezone: _timezone,
      longitude: _longitude,
      latitude: _latitude,
    );
    final prayersList = times.entries.indexed;
    Map<String, DateTime> next = {};
    DateTime now = _date;
    for (int i = 0; i < prayersList.length; i++) {
      final element = prayersList.elementAt(i);
      final index = element.$1;

      // next prayer : fajr (now < fajr)
      if (now.isBefore(prayersList.elementAt(0).$2.value)) {
        final entry = prayersList.elementAt(0).$2;
        next = {entry.key: entry.value};
        break;
      }
      // next prayer : fajr (isha < now)
      else if (now
          .isAfter(prayersList.elementAt(prayersList.length - 1).$2.value)) {
        final entry = prayersList.elementAt(0).$2;
        next = {entry.key: entry.value};

        break;
      }
      // framing
      else if (now.isAfter(element.$2.value) &&
          now.isBefore(prayersList.elementAt(index + 1).$2.value)) {
        final entry = prayersList.elementAt(index + 1).$2;
        next = {entry.key: entry.value};
        break;
      }
    }
    return next;
  }

  @override
  String toString() {
    return 'Prayers(Fajr: $fajr, Dhuhr: $dhuhr, Asr: $asr, Maghrib: $maghrib, Isha: $isha)';
  }

  // describing itself :)
  Map<String, DateTime> timesToMap() {
    return <String, DateTime>{
      'fajr': fajr,
      'dhuhr': dhuhr,
      'asr': asr,
      'maghrib': maghrib,
      'isha': isha,
    };
  }
    Map<String, DateTime> timesToMapAr() {
    return <String, DateTime>{
      'الفجر': fajr,
      'الظهر': dhuhr,
      'العصر': asr,
      'المغرب': maghrib,
      'العشاء': isha,
    };
  }
}

void main(List<String> args) async {
  void sleep(DateTime first, DateTime next) async {
    await Future.delayed(next.difference(first));
  }
}
