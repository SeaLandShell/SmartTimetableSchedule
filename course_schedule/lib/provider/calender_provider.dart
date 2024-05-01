
import 'package:course_schedule/utils/event_util.dart';
import 'package:flutter/material.dart';

class CalendarProvider extends ChangeNotifier {

  Map<DateTime, List<Event>> _kEventSource={
    DateTime.utc(2024, 4, 29): [
      Event('Event 10 | 1'),
      Event('Event 10 | 2'),
      Event('Event 10 | 3'),
    ],
    DateTime.utc(2024, 4, 30): [
      Event('Event 15 | 1'),
      Event('Event 15 | 2'),
      Event('Event 15 | 3'),
      Event('Event 15 | 4'),
    ],
  };


  Map<DateTime, List<Event>> get kEventSource => _kEventSource;

  set kEventSource(Map<DateTime, List<Event>> value) {
    _kEventSource = value;
    notifyListeners();
  }



}
