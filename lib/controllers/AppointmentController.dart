import 'package:babivision/Utils/Time.dart';

class AppointmentController {
  final int serviceTime;
  final String openTime;
  final String closeTime;
  final Map<String, dynamic> appointments;
  final Set<String> workdays;

  late Map<String, Map> _appointmentDays;
  late Map<String, List> _opticians;
  late Map _opticianAvailability;
  late List<String> _optician_ids;

  AppointmentController({
    required this.serviceTime,
    required this.openTime,
    required this.closeTime,
    required this.workdays,
    required this.appointments,
  }) {
    _appointmentDays = this.appointments['appointments'];
    _opticians = this.appointments['optician_info'];
    _optician_ids = this.appointments['optician_info']!.keys.toList();
    _opticianAvailability = {};
  }

  Map<String, Set<String>> _getGaps(String day) {
    Map<String, Set<String>> result = {};
    final appointmentsDaily = _appointmentDays?[day] ?? {day: {}};
    //result[day] = {};
    _optician_ids.forEach((optician_id) {
      List<Map<String, dynamic>>? opticianAppointments =
          appointmentsDaily?['$optician_id'];
      Map<String, dynamic> optician = _opticians!['$optician_id']![0];
      String shift_start = optician!['shift_start'].substring(0, 5);
      String shift_end = optician!['shift_end'].substring(0, 5);
      result[optician_id] = _availableSlots(
        _timeGaps(opticianAppointments, shift_start, shift_end),
      );
    });
    return result;
  }

  List<Map<String, dynamic>> allAvailableAppointments(
    String day, {
    int upto = 1,
  }) {
    List<Map<String, dynamic>> result = [];
    for (int i = 0; i < upto; ++i) {
      print(day);
      print(Time.dayFromYMD(day));
      if (!workdays.contains(Time.dayFromYMD(day))) {
        day = Time.addDays(day, 1);
        continue;
      }
      Set<String> appointments = {};
      Map<String, Set<String>> gaps = _getGaps(day);
      _opticianAvailability[day] = gaps;
      //print(gaps);
      _optician_ids.forEach((optician_id) {
        appointments.addAll(gaps[optician_id]!);
      });
      if (!appointments.isEmpty)
        result.add({
          "day": day,
          "displayDate": Time.displayFullDate(day),
          "appointments": appointments.toList()..sort(),
        });
      day = Time.addDays(day, 1);
    }
    return result;
  }

  String? bookOptician(String day, String time) {
    for (final id in _optician_ids) {
      final currentOptician = _opticianAvailability[day]?[id];
      if (currentOptician != null && currentOptician.contains(time)) return id;
    }
    return null;
  }

  List<Map<String, int>> _timeGaps(
    List<Map<String, dynamic>>? opticianAppointments,
    String shift_start,
    String shift_end,
  ) {
    opticianAppointments ??= [
      {'start_time': shift_start, 'end_time': shift_start},
    ];
    String? time_end = shift_start;
    String? time_start = shift_start;
    int diff = 0;
    List<Map<String, int>> result = [];
    opticianAppointments.forEach((appointment) {
      time_start = appointment["start_time"]?.substring(0, 5);
      if (time_end != null) {
        diff = Time.difference(time_start!, time_end!);
      }
      if (diff > 0) result.add({time_end!: diff});
      time_end = appointment['end_time']?.substring(0, 5);
    });
    diff = Time.difference(shift_end, time_end!);
    if (diff > 0) result.add({time_end!: diff});
    return result;
  }

  Set<String> _availableSlots(List<Map<String, int>> gaps) {
    Set<String> result = {};
    gaps.forEach((gap) {
      String time = gap.keys.first;
      int timeGap = gap[time]!;
      int iterations = timeGap ~/ serviceTime;
      for (int i = 0; i < iterations; ++i) {
        result.add(time);
        time = Time.addMinutes(time, serviceTime);
      }
    });
    return result;
  }
}
