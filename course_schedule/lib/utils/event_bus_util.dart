import 'dart:async'; // 导入异步操作库

import 'package:event_bus/event_bus.dart'; // 导入事件总线库

class EventBusUtil {
  static EventBus? _eventBus; // 私有静态事件总线对象
  static final Map<String, List<StreamSubscription>?> _map = Map(); // 保存事件订阅对象的映射

  // 获取事件总线实例
  static EventBus getInstance() {
    if (_eventBus == null) { // 如果事件总线对象为空
      _eventBus = new EventBus(); // 创建新的事件总线对象
    }
    return _eventBus!; // 返回事件总线对象
  }

  // 订阅事件
  static StreamSubscription<T> listen<T>(String key, void onData(T event)?,
      {Function? onError = _onError}) {
    if (_map[key] == null) { // 如果映射中没有该事件键对应的订阅列表
      _map[key] = []; // 创建一个新的空列表
    }
    final subscription = getInstance().on<T>().listen(onData, onError: onError); // 创建事件的订阅对象
    _map[key]!.add(subscription); // 将订阅对象添加到映射中对应的列表中

    return subscription; // 返回订阅对象
  }

  // 根据键取消所有事件订阅
  static void cancelAllByKey(String key) {
    if (_map[key] != null) { // 如果映射中存在该键对应的订阅列表
      for (var item in _map[key]!) { // 遍历订阅列表
        item.cancel(); // 取消订阅
      }
      _map.remove(key); // 移除映射中的键值对
    }
  }

  // 取消所有事件订阅
  static void cancelAll() {
    _map.forEach((key, value) { // 遍历映射
      if (value != null) { // 如果值不为空
        for (var item in value) { // 遍历值中的订阅对象
          item.cancel(); // 取消订阅
        }
      }
    });
    _map.clear(); // 清空映射
  }
}

void _onError(dynamic error) { // 定义默认的错误处理函数
  print(error); // 打印错误信息
}
