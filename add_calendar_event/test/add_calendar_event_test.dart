import 'package:flutter_test/flutter_test.dart';
import 'package:add_calendar_event/add_calendar_event.dart';
import 'package:add_calendar_event/add_calendar_event_platform_interface.dart';
import 'package:add_calendar_event/add_calendar_event_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAddCalendarEventPlatform
    with MockPlatformInterfaceMixin
    implements AddCalendarEventPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AddCalendarEventPlatform initialPlatform = AddCalendarEventPlatform.instance;

  test('$MethodChannelAddCalendarEvent is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAddCalendarEvent>());
  });

  test('getPlatformVersion', () async {
    AddCalendarEvent addCalendarEventPlugin = AddCalendarEvent();
    MockAddCalendarEventPlatform fakePlatform = MockAddCalendarEventPlatform();
    AddCalendarEventPlatform.instance = fakePlatform;

    expect(await addCalendarEventPlugin.getPlatformVersion(), '42');
  });
}
