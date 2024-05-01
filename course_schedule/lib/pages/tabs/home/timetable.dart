import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:course_schedule/components/course_block.dart';
import 'package:course_schedule/model/course.dart';
import 'package:course_schedule/provider/store.dart';
import 'package:course_schedule/utils/util.dart';
import 'package:provider/provider.dart';

import '../../../ui/coursedetail/course_detail.dart';

// Timetable 类，用于显示课程表
class Timetable extends StatelessWidget {
  final double width; // 课程表宽度
  final double height; // 课程表高度

  /// 课程格子外边距
  final double cellMargin = 1;

  Timetable({required this.width, required this.height}); // 构造函数

  @override
// 重写build方法以构建课表组件
  Widget build(BuildContext context) {
    final double tableCellWidth = width / 7.0; // 计算单元格宽度
    final double tableCellHeight = height / 12.0; // 计算单元格高度
    return Expanded(
      flex: 1,
      child: Container(
        child: Consumer<Store>(builder: (context, state, child) {
          // 使用Consumer包裹子部件，并传入Store来获取状态
          final List<Widget> courseBlockList = []; // 存储课程块的列表
          final List<Course> courses = _selectNeedToShowCourse(state.courses, state.currentWeek, state.maxWeekNum);
          // 获取需要显示的课程列表
          for (int i = 0; i < courses.length; i++) {
            // 遍历需要显示的课程列表
            final course = courses[i];
            // 获取当前课程
            courseBlockList.add(
              CourseBlock(
                width: tableCellWidth,
                height: tableCellHeight * course.classLength,
                // 创建课程块，并设置宽度、高度
                course: course,
                index: i,
                margin: cellMargin,
                isThisWeek: Util.courseIsThisWeek(course.weekOfTerm, state.currentWeek, state.maxWeekNum),
                // 设置课程是否为本周进行
                onClick: (course) async {
                  // 当点击课程块时执行异步操作
                  _showCourseDetailDialog(context, course);
                  // 弹出课程详情对话框
                },
              ).decorateByPositioned(
                cellMargin + tableCellWidth * (course.dayOfWeek - 1),
                cellMargin + tableCellHeight * (course.classStart - 1),
                // 根据课程在表格中的位置进行装饰
              ),
            );
          }
          return Stack(children: courseBlockList); // 在层叠布局中显示课程块
        }),
      ),
    );
  }

  // 弹出对话框显示课程详情
  Future<bool?> _showCourseDetailDialog(BuildContext context, Course course) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(8),
          content: CourseDetailWidget(
            course: course,
          ),
        );
      },
    );
  }

  /// 该课程是否需要显示
  bool _isThisWeekCourseNeedToShow(int weekOfTerm, int currentWeek, int maxWeekNum) {
    int offset = maxWeekNum - currentWeek;
    // 计算当前周与课程开始周的差值
    if ((1 << offset) > weekOfTerm) {
      // 如果当前周还未到课程开始周，则不需要显示此课程
      return false;
    }
    // 快速给前offset位赋值1，并与课程开始周进行按位与操作，
    // 如果结果大于0，则表示课程正在本周进行，需要显示
    return (((1 << (offset + 1)) - 1) & weekOfTerm) > 0;
  }

  /// 计算需要显示的课程
  List<Course> _selectNeedToShowCourse(
      List<Course> courses, int currentWeek, int maxWeekNum) {
    // 选择需要显示的课程方法，传入参数为课程列表、当前周数、最大周数
    List<Course> selectCourseList = []; // 存储需要显示的课程列表
    List<bool> flag = List.filled(12, false); // 用于标记每节课的占用情况，-1表示无课程，其他值表示占用课程在mCourseList中的索引
    int weekOfDay = 0; // 记录当前是一周中的第几天
    int size = courses.length; // 课程列表的长度

    for (int index = 0; index < size; index++) {
      // 遍历课程列表
      Course course = courses[index];
      // 获取当前课程
      if (!_isThisWeekCourseNeedToShow(
          course.weekOfTerm, currentWeek, maxWeekNum)) {
        // 判断是否需要显示当前周的课程
        continue; // 如果不需要显示，则继续下一轮循环
      }

      if (course.dayOfWeek != weekOfDay) {
        // 如果当前课程不在同一天，则重新初始化flag
        flag.fillRange(0, flag.length, false);
        weekOfDay = course.dayOfWeek;
      }
      int classStart = course.classStart; // 课程开始的节次
      int classNum = course.classLength; // 课程的长度（占用的节次）
      int i;
      for (i = 0; i < classNum; i++) {
        // 遍历课程的节次
        if (flag[classStart + i - 1]) {
          // 如果当前节次已经被占用
          if (!Util.courseIsThisWeek(
              course.weekOfTerm, currentWeek, maxWeekNum)) {
            break; // 如果当前不是本周课程，则结束循环
          } else {
            selectCourseList.removeLast(); // 删除最后一个元素
            selectCourseList.add(course); // 添加当前课程
            for (int j = 0; j < classNum; j++) {
              flag[classStart + j - 1] = true; // 标记占用的节次
            }
            break; // 结束循环
          }
        }
      }
      if (i == classNum) {
        selectCourseList.add(course); // 添加课程
        for (int j = 0; j < classNum; j++) {
          flag[classStart + j - 1] = true; // 标记占用的节次
        }
      }
    }
    return selectCourseList; // 返回需要显示的课程列表
  }
}
