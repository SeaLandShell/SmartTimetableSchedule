// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:capped_progress_indicator/capped_progress_indicator.dart';
import 'package:course_schedule/components/card_view.dart';
import 'package:course_schedule/provider/calender_provider.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../components/clipper/bottom_curve_clipper.dart';
import '../../../data/values.dart';
import '../../../utils/event_util.dart';
import '../../../utils/http_util.dart';
import '../../../utils/shared_preferences_util.dart';

// 表示日历应用中的页面的小部件
class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}); // CalendarPage 小部件的构造函数

  @override
  _CalendarPageState createState() => _CalendarPageState(); // 为小部件创建状态
}

// CalendarPage 小部件的状态类
class _CalendarPageState extends State<CalendarPage> {
  static const double topMargin = 32;
  static const double TodayCourseCardHeight = 40;
  double statusBarHeight = 0;
  double screenHeight = 0;
  double bottomNavBarHeight = 0;
  bool _loading=true;

  late final ValueNotifier<List<Event>> _selectedEvents; // 选定事件的通知器
  CalendarFormat _calendarFormat = CalendarFormat.month; // 初始日历格式
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff; // 日期范围的选择模式
  DateTime _focusedDay = DateTime.now(); // 当前关注的日期
  DateTime? _selectedDay; // 选定的日期
  DateTime? _rangeStart; // 选择范围的起始日期
  DateTime? _rangeEnd; // 选择范围的结束日期
  late LinkedHashMap<DateTime, List<Event>> kEvents;
  Map<DateTime, List<Event>> _kEventSource={
    DateTime.utc(2024, 4, 11): [
      Event('事件 15 | 1'),
      Event('事件 15 | 2'),
    ],
  };


  @override
  void initState() {
    super.initState();
    getProgramDetail();
  }

  @override
  void dispose() {
    _selectedEvents.dispose(); // 释放选定事件的通知器
    super.dispose();
  }

  // 获取特定日期的事件
  List<Event> _getEventsForDay(DateTime day) {
    // 实现示例
    return kEvents[day] ?? []; // 返回指定日期的事件
  }

  // 获取日期范围内的事件
  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // 实现示例
    final days = daysInRange(start, end); // 获取指定范围内的所有日期

