import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:course_schedule/model/course.dart'; // 导入课程模型
import 'package:course_schedule/utils/device_type.dart'; // 导入设备类型工具类
import 'package:course_schedule/utils/text_util.dart'; // 导入文本工具类

// 点击回调函数类型定义，用于处理课程块的点击事件
typedef clickCallBack = void Function(Course course);

// 课程块组件
class CourseBlock extends StatelessWidget {
  final Course course; // 课程数据
  final double width; // 课程块的宽度
  final double height; // 课程块的高度
  final int index; // 在列表中的索引
  final bool isThisWeek; // 是否为本周
  final clickCallBack? onClick; // 点击事件回调函数

  /// 课程格子外边距
  final double margin;

  /// 课程格子内边距
  static const double _padding = 3;

  static int count = 0; // 计数器，用于循环取色
  static const List<Color> colors = [
    Color(0xCCFF5252),
    Color(0xCC536DFE),
    Color(0xCCE040FB),
    Color(0xCCFF6E40),
    Color(0xCCFF4081),
    Color(0xCCFFAB40),
    Color(0xCC7C4DFF),
  ];

  // 课程名最大长度
  static const int maxNameLength = 8;

  static const isNotThisWeekTip = "[非本周]"; // 非本周提示信息

  // 构造函数
  CourseBlock({
    required this.width,
    required this.height,
    required this.course,
    required this.index,
    required this.margin,
    this.onClick,
    this.isThisWeek = true,
    Key? key,
  }) : super(key: key);

  int nameLines = 3; // 课程名称的行数，默认为3行
  int locationLines = 3; // 地点信息的行数，默认为3行

  @override
  Widget build(BuildContext context) {
    final location = '@' + course.classRoom; // 地点信息

    // 如果不是 Web 端，则计算文本行数
    if (!DeviceType.isWeb) {
      calculateLines(context, course.name, location);
    }

    // 返回一个可点击的课程块
    return GestureDetector(
      onTap: () {
        if (onClick != null) {
          onClick!(course);
        }
      },
      child: Container(
        width: width - 2 * margin,
        height: height - 2 * margin,
        padding: const EdgeInsets.all(_padding), // 设置内边距
        decoration: BoxDecoration(
          // 设置背景颜色
          color: isThisWeek
              ? colors[index % colors.length]
              : const Color(0xCCD3D3D3),
          borderRadius: BorderRadius.all(Radius.circular(5)), // 设置圆角
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 如果不是本周，则显示非本周提示信息
            if (!isThisWeek)
              Text(
                isNotThisWeekTip,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.0,
                  height: DeviceType.isWeb ? 1 : null, // 设置行高
                ),
              ),
            // 显示课程名称
            Text(
              course.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
                height: DeviceType.isWeb ? 1 : null, // 设置行高
              ),
              overflow: TextOverflow.ellipsis, // 超出部分省略
              maxLines: nameLines, // 设置最大行数
            ),
            // 如果地点信息不为空，则显示地点信息
            if (!TextUtil.isEmpty(course.classRoom))
              Text(
                location,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  height: DeviceType.isWeb ? 1 : null, // 设置行高
                ),
                overflow: TextOverflow.ellipsis, // 超出部分省略
                maxLines: locationLines, // 设置最大行数
              ),
          ],
        ),
      ),
    );
  }

  // 计算文本行数
  void calculateLines(BuildContext context, String name, String location) {
    // 计算课程名字+地点的文本最大高度
    double contentHeight = height - 2 * margin - 2 * _padding;

    // 内容宽度
    final double contentWidth = width - 2 * margin - 2 * _padding;

    // 非本周标识占用
    if (!isThisWeek) {
      contentHeight -= TextUtil.calculateTextHeight(
          context, isNotThisWeekTip, 10, contentWidth);
    }

    // 计算课程名字和地点的文本绘制信息
    final nameSize = TextUtil.buildTextPainter(context, name, 12, contentWidth);
    final locationSize =
        TextUtil.buildTextPainter(context, location, 12, contentWidth);

    // 获取文本行数
    final maxNameLines = nameSize.computeLineMetrics().length;
    final maxLocationLines = nameSize.computeLineMetrics().length;

    final nameLineHeight = nameSize.height / maxNameLines;

    // 文本高度超过最大高度
    if (nameSize.height + locationSize.height > contentHeight) {
      final maxTextHeight = contentHeight / 2.0;

      // 如果名字和地点高度都大于 contentHeight 的二分之一，文本平分内容高度
      if (nameSize.height > maxTextHeight &&
          locationSize.height > maxTextHeight) {
        nameLines = _getMaxLines(maxTextHeight, nameSize, maxNameLines);
        locationLines = _getMaxLines(contentHeight - nameLineHeight * nameLines,
            locationSize, maxLocationLines);
      } else {
        // 如果名字和地点高度有一个小于 contentHeight 的二分之一，高度高的充满剩余空间
        if (nameSize.height > locationSize.height) {
          locationLines = maxLocationLines;
          nameLines = _getMaxLines(
              contentHeight - locationSize.height, nameSize, maxNameLines);
        } else {
          nameLines = maxNameLines;
          locationLines = _getMaxLines(
              contentHeight - nameSize.height, locationSize, maxLocationLines);
        }
      }
    } else {
      // 不限制文本行数
      nameLines = 999;
      locationLines = 999;
    }
  }

  // 计算固定高度的情况下的文本行数
  int _getMaxLines(double maxHeight, TextPainter painter, int lines) =>
      (maxHeight / (painter.height / lines)).floor();

  /// 将课程格子用Positioned装饰
  Widget decorateByPositioned(double left, double top) {
    return Positioned(left: left, top: top, child: this);
  }
}
