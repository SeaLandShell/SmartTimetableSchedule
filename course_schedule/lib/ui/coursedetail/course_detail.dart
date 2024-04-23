import 'package:course_schedule/db/database_manager.dart';
import 'package:course_schedule/db/domain/user_db.dart';
import 'package:course_schedule/model/index.dart';
import 'package:course_schedule/net/apiClientSchedule.dart';
import 'package:course_schedule/utils/shared_preferences_util.dart';
import 'package:flutter/material.dart'; // 导入Flutter的material库，包含Flutter应用程序的基本组件和风格
import 'package:course_schedule/model/course.dart'; // 导入课程模型类
import 'package:course_schedule/provider/store.dart'; // 导入Store提供者类，用于管理课程数据状态
import 'package:course_schedule/ui/editcourse/edit_course_page.dart'; // 导入编辑课程页面
import 'package:course_schedule/utils/dialog_util.dart'; // 导入对话框工具类，用于显示对话框
import 'package:course_schedule/utils/util.dart'; // 导入工具类，包含一些常用的工具方法
import 'package:provider/provider.dart';

import '../../data/values.dart';
import '../../pages/tabs/course/course_import_page.dart';
import '../../pages/tabs/course/course_page.dart'; // 导入Provider库，用于状态管理

class CourseDetailWidget extends StatelessWidget {
  // 课程详情组件
  final Course course; // 当前课程对象

  const CourseDetailWidget({
    // 构造函数
    required this.course, // 必需参数，表示课程对象
    Key? key, // 组件的标识符
  }) : super(key: key); // 调用父类构造函数

