import 'add_calendar_event_platform_interface.dart'; // 导入添加日历事件的平台接口
import 'package:flutter/services.dart'; // 导入Flutter的系统服务库，用于与平台通信

class AddCalendarEvent {
  // 获取平台版本信息
  Future<String?> getPlatformVersion() {
    return AddCalendarEventPlatform.instance.getPlatformVersion();
  }

  static const MethodChannel _channel =
      const MethodChannel('add_calendar_event'); // 定义方法通道，用于与原生平台通信

  /// Add an Event (object) to user's default calendar.
  /// 向用户的默认日历中添加事件（对象）。
  static Future<bool> addEventToCal(Event event) {
    return _channel
        .invokeMethod<bool?>('addToCal', event.toMap()) // 调用原生方法通道，传递事件的参数
        .then((value) => value ?? false); // 处理返回值，如果为null则默认为false
  }

  /// Add a list of events to user's default calendar.
  /// 向用户的默认日历中添加一系列事件。
  static Future<int> addEventListToCal(List<Event> list) {
    return _channel
        .invokeMethod<int?>('addEventListToCal',
            list.map((e) => e.toMap()).toList()) // 调用原生方法通道，传递事件列表的参数
        .then((value) => value ?? 0); // 处理返回值，如果为null则默认为0
  }

  /// Delete calendar events by description.
  /// 通过描述删除日历事件。
  static Future<int> deleteCalEventByDesc(String desc) {
    return _channel.invokeMethod<int?>('deleteCalEventByDesc',
            <String, dynamic>{'desc': desc}) // 调用原生方法通道，传递描述参数
        .then((value) => value ?? 0); // 处理返回值，如果为null则默认为0
  }
}

/// Class that holds each event's info.
/// 包含每个事件信息的类。
class Event {
  String title, description, location;
  DateTime startDate, endDate;
  Duration? alarmInterval; // 在iOS中，可以设置警报通知的持续时间

  Event({
    required this.title, // 事件标题
    this.description = '', // 事件描述，默认为空字符串
    this.location = '', // 事件位置，默认为空字符串
    required this.startDate, // 事件开始时间
    required this.endDate, // 事件结束时间
    this.alarmInterval, // 警报通知的持续时间
  });

  // 将事件转换为Map类型，用于原生平台方法通道的参数传递
  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "desc": description,
      "location": location,
      "startDate": startDate.millisecondsSinceEpoch, // 将开始时间转换为毫秒
      "endDate": endDate.millisecondsSinceEpoch, // 将结束时间转换为毫秒
      "alarmInterval": alarmInterval?.inSeconds.toInt() // 将警报通知持续时间转换为秒
    };
  }
}
//AddCalendarEvent 类提供了添加、删除日历事件的静态方法，并通过方法通道与原生平台通信。
// Event 类用于表示每个事件的信息，包括标题、描述、位置、开始时间、结束时间和警报通知的持续时间。
// toMap() 方法用于将 Event 对象转换为Map类型，以便在方法通道中传递参数给原生平台。