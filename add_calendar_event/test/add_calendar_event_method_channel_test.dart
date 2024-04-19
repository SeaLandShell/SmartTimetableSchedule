import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:add_calendar_event/add_calendar_event_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelAddCalendarEvent platform = MethodChannelAddCalendarEvent();
  const MethodChannel channel = MethodChannel('add_calendar_event');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
