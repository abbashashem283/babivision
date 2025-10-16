import 'package:babivision/Utils/Time.dart';
import 'package:flutter/material.dart';

class AppointmentManager {
  final int serviceTime;
  final String openTime;
  final String closeTime;
  final Map<String, dynamic>? appointments;
  final Set<String> workdays;

  late Map<String, dynamic>? _appointmentDays;
  late Map<String, dynamic> _opticians;
  late Map _opticianAvailability;
  late List<String> _optician_ids;

  AppointmentManager({
    required this.serviceTime,
    required this.openTime,
    required this.closeTime,
    required this.workdays,
    required this.appointments,
  }) {
    _appointmentDays = this.appointments?['appointments'] ?? {};
    _opticians = this.appointments!['optician_info'];
    _optician_ids = this.appointments!['optician_info']!.keys.toList();
    _opticianAvailability = {};
  }

  Map<String, dynamic>? _getGaps(String day) {
    Map<String, Set<String>> result = {};
    final appointmentsDaily = _appointmentDays?[day] ?? {day: {}};
    //result[day] = {};
    _optician_ids.forEach((optician_id) {
      List<dynamic>? opticianAppointments = appointmentsDaily?['$optician_id'];
      Map<String, dynamic> optician = _opticians!['$optician_id']![0];
      String shift_start = optician!['shift_start'].substring(0, 5);
      String shift_end = optician!['shift_end'].substring(0, 5);
      debugPrint(
        'optician appointments for $optician_id at $day are ${opticianAppointments.toString()}',
      );
      debugPrint(
        "time gaps for $optician_id at $day ${_timeGaps(opticianAppointments, shift_start, shift_end)}",
      );
      result[optician_id] = _availableSlots(
        _timeGaps(opticianAppointments, shift_start, shift_end),
      );
    });
    //debugPrint(result.toString());
    return result;
  }

  List<dynamic> allAvailableAppointments(
    String day, {
    int upto = 1,
    String? day0Time,
  }) {
    List<dynamic> result = [];

    for (int i = 0; i < upto; ++i) {
      //print(day);
      //print(Time.dayFromYMD(day));
      //debugPrint("today is ${Time.displayFullDate(day)} and i=$i");
      if (!workdays.contains(Time.dayFromYMD(day))) {
        day = Time.addDays(day, 1);
        --i;
        continue;
      }

      Set<String> appointments = {};

      Map<String, dynamic>? gaps = _getGaps(day);

      if (gaps == null) break;

      debugPrint("gaps for day $day -> ${gaps.toString()}");

      _opticianAvailability[day] = gaps;
      ////print(gaps);
      _optician_ids.forEach((optician_id) {
        appointments.addAll(gaps[optician_id]!);
      });
      // debugPrint(
      //   'all available appoointments on $day unfiltered ${appointments.toString()}',
      // );
      if (day0Time != null && day == Time.today.day)
        appointments =
            appointments
                .where(
                  (appointment) => Time.compare(day0Time, appointment, '<'),
                )
                .toSet();

      if (!appointments.isEmpty) {
        result.add({
          "day": day,
          "displayDate":
              day == Time.today.day
                  ? "Today"
                  : day == Time.addDays(Time.today.day, 1)
                  ? "Tomorrow"
                  : Time.displayFullDate(day),
          "appointments": appointments.toList()..sort(),
        });
      } else {
        --i;
      }
      day = Time.addDays(day, 1);
    }
    return result;
  }

  Future<List<dynamic>> allAvailableAppointmentsAsync(
    String day, {
    int upto = 1,
    String? day0Time,
  }) async {
    return allAvailableAppointments(day, upto: upto, day0Time: day0Time);
  }

  String? bookOptician(String day, String time) {
    for (final id in _optician_ids) {
      final currentOptician = _opticianAvailability[day]?[id];
      if (currentOptician != null && currentOptician.contains(time)) return id;
    }
    return null;
  }

  List<Map<String, int>> _timeGaps(
    List<dynamic>? opticianAppointments,
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
    if (diff > 0) {
      result.add({time_end!: diff});
    }
    //debugPrint("time gaps ${result.toString()}");
    return result;
  }

  Set<String> _availableSlots(List<Map<String, int>> gaps) {
    Set<String> result = {};
    //debugPrint("gapz ${gaps.toString()}");
    gaps.forEach((gap) {
      String time = gap.keys.first;
      int timeGap = gap[time]!;
      int iterations = timeGap ~/ serviceTime;
      for (int i = 0; i < iterations; ++i) {
        //debugPrint("timo $time");
        result.add(time);
        time = Time.addMinutes(time, serviceTime);
      }
    });
    //debugPrint("gapo $result");
    return result;
  }
}
