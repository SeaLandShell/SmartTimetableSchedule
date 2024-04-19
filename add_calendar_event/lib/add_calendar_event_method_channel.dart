import 'package:flutter/foundation.dart'; // 导入flutter的foundation库，包含了一些基础工具类和函数
import 'package:flutter/services.dart'; // 导入flutter的services库，用于与平台通信

import 'add_calendar_event_platform_interface.dart'; // 导入添加日历事件的平台接口

/// An implementation of [AddCalendarEventPlatform] that uses method channels.
/// 使用方法通道实现的 [AddCalendarEventPlatform] 接口实现。
class MethodChannelAddCalendarEvent extends AddCalendarEventPlatform {
  /// The method channel used to interact with the native platform.
  /// 用于与原生平台交互的方法通道。
  @visibleForTesting
  final methodChannel =
      const MethodChannel('add_calendar_event'); // 定义一个方法通道，用于与原生代码通信

  @override
  Future<String?> getPlatformVersion() async {
    // 实现获取平台版本信息的方法
    final version = await methodChannel.invokeMethod<String>(
        'getPlatformVersion'); // 调用方法通道的invokeMethod方法，获取平台版本信息
    return version; // 返回平台版本信息
  }
}
