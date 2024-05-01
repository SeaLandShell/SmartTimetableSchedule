export 'event_util.dart';
// 版权声明
// SPDX-License-Identifier: Apache-2.0

// 引入dart:collection库，用于使用LinkedHashMap
import 'dart:collection';

// 引入table_calendar.dart文件，用于构建日历组件
import 'package:table_calendar/table_calendar.dart';

/// 示例事件类。
class Event {
  final String title;

  const Event(this.title);

  Map<String, dynamic> toJson() {
    return {
      'title': title,
    };
  }
  @override
  String toString() => title;
}

/// 示例事件列表。
///
/// 如果决定使用Map，则强烈建议使用LinkedHashMap。
/// 如果您决定使用 Map，我建议将其设为 LinkedHashMap- 这将允许您覆盖两个DateTime对象的相等比较，仅通过日期部分比较它们：
// final kEvents = LinkedHashMap<DateTime, List<Event>>(
//   equals: isSameDay, // 判断两个日期是否是同一天
//   hashCode: getHashCode, // 获取日期的哈希码
// )..addAll(_kEventSource);
//
// Map<DateTime, List<Event>> _kEventSource={
//   DateTime.utc(2024, 4, 29): [
//     Event('Event 10 | 1'),
//     Event('Event 10 | 2'),
//     Event('Event 10 | 3'),
//   ],
//   DateTime.utc(2024, 4, 30): [
//     Event('Event 15 | 1'),
//     Event('Event 15 | 2'),
//     Event('Event 15 | 3'),
//     Event('Event 15 | 4'),
//   ],
// };

// 示例事件源
// final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
//     key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
//     value: (item) => List.generate(
//         item % 4 + 1, (index) => Event('Event $item | ${index + 1}')))
//   ..addAll({
//     kToday: [
//       Event('Today\'s Event 1'),
//       Event('Today\'s Event 2'),
//     ],
//   });

// 计算日期的哈希码
int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// 返回从[first]到[last]（包括）的[DateTime]对象列表。
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

// 当前日期
final kToday = DateTime.now();
// 三个月前的第一天
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
// 三个月后的最后一天
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

