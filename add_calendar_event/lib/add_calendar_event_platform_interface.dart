import 'package:plugin_platform_interface/plugin_platform_interface.dart'; // 导入插件平台接口

import 'add_calendar_event_method_channel.dart'; // 导入基于方法通道的添加日历事件实现类

abstract class AddCalendarEventPlatform extends PlatformInterface {
  // 定义添加日历事件平台接口，继承自PlatformInterface
  /// Constructs a AddCalendarEventPlatform.
  /// 构造一个 AddCalendarEventPlatform 对象
  AddCalendarEventPlatform() : super(token: _token); // 使用给定的token调用父类的构造函数

  static final Object _token = Object(); // 定义一个token对象，用于标识该接口

  static AddCalendarEventPlatform _instance =
      MethodChannelAddCalendarEvent(); // 默认使用基于方法通道的添加日历事件实现类

  /// The default instance of [AddCalendarEventPlatform] to use.
  /// 要使用的 [AddCalendarEventPlatform] 的默认实例。
  ///
  /// Defaults to [MethodChannelAddCalendarEvent].
  /// 默认情况下为 [MethodChannelAddCalendarEvent]。
  static AddCalendarEventPlatform get instance => _instance; // 获取默认的添加日历事件平台实例

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AddCalendarEventPlatform] when
  /// they register themselves.
  /// 平台特定的实现应该在注册时使用自己的特定于平台的类来设置这个值，
  /// 这个类应该是继承自 [AddCalendarEventPlatform] 的。
  static set instance(AddCalendarEventPlatform instance) {
    // 设置添加日历事件平台实例的静态方法
    PlatformInterface.verifyToken(instance, _token); // 验证实例是否符合token
    _instance = instance; // 设置实例
  }

  Future<String?> getPlatformVersion() {
    // 定义获取平台版本信息的抽象方法
    throw UnimplementedError(
        'platformVersion() has not been implemented.'); // 抛出未实现错误
  }
}
