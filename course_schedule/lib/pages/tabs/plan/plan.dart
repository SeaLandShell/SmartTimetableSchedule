import 'package:course_schedule/pages/tabs/plan/today_course.dart';
import 'package:add_calendar_event/add_calendar_event.dart'; // 导入添加日历事件的库
import 'package:flutter/material.dart';

import '../../../components/card_view.dart';
import '../../../components/clipper/bottom_curve_clipper.dart';
import '../../../components/item_button.dart';
import '../../../data/values.dart';
import '../../../provider/store.dart';
import '../../../utils/device_type.dart';
import '../../../utils/dialog_util.dart';
import '../../../utils/util.dart';

class PlanPage extends StatefulWidget {
  const PlanPage({super.key});

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  /// 内容距状态栏的高度
  static const double topMargin = 32;
  static const double TodayCourseCardHeight = 40;
  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top; // 获取状态栏高度
    return Container(
      color: Values.bgWhite, // 设置背景颜色为白色
      child: Stack(
        children: [
          // 使用ClipPath小部件，通过指定clipper来裁剪子部件
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
                child: TodayCourseView(), // 今日课程
              ),
              if (DeviceType.isMobile)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: _buildReminderTool(), // 构建提醒工具
                ),
            ],
          ),
        ],
      ),
    );
  }
  CardView _buildReminderTool() {
    return CardView(
      title: "提醒工具",
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Row(
          children: [
            ItemButton(
              onClick: () {
                if (Store.getInstanceReadMode(context).courses.isEmpty) {
                  // 如果课程表为空，则提示用户先导入课程表
                  DialogUtil.showTipDialog(context, "请先导入课程表");
                } else {
                  _selectReminderTime(); // 否则，选择提醒时间
                }
              },
              title: '导入日历',
              icon: Icon(
                Icons.calendar_today,
                color: Colors.blue.shade400,
              ),
            ),
            ItemButton(
              onClick: () {
                DialogUtil.showConfirmDialog(context, "确定要清空导入日历的所有事件吗？",
                        () async {
                      final count = await _deleteCalendarEvent();
                      Util.showToastCourse("成功删除$count个事件", context);
                    });
              },
              title: '清空日程',
              icon: Icon(
                Icons.delete_forever,
                color: Colors.red.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 选择提醒时间
  void _selectReminderTime() {
    DialogUtil.showPickerViewOneColumn(
        context: context,
        title: "选择提醒时间",
        count: 30,
        builder: (index) {
          return Text(
            "${index + 1}分钟前",
            style: const TextStyle(fontSize: 16),
          );
        },
        confirmCallBack: (index) {
          _importCalendarEvent(index + 1); // 确认选择后导入日历事件
        },
        initIndex: 9); // 默认选中 10 分钟前
  }

  static const _reminderEventDesc = "课程表自动创建";
  // 导入日历事件
  void _importCalendarEvent(int minute) async {
    DialogUtil.showLoadingDialog(context); // 显示加载对话框
    try {
      await _deleteCalendarEvent(); // 先清空已有日历事件
      final store = Store.getInstanceReadMode(context);
      final times = store.classTime;
      List<Event> events = [];
      final maxWeekNum = store.maxWeekNum;

      final monday = Util.getMondayTime();
      final day = Util.getDayOfWeek();

      store.courses.forEach((course) {
        final classStart = times[course.classStart - 1];
        final classEnd = times[course.classEnd - 1];

        if (classStart.isEmpty || classEnd.isEmpty) {
          return;
        }

        int i = store.currentWeek;
        // 如果该课程在本周已经上完则不添加进日历
        if (course.dayOfWeek < day) {
          i++;
        }
        for (; i <= maxWeekNum; i++) {
          if ((course.weekOfTerm >> (maxWeekNum - i)) & 1 == 1) {
            final day = (i - store.currentWeek) * 7 + course.dayOfWeek - 1;
            events.add(Event(
                title: course.name,
                location: course.classRoom,
                description: _reminderEventDesc,
                startDate: monday.add(Duration(
                    days: day,
                    hours: classStart.start!.hour,
                    minutes: classStart.start!.minute)),
                endDate: monday.add(Duration(
                    days: day,
                    hours: classEnd.end!.hour,
                    minutes: classEnd.end!.minute)),
                alarmInterval: Duration(minutes: minute)));
          }
        }
      });
      final result = await AddCalendarEvent.addEventListToCal(events); // 添加日历事件
      Navigator.pop(context); // 关闭加载对话框
      Util.showToastCourse(
          "导入日历事件成功:$result,失败:${events.length - result}", context);
    } catch (e) {
      print(e);
      Navigator.pop(context);
    }
  }

  // 删除日历事件
  Future<int> _deleteCalendarEvent() =>
      AddCalendarEvent.deleteCalEventByDesc(_reminderEventDesc);
}