  @override
  Widget build(BuildContext context) {
    // 组件的构建方法
    return Column(
      // 列布局，垂直排列子组件
      mainAxisSize: MainAxisSize.min, // 主轴尺寸设为最小值
      children: [
        // 子组件列表
        Stack(
          // 堆叠布局，用于叠加组件
          children: [
            Column(
                // 列布局，用于垂直排列子组件
                mainAxisSize: MainAxisSize.min, // 主轴尺寸设为最小值
                crossAxisAlignment: CrossAxisAlignment.start, // 交叉轴对齐方式设为起始端
                children: [
                  // 子组件列表
                  Padding(
                    // 内边距组件，用于设置子组件的内边距
                    padding: const EdgeInsets.all(8.0), // 设置四周的内边距为8
                    child: Text(
                      // 文本组件，显示课程名称
                      course.name, // 显示课程名称
                      style: TextStyle(color: Colors.blue), // 文本样式，蓝色
                    ),
                  ),
                  Padding(
                    // 内边距组件，用于设置子组件的内边距
                    padding: const EdgeInsets.all(8.0), // 设置四周的内边距为8
                    child: Row(
                      // 行布局，水平排列子组件
                      children: [
                        // 子组件列表
                        Text("教室: "), // 文本组件，显示“教室: ”
                        Text(course.classRoom), // 文本组件，显示课程的教室信息
                      ],
                    ),
                  ),
                  Padding(
                    // 内边距组件，用于设置子组件的内边距
                    padding: const EdgeInsets.all(8.0), // 设置四周的内边距为8
                    child: Row(
                      // 行布局，水平排列子组件
                      children: [
                        // 子组件列表
                        Text("周数: "), // 文本组件，显示“周数: ”
                        Selector<Store, int>(
                          // 选择器组件，根据Store中的数据进行更新
                          selector: (context, model) =>
                              model.maxWeekNum, // 选择器函数，选择最大周数
                          builder: (context, model, child) {
                            // 构建函数，根据选择器函数的结果构建UI
                            return Text(Util.getFormatStringFromWeekOfTerm(
                                // 文本组件，显示格式化后的周数信息
                                course.weekOfTerm,
                                model)); // 调用工具类方法获取格式化后的周数信息
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    // 内边距组件，用于设置子组件的内边距
                    padding: const EdgeInsets.all(8.0), // 设置四周的内边距为8
                    child: Row(
                      // 行布局，水平排列子组件
                      children: [
                        // 子组件列表
                        Text("节数: "), // 文本组件，显示“节数: ”
                        Text(// 文本组件，显示课程的节数信息
                            "${Util.getDayOfWeekString(course.dayOfWeek)} ${course.classStart}-${course.classStart + course.classLength - 1}节"), // 使用工具类方法获取星期和节数范围，并进行拼接
                      ],
                    ),
                  ),
                  Padding(
                    // 内边距组件，用于设置子组件的内边距
                    padding: const EdgeInsets.all(8.0), // 设置四周的内边距为8
                    child: Row(
                      // 行布局，水平排列子组件
                      children: [
                        // 子组件列表
                        Text("老师: "), // 文本组件，显示“老师: ”
                        Text(course.teacher), // 文本组件，显示课程的老师信息
                      ],
                    ),
                  ),
                  Padding(
                    // 内边距组件，用于设置子组件的内边距
                    padding: const EdgeInsets.all(8.0), // 设置四周的内边距为8
                    child: Row(
                      // 行布局，水平排列子组件
                      children: [
                        // 子组件列表
                        Text("班级: "), // 文本组件，显示“老师: ”
                        Text(course.group), // 文本组件，显示课程的老师信息
                      ],
                    ),
                  ),
                  Padding(
                    // 内边距组件，用于设置子组件的内边距
                    padding:
                        const EdgeInsets.fromLTRB(0, 8, 0, 0), // 设置四周的内边距，上边距为8
                    child: Divider(
                      // 分割线组件，用于在UI中添加分隔线
                      height: 1.0, // 分割线高度为1.0
                    ),
                  ),
                  Container(
                    // 容器组件，用于包裹删除和修改按钮
                    height: 48, // 容器高度为48
                    child: Row(
                      // 行布局，水平排列子组件
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch, // 交叉轴对齐方式设为拉伸
                      children: [
                        // 子组件列表
                        Expanded(
                          // 扩展组件，用于占据剩余空间
                          /* 删除 */ // 删除按钮
                          child: TextButton(
                            // 文本按钮组件，用于显示删除按钮
                            onPressed: () {
                              // 点击事件，显示确认对话框进行删除操作确认
                              DialogUtil.showConfirmDialog(
                                  // 调用工具类方法显示确认对话框
                                  context,
                                  "您确定要删除${course.name}吗？只会从课表上删除，但不会删除课程，请谨慎操作！", () {
                                // 对话框标题和内容
                                if (Provider.of<Store>(context,
                                        listen:
                                            false) // 使用Provider获取Store实例，并调用deleteCourseByCourse方法删除课程
                                    .deleteCourseByCourse(course)) {
                                  // 调用删除课程的方法，如果删除成功
                                  Util.showToastCourse("删除${course.name}成功",
                                      context); // 调用工具类方法显示删除成功的提示信息
                                } else {
                                  // 如果删除失败
                                  Util.showToastCourse("删除${course.name}失败",
                                      context); // 调用工具类方法显示删除失败的提示信息
                                }
                                Navigator.pop(context); // 关闭确认对话框
                              });
                            },
                            child: Icon(
                              // 图标组件，显示删除图标
                              Icons.delete, // 删除图标
                              color: Colors.red, // 图标颜色为红色
                            ),
                            style: ButtonStyle(
                                // 按钮样式
                                foregroundColor: // 前景色
                                    MaterialStateProperty.all(
                                        Colors.black)), // 按钮前景色为黑色
                          ),
                        ),
                        Expanded(
                          // 扩展组件，用于占据剩余空间
                          /* 修改 */ // 修改按钮
                          child: TextButton(
                            // 文本按钮组件，用于显示修改按钮
                            onPressed: () {
                              // 点击事件，跳转到编辑课程页面进行课程信息的修改
                              Navigator.pop(context); // 关闭当前页面
                              Navigator.push(context, // 导航到新页面
                                  MaterialPageRoute(builder: (context) {
                                // 构建新页面
                                return EditCoursePage(
                                  // 返回编辑课程页面
                                  index: Store.getInstanceReadMode(
                                          context) // 获取Store实例，并获取课程在列表中的索引
                                      .courses // 获取课程列表
                                      .indexOf(course), // 获取当前课程在列表中的索引
                                  isAppended: false, // 标记是否追加课程
                                );
                              }));
                            },
                            child: Icon(
                              // 图标组件，显示编辑图标
                              Icons.edit, // 编辑图标
                              color: Colors.blue, // 图标颜色为蓝色
                            ),
                            style: ButtonStyle(
                                // 按钮样式
                                foregroundColor: // 前景色
                                    MaterialStateProperty.all(
                                        Colors.black)), // 按钮前景色为黑色
                          ),
                        ),
                        Expanded(
                          // 扩展组件，用于占据剩余空间
                          /* 修改 */ // 修改按钮
                          child: TextButton(
                            // 文本按钮组件，用于显示修改按钮
                            onPressed: () async {
                              await jumPage(course, context);
                            },
                            child: Icon(
                              // 图标组件，显示编辑图标
                              Icons.arrow_forward, // 编辑图标
                              color: Colors.blue, // 图标颜色为蓝色
                            ),
                            style: ButtonStyle(
                              // 按钮样式
                                foregroundColor: // 前景色
                                MaterialStateProperty.all(
                                    Colors.black)), // 按钮前景色为黑色
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
            Align(
              // 对齐组件，用于对齐子组件
              alignment: Alignment.topRight, // 对齐方式为右上角
              child: InkWell(
                  // 水波纹点击组件
                  child: Icon(
                    // 图标组件，显示关闭图标
                    Icons.close, // 关闭图标
                    size: 24, // 图标尺寸为24
                  ),
                  onTap: () => Navigator.of(context).pop()), // 点击事件，关闭课程详情页
            ),
          ],
        ),
      ],
    );
  }
  Future<void> jumPage(Course course,BuildContext context) async {
    UserDb? user = await DataBaseManager.queryUserById(await SharedPreferencesUtil.getPreference('userID', 0));
    bool isEnlight = course.courseNum!="";
    Schedule? schedule;
    if(isEnlight){
      schedule = await ApiClientSchdedule.searchCourse(course.courseNum);
    }
    Navigator.pop(context); // 关闭当前页面
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      if(user!.userType=='01'){
        return isEnlight ? CoursePage(index: 0,backgroundColor: Values.bgWhite,className: course.name,schedule: schedule!,) :
        CourseImportPage(course: course,isTeacher: true,);
      }else if(user.userType=='02'){
        return isEnlight ? CoursePage(index: 0,backgroundColor: Values.bgWhite,className: course.name,schedule: schedule!,) :
        CourseImportPage(course: course,isTeacher: false,);
      }
      return CoursePage(index: 0,backgroundColor: Values.bgWhite,className: course.name,schedule: schedule!,);
    })
    );
  }
}
