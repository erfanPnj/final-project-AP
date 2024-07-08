import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calendar extends StatefulWidget {
  // dayofweek@starthour@startminute
  // Map<String, String> Khak = {};
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  Map<String, String> Khak = {};
  @override
  void initState() {
    super.initState();
    Khak["Dif"] = "1@9@0";
    Khak["Math"] = "2@10@30";
    Khak["Fizik"] = "4@12@0";
    Khak["Riazi"] = "2@15@0";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 50),
        child: SfCalendar(
          view: CalendarView.week,
          firstDayOfWeek: 6,
          dataSource: MeetingDataSource(getAppointments(Khak)),
        ),
      ),
    );
  }
}

List<Appointment> getAppointments(Map<String, String> Eyvay) {
  List<Appointment> meeting = <Appointment>[];
  for (var myClass in Eyvay.keys.toList()) {
    var x = Eyvay[myClass]!.split("@");
    final DateTime today = DateTime.now();
    final DateTime start = DateTime(today.year, today.month, int.parse(x[0]),
        int.parse(x[1]), int.parse(x[2]), 0);
    final DateTime end = start.add(const Duration(hours: 1, minutes: 30));
    meeting.add(Appointment(startTime: start, endTime: end, subject: myClass));
  }
  return meeting;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
