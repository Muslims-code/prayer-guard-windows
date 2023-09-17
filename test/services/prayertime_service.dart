import 'package:prayer_guard_desktop/services/prayertime_service.dart';
import 'package:salat/salat.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  tz.initializeTimeZones();
  String timezone = "Africa/Casablanca"; // Time zone of Mecca (Riyadh)
  DateTime date = DateTime.now().copyWith(hour: 20, minute: 50);
  double longitude = -7.589843; // Longitude of the location
  double latitude = 33.573109;
  Prayers prayers = Prayers(
      date: date,
      timezone: timezone,
      longitude: longitude,
      latitude: latitude,
      method: CalculationMethod.MWL);
  // given a date determine the next prayer ...
  final next = await prayers.nextPrayer();
  final n = DateTime.now().copyWith(hour: 20, minute: 52);
  print(next.keys.first);
  final s = next.values.first.difference(n);
  print(s);
}
