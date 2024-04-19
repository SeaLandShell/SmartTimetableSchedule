import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:course_schedule/utils/device_type.dart';
import 'package:course_schedule/utils/text_util.dart';
import 'package:provider/provider.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter/rendering.dart';

// Util 类提供了一系列的静态方法，用于执行各种常见的辅助功能
class Util {
  Util._(); // 私有构造函数，防止类被实例化

  /// 获取当前日期的星期几，返回值为[1, 7]，1 代表星期一，以此类推
  static int getDayOfWeek() {
    return DateTime.now().weekday;
  }

  /// 根据数字表示的星期返回对应的中文字符串表示，传入值应在[1, 7]之间，1 代表星期一，以此类推
  static String getDayOfWeekString(int? week) {
    if (week == null || week < 1 || week > 7) {
      return "";
    }
    return ["周一", "周二", "周三", "周四", "周五", "周六", "周日"][week - 1];
  }

  /// 显示 Toast 消息
  // static void showToast(String? msg) {
  //   if (TextUtil.isEmpty(msg)) {
  //     return;
  //   }
  //   Fluttertoast.showToast(
  //     msg: msg!,
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.BOTTOM,
  //     timeInSecForIosWeb: 1,
  //     backgroundColor: Colors.white,
  //     textColor: Colors.black87,
  //     fontSize: 16.0,
  //   );
  // }
  /// 显示 Toast 消息
  static void showToastCourse(String? msg, BuildContext context) {
    // 检查消息是否为空或null
    if (TextUtil.isEmpty(msg)) {
      return; // 如果为空或null，直接返回，不显示toast消息
    }

    // 调用showToast方法显示toast消息，并设置各种参数
    showToast(
      msg, // 设置toast消息内容
      context: context, // 设置上下文
      animation: StyledToastAnimation.slideFromBottom, // 设置进入动画效果
      reverseAnimation: StyledToastAnimation.slideToBottom, // 设置退出动画效果
      startOffset: Offset(0.0, 3.0), // 设置起始偏移量
      reverseEndOffset: Offset(0.0, 3.0), // 设置结束偏移量
      position: StyledToastPosition.bottom, // 设置toast位置
      duration: Duration(seconds: 4), // 设置toast持续时间
      animDuration: Duration(seconds: 1), // 设置动画持续时间
      curve: Curves.elasticOut, // 设置进入动画曲线
      reverseCurve: Curves.fastOutSlowIn, // 设置退出动画曲线
    );
  }

  /// 显示 Toast 消息
  // static void showToast(String? msg) {
  //   if (TextUtil.isEmpty(msg)) {
  //     return;
  //   }
  //   StyledToast(
  //     textStyle: TextStyle(fontSize: 16.0, color: Colors.white),
  //     backgroundColor: Color(0x99000000),
  //     borderRadius: BorderRadius.circular(5.0),
  //     textPadding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 10.0),
  //     toastAnimation: StyledToastAnimation.size,
  //     reverseAnimation: StyledToastAnimation.size,
  //     startOffset: Offset(0.0, -1.0),
  //     reverseEndOffset: Offset(0.0, -1.0),
  //     duration: Duration(seconds: 4),
  //     animDuration: Duration(seconds: 1),
  //     alignment: Alignment.center,
  //     toastPositions: StyledToastPosition.center,
  //     curve: Curves.fastOutSlowIn,
  //     reverseCurve: Curves.fastOutSlowIn,
  //     dismissOtherOnShow: true,
  //     locale: const Locale('en', 'US'),
  //     fullWidth: false,
  //     isHideKeyboard: false,
  //     isIgnoring: true,
  //     child: MaterialApp(
  //       title: msg!,
  //       showPerformanceOverlay: true,
  //       home: LayoutBuilder(
  //         builder: (BuildContext context, BoxConstraints constraints) {
  //           return MyHomePage(
  //             title: appTitle,
  //             onSetting: onSettingCallback,
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  /// 取消当前焦点
  static void cancelFocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  /// 星期选项数组，用于周数的格式化显示
  static const _WEEK_OPTIONS = <String>["周", "单周", "双周"];

  /// 根据周数和最大周数返回格式化的周数字符串，包括单双周选项
  static String getFormatStringFromWeekOfTerm(int weekOfTerm, int maxWeekNum) {
    if (!isWeekOfTermValid(weekOfTerm, maxWeekNum)) {
      return "请选择周数";
    }
    return getStringFromWeekOfTerm(weekOfTerm, maxWeekNum) +
        " [" +
        _WEEK_OPTIONS[getWeekOptionFromWeekOfTerm(weekOfTerm, maxWeekNum)] +
        "]";
  }

