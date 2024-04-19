import 'package:flutter/material.dart';
import 'package:course_schedule/models/course.dart'; // 导入课程模型
import 'package:course_schedule/provider/store.dart'; // 导入数据存储提供者
import 'package:course_schedule/utils/util.dart'; // 导入工具类
import 'package:provider/provider.dart'; // 导入 Provider 状态管理库
import 'package:timelines/timelines.dart';

import '../../../data/values.dart';
import '../course/course_page.dart'; // 导入 timelines 库，用于构建时间线视图

/// 今日课程视图组件，用于显示当天的课程安排
class TodayCourseView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(15)), // 圆角矩形边框
      child: Container(
        width: double.infinity, // 宽度填充父级
        height: 180, // 固定高度为 180
        color: Colors.white, // 白色背景
        child: Stack(
          children: [
            Consumer<Store>(builder: (context, store, child) {
              final List<Course> list = []; // 存放当天课程的列表
              final int week = Util.getDayOfWeek(); // 获取当前星期几
              store.courses.forEach((element) {
                if (element.dayOfWeek == week && // 如果课程是今天，并且在本周进行
                    Util.courseIsThisWeek(element.weekOfTerm, store.currentWeek,
                        store.maxWeekNum)) {
                  list.add(element); // 将课程添加到列表中
                }
              });
              list.sort(); // 对课程列表进行排序
              if (list.isEmpty) {
                // 如果当天没有课程
                return Center(
                  child: Text("今天没有课程", // 显示提示信息
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black54)),
                );
              }
              return Timeline.tileBuilder(
                padding: EdgeInsets.only(top: 24),
                scrollDirection: Axis.horizontal,
                builder: TimelineTileBuilder.fromStyle(
                  contentsAlign: ContentsAlign.basic,
                  contentsBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return CoursePage(index: index, backgroundColor: Values.bgWhite);
                      }));
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                      child: Column(
                        children: [
                          Text(
                            list[index].name,
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            list[index].classRoom,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  oppositeContentsBuilder: (context, index) {
                    final course = list[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return CoursePage(index: index, backgroundColor: Values.bgWhite);
                        }));
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                        child: Text(
                          "${course.classStart}-${course.classEnd}节",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  },
                  itemCount: list.length,
                ),
              );
            }),
            Align(
              alignment: Alignment.topLeft, // 左上角对齐
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 0, 8),
                child: Text(
                  "今天的课程", // 标题文本
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600), // 字体样式
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
