import 'package:timezone/timezone.dart' as tz1;
import 'package:timezone/data/latest.dart' as tz;

class TimeUtils {
  static final tz1.Location berlin = tz1.getLocation('Europe/Berlin');

  TimeUtils() {
    tz.initializeTimeZones();
  }
 
  tz1.TZDateTime nowBerlin() {
    return tz1.TZDateTime.now(berlin);
  }
}