    return [
      for (final d in days) ..._getEventsForDay(d), // 获取范围内每一天的事件
    ];
  }

  // 选定日期时的回调
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) { // 检查选定日期是否与当前选定日期不同
      setState(() {
        _selectedDay = selectedDay; // 更新选定日期
        _focusedDay = focusedDay; // 更新关注的日期
        _rangeStart = null; // 重置选择范围的起始日期
        _rangeEnd = null; // 重置选择范围的结束日期
        _rangeSelectionMode = RangeSelectionMode.toggledOff; // 禁用范围选择
      });
      _selectedEvents.value = _getEventsForDay(selectedDay); // 更新选定日期的事件
    }
  }

  // 选定日期范围时的回调
  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null; // 重置选定日期
      _focusedDay = focusedDay; // 更新关注的日期
      _rangeStart = start; // 设置选择范围的起始日期
      _rangeEnd = end; // 设置选择范围的结束日期
      _rangeSelectionMode = RangeSelectionMode.toggledOn; // 启用范围选择
    });

    // 处理范围选择的不同情况
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end); // 获取选定范围的事件
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start); // 如果未选择结束日期，则获取起始日期的事件
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end); // 如果未选择起始日期，则获取结束日期的事件
    }
  }

  @override
  Widget build(BuildContext context) {
    if(_loading){
      return Center(child: CircularProgressIndicator());
    }
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final GlobalKey<ExpansionTileCardState> cardB = GlobalKey<ExpansionTileCardState>();
    return Scaffold(
      backgroundColor: Values.bgWhite,
      body: Stack(
        children: [
          ClipPath(
            // 指定裁剪的方式为BottomCurveClipper，传入一个偏移量作为参数
            clipper: BottomCurveClipper(offset: TodayCourseCardHeight / 2 + 8),
            // 子部件为一个Container容器
            child: Container(
              // 设置容器的高度，包括状态栏高度、顶部边距和用户卡片高度
              height: statusBarHeight + topMargin + TodayCourseCardHeight,
              // 设置容器的装饰，包括一个渐变背景色
              decoration: BoxDecoration(
                // 定义一个线性渐变，指定起点和终点
                gradient: LinearGradient(
                    begin: Alignment.centerLeft, // 渐变起点为居中左侧
                    end: Alignment.centerRight, // 渐变终点为居中右侧
                    colors: [Colors.blue.shade400, Colors.blue.shade700] // 渐变色从浅蓝到深蓝
                ),
              ),
              // 应用渐变背景色
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                // 创建日历小部件
                CardView(
                  child: ExpansionTileCard(
                    key: cardB,
                    baseColor: Colors.white,
                    expandedColor: Colors.white,
                    initiallyExpanded: true,
                    title: Text("日历卡片"),
                    subtitle: Text("点击展开日历选择事件"),
                    leading: Icon(Icons.calendar_month_rounded,color: Colors.blue,),
                    children: [
                      TableCalendar<Event>(
                        firstDay: kFirstDay, // 日历的第一天
                        lastDay: kLastDay, // 日历的最后一天
                        focusedDay: _focusedDay, // 当前关注的日期
                        locale: 'zh_CN',
                        selectedDayPredicate: (day) => isSameDay(_selectedDay, day), // 用于确定日期是否被选中
                        rangeStartDay: _rangeStart, // 选择范围的起始日期
                        rangeEndDay: _rangeEnd, // 选择范围的结束日期
                        calendarFormat: _calendarFormat, // 日历的格式
                        rangeSelectionMode: _rangeSelectionMode, // 日期范围的选择模式
                        eventLoader: _getEventsForDay, // 加载事件的回调函数
                        startingDayOfWeek: StartingDayOfWeek.monday, // 日历的第一天是星期几
                        calendarStyle: CalendarStyle(
                          // 使用 `CalendarStyle` 来自定义界面
                          outsideDaysVisible: false, // 是否显示非当前月份的日期
                        ),
                        onDaySelected: _onDaySelected, // 选定日期时的回调
                        onRangeSelected: _onRangeSelected, // 选定日期范围时的回调
                        onFormatChanged: (format) {
                          if (_calendarFormat != format) {
                            setState(() {
                              _calendarFormat = format; // 更新日历格式
                            });
                          }
                        },
                        onPageChanged: (focusedDay) {
                          _focusedDay = focusedDay; // 页面切换时更新关注的日期
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                // LinearCappedProgressIndicator(value: 1, minHeight: 1,backgroundColor: Colors.blueGrey.shade100 ,color: Colors.blue ,),
                Expanded(
                  child: ValueListenableBuilder<List<Event>>(
                    valueListenable: _selectedEvents,
                    builder: (context, value, _) {
                      return ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ListTile(
                              onTap: () => print('${value[index]}'),
                              title: Text('${value[index]}'),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

        ],
      ),

    );
  }

  void getProgramDetail() async {
    int userId=await SharedPreferencesUtil.getPreference("userID", 0);
    try {
      final resp = await HttpUtil.client.get(
        "/acuser/program/$userId",);
      final data = HttpUtil.getDataFromResponse(resp.toString()); // 解析响应数据
      if (data is List) {
        log(data.toString());
        // 如果数据是列表类型
        setState(() {
          _kEventSource.clear(); // 清空数据列表
          for(var i=0;i<data.length;i++){
            String jsonString = data[i]["title"];
            Map<String, dynamic> jsonData = json.decode(jsonString);
            jsonData.forEach((key, value) {
              // 解析日期字符串
              List<String> dateParts = key.split('-');
              int year = int.parse(dateParts[0]);
              int month = int.parse(dateParts[1]);
              int day = int.parse(dateParts[2]);
              // 构建 DateTime 对象
              DateTime dateTime = DateTime.utc(year, month, day);
              if (_kEventSource.containsKey(dateTime)) {
                // 如果键已存在，则将新的事件列表添加到已有键的列表中
                List<Event> existingEvents = _kEventSource[dateTime]!;
                for (var event in value) {
                  existingEvents.add(Event(event['title']));
                }
                _kEventSource[dateTime] = existingEvents;
              } else {
                // 如果键不存在，则创建一个新的键值对
                List<Event> events = [];
                for (var event in value) {
                  events.add(Event(event['title']));
                }
                _kEventSource[dateTime] = events;
              }
              // log("item:AAAAAA: ${_kEventSource.toString()}");
            });
          }
          // log("item:BBBBBB: ${_kEventSource.toString()}");
          kEvents = LinkedHashMap<DateTime, List<Event>>(
            equals: isSameDay, // 判断两个日期是否是同一天
            hashCode: getHashCode, // 获取日期的哈希码
          )..addAll(_kEventSource);
          _selectedDay = _focusedDay; // 初始将选定的日期设置为当前关注的日期
          _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!)); // 初始化选定事件的通知器
          _loading = false; // 加载完成，更新_loading状态为false
        });
      }
    } catch (e) {
      print(e); // 打印错误信息
      setState(() {
        _loading = false; // 加载完成，更新_loading状态为false
      });
    }
  }
}