  /// 单双周常量定义
  static const _SINGLE_DOUBLE_WEEK = 0;
  static const _SINGLE_WEEK = 1;
  static const _DOUBLE_WEEK = 2;

  /// 根据周数和最大周数返回周数字符串
  static String getStringFromWeekOfTerm(int weekOfTerm, int maxWeekNum) {
    if (weekOfTerm == 0) {
      return "";
    }

    final stringBuilder = StringBuffer();
    final weekOptions = getWeekOptionFromWeekOfTerm(weekOfTerm, maxWeekNum);

    var start = 1;
    var space = 2;
    switch (weekOptions) {
      case _SINGLE_DOUBLE_WEEK:
        space = 1;
        break;
      case _SINGLE_WEEK:
        break;
      case _DOUBLE_WEEK:
        start = 2;
        break;
      default:
        return "error";
    }

    var count = 0;
    for (var i = start; i <= maxWeekNum; i += space) {
      if (Util.courseIsThisWeek(weekOfTerm, i, maxWeekNum)) {
        if (count == 0) {
          stringBuilder.write(i);
        }
        count += 1;
      } else {
        if (count == 1) {
          stringBuilder.write(',');
        } else if (count > 1) {
          stringBuilder.write("-${i - space},");
        }
        count = 0;
      }
    }
    if (count > 1) {
      stringBuilder.write('-');
      var max = maxWeekNum;
      if (start == 1 && max % 2 == 0) {
        // 如果起始为 1 且最大周数为偶数，则为单周
        max--;
      } else if (start == 2 && max % 2 == 1) {
        // 如果起始为 2 且最大周数为奇数，则为双周
        max--;
      }
      stringBuilder.write(max);
    }

    final result = stringBuilder.toString();

    if (result.endsWith(",")) {
      return result.substring(0, result.length - 1);
    } else {
      return stringBuilder.toString();
    }
  }

  /// 根据周数和最大周数返回单双周选项
  static int getWeekOptionFromWeekOfTerm(int weekOfTerm, int maxWeekNum) {
    int singleWeek = 0x55555555;
    int doubleWeek = ~singleWeek;
    if (maxWeekNum % 2 == 0) {
      int temp = singleWeek;
      singleWeek = doubleWeek;
      doubleWeek = temp;
    }

    bool hasSingleWeek = (singleWeek & weekOfTerm) != 0;
    bool hasDoubleWeek = (doubleWeek & weekOfTerm) != 0;
    return hasSingleWeek && hasDoubleWeek
        ? 0
        : (hasSingleWeek ? 1 : (hasDoubleWeek ? 2 : -1));
  }

  /// 检查周数是否有效
  static bool isWeekOfTermValid(int? weekOfTerm, int maxWeekNum) {
    if (weekOfTerm == null) {
      return false;
    } else {
      return ((1 << maxWeekNum) - 1) & weekOfTerm != 0;
    }
  }

  /// 获取指定类型的 Provider
  static T getReadProvider<T>(BuildContext context) {
    return Provider.of<T>(context, listen: false);
  }

  /// 检查指定周是否是本周
  static bool courseIsThisWeek(
      int weekOfTerm, int currentWeek, int maxWeekNum) {
    return (weekOfTerm >> (maxWeekNum - currentWeek) & 0x01) == 1;
  }

  /// 获取本周一的开始时间（00:00:00）
  static DateTime getMondayTime() {
    final DateTime now = DateTime.fromMillisecondsSinceEpoch(
        (DateTime.now().millisecondsSinceEpoch ~/ (1000 * 1000)) * 1000 * 1000);
    return now.subtract(
        Duration(days: now.weekday - 1, hours: now.hour, minutes: now.minute));
  }

  /// 获取自1970年1月5日以来的周数
  static int getWeekSinceEpoch() {
    final DateTime now = DateTime.now();
    final daySince = now.millisecondsSinceEpoch ~/ (1000 * 60 * 60 * 24) - 4;
    return daySince ~/ 7;
  }

  /// 如果是桌面环境，返回指定的字体
  static String? getDesktopFontFamily() {
    return DeviceType.isMobile ? null : "NotoSansSC";
  }

  /// 返回当前时间的时间戳（单位为秒）
  static int getTimeStamp() {
    return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }
}
