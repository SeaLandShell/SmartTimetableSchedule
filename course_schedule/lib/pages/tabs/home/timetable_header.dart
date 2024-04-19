import 'package:flutter/material.dart';
import 'package:course_schedule/entity/time.dart'; // 导入时间实体类
import 'package:course_schedule/provider/store.dart'; // 导入数据存储提供者
import 'package:course_schedule/utils/util.dart'; // 导入工具类
import 'package:provider/provider.dart'; // 导入 Provider 状态管理库

/// 节数表头组件，用于显示课程节数
class ClassIndexTableHeader extends StatelessWidget {
  final double width; // 组件宽度

  ClassIndexTableHeader({required this.width}); // 构造函数

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12, // 表头背景颜色
      width: width, // 表头宽度
      child: Selector<Store, List<TimeEntity>>(
        // 使用 Selector 从 Store 获取数据，当数据发生变化时自动更新
        selector: (context, store) {
          return store.classTime; // 选择器，选择课程时间列表
        },
        builder: (context, value, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List<Widget>.generate(12, (index) {
              return _classIndexBuilder(index, value); // 构建课程节数
            }),
          );
        },
      ),
    );
  }

  // 构建课程节数
  Widget _classIndexBuilder(int index, List<TimeEntity> classTime) {
    String time = ""; // 时间字符串初始化
    if (index < classTime.length && !classTime[index].isEmpty) {
      // 如果索引在课程时间列表范围内且时间实体不为空
      final entity = classTime[index]; // 获取时间实体
      return Column(
        children: [
          Text((index + 1).toString(),
              style: const TextStyle(fontSize: 13)), // 显示课程节数
          Text(entity.start.toString(), // 显示课程开始时间
              style: const TextStyle(fontSize: 10, color: Colors.black54)),
          Text(entity.end.toString(), // 显示课程结束时间
              style: const TextStyle(fontSize: 10, color: Colors.black54)),
        ],
      );
    } else {
      // 如果课程时间列表中没有对应的时间实体
      return Text(
        (index + 1).toString() + time, // 显示课程节数
        style: const TextStyle(fontSize: 12),
      );
    }
  }
}

/// 星期表头组件，用于显示星期几
class DayOfWeekTableHeader extends StatelessWidget {
  static const _dayOfWeeks = [
    "周一",
    "周二",
    "周三",
    "周四",
    "周五",
    "周六",
    "周日"
  ]; // 星期几列表

  final double height; // 组件高度
  final double leftPadding; // 左边距

  DayOfWeekTableHeader(
      {required this.height, required this.leftPadding}); // 构造函数

  @override
  Widget build(BuildContext context) {
    var weeks = <Widget>[]; // 星期几组件列表
    var weekDay = Util.getDayOfWeek(); // 获取当前星期几
    for (int i = 0; i < _dayOfWeeks.length; i++) {
      Widget text;
      if (i + 1 == weekDay) {
        // 如果是当前星期几，添加蓝色背景
        text = Expanded(
          child: Container(
            color: Colors.blue, // 蓝色背景
            child: Center(
              child: Text(
                _dayOfWeeks[i], // 显示星期几
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white), // 文字颜色白色
              ),
            ),
          ),
        );
      } else {
        text = Expanded(
          child: Center(
            child: Text(
              _dayOfWeeks[i], // 显示星期几
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
      weeks.add(text); // 将星期几组件添加到列表中
    }

    return Container(
      height: height, // 组件高度
      color: Colors.black12, // 背景颜色
      child: Row(
        children: [
          SizedBox(
            width: leftPadding, // 左边距
          ),
          ...weeks // 星期几组件列表
        ],
        crossAxisAlignment: CrossAxisAlignment.stretch, // 组件交叉轴对齐方式为拉伸
      ),
    );
  }
}
