import 'package:add_calendar_event/add_calendar_event.dart'; // 导入添加日历事件的库
import 'package:flutter/cupertino.dart'; // 导入 Flutter Cupertino 风格的部件
import 'package:flutter/material.dart'; // 导入 Flutter Material 部件
import 'package:course_schedule/components/card_view.dart'; // 导入自定义的卡片部件
import 'package:course_schedule/components/clipper/bottom_curve_clipper.dart'; // 导入自定义的底部曲线剪裁器
import 'package:course_schedule/components/item_button.dart'; // 导入自定义的项目按钮部件
import 'package:course_schedule/data/values.dart'; // 导入常量值
import 'package:course_schedule/provider/store.dart'; // 导入存储提供者
import 'package:course_schedule/pages/tabs/plan/today_course.dart'; // 导入今日课程页面
import 'package:course_schedule/pages/tabs/user/user_card.dart'; // 导入用户卡片页面
import 'package:course_schedule/utils/device_type.dart'; // 导入设备类型工具
import 'package:course_schedule/utils/dialog_util.dart'; // 导入对话框工具
import 'package:course_schedule/utils/util.dart'; // 导入通用工具

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  /// 用户信息卡片的高度
  static const double userCardHeight = UserCard.height;

  /// 内容距状态栏的高度
  static const double topMargin = 32;

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
            clipper: BottomCurveClipper(offset: userCardHeight / 2 + 8),
            // 子部件为一个Container容器
            child: Container(
              // 设置容器的高度，包括状态栏高度、顶部边距和用户卡片高度
              height: statusBarHeight + topMargin + userCardHeight,
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
                padding:
                    EdgeInsets.fromLTRB(16, statusBarHeight + topMargin, 16, 0),
                child: UserCard(), // 用户信息卡片
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Text("自定义卡片") // 今日课程
              ),
              if (DeviceType.isMobile)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Text("自定义卡片") // 今日课程, // 构建提醒工具
                ),
            ],
          ),
        ],
      ),
    );
  }

  static const _reminderEventDesc = "课程表自动创建";

}
