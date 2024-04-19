import 'dart:math'; // 导入dart:math库，用于数学计算

import 'package:flutter/cupertino.dart'; // 导入Flutter的Cupertino库，用于iOS风格的UI组件
import 'package:flutter/material.dart'; // 导入Flutter的material库，包含Flutter应用程序的基本组件和风格
import 'package:course_schedule/components/pickerview/picker_view.dart'; // 导入自定义的PickerView组件
import 'package:course_schedule/components/pickerview/picker_view_popup.dart'; // 导入自定义的PickerViewPopup组件
import 'package:course_schedule/models/course.dart'; // 导入课程模型类
import 'package:course_schedule/provider/store.dart'; // 导入Store提供者类，用于管理课程数据状态
import 'package:course_schedule/ui/editcourse/select_week_of_term.dart'; // 导入选择学期周数页面
import 'package:course_schedule/utils/dialog_util.dart'; // 导入对话框工具类，用于显示对话框
import 'package:course_schedule/utils/util.dart'; // 导入工具类，包含一些常用的工具方法
import 'package:flutter/services.dart'; // 导入Flutter的services库，用于访问底层系统服务

class EditCoursePage extends StatefulWidget {
  // 编辑课程页面的有状态组件
  final int index; // 课程在课程列表中的索引
  final bool isAppended; // 是否为添加课程

  EditCoursePage(
      {required this.index, required this.isAppended, Key? key}) // 构造函数
      : super(key: key); // 调用父类构造函数

  @override
  _EditCoursePageState createState() => _EditCoursePageState(); // 创建状态对象
}

class _EditCoursePageState extends State<EditCoursePage> {
  // 编辑课程页面的状态类
  late final Course course; // 课程对象

  late final TextEditingController _nameController; // 课程名称输入框控制器
  late final TextEditingController _locationController; // 教室输入框控制器
  late final TextEditingController _teacherController; // 教师输入框控制器
  late final TextEditingController _groupController; // 教师输入框控制器

  @override
  void initState() {
    // 初始化状态
    super.initState(); // 调用父类方法

    course = widget.isAppended // 如果是新增课程，则创建一个新的课程对象；否则，复制原课程对象
        ? Course() // 创建新的课程对象
        : Store.getInstanceReadMode(context)
            .courses[widget.index]
            .clone(); // 复制原课程对象

    _nameController = TextEditingController(text: course.name); // 初始化课程名称输入框控制器
    _locationController =
        TextEditingController(text: course.classRoom); // 初始化教室输入框控制器
    _teacherController =
        TextEditingController(text: course.teacher); // 初始化教师输入框控制器
    _groupController = TextEditingController(text: course.group);
  }

  @override
  Widget build(BuildContext context) {
    // 构建UI界面的方法
    return Scaffold(
      // 脚手架组件，用于构建页面的基本结构
      appBar: AppBar(
        // 应用栏，位于页面顶部
        title: Text("课表编辑"), // 标题文本
        actions: [
          // 右侧操作按钮
          if (!widget.isAppended) // 如果不是新增课程，则显示删除按钮
            IconButton(
                // 图标按钮
                splashRadius: 16, // 水波纹扩散的半径
                padding: const EdgeInsets.all(5), // 内边距
                icon: Icon(
                  // 图标
                  Icons.delete, // 删除图标
                  size: 24, // 图标大小
                ),
                tooltip: "删除", // 长按提示
                onPressed: _deleteAction), // 点击事件
          IconButton(
              // 图标按钮
              splashRadius: 16, // 水波纹扩散的半径
              padding: const EdgeInsets.all(5), // 内边距
              icon: Icon(
                // 图标
                Icons.save, // 保存图标
                size: 24, // 图标大小
              ),
              tooltip: "保存", // 长按提示
              onPressed: _saveAction) // 点击事件
        ],
        systemOverlayStyle: SystemUiOverlayStyle.light, // 系统覆盖样式，设置为浅色
      ),
      body: Padding(
        // 内边距组件，用于设置页面内容的内边距
        padding: const EdgeInsets.all(20), // 四周内边距均为20
        child: Column(
          // 列布局，垂直排列子组件
          children: [
            // 子组件列表
            Card(
                // 卡片组件，用于显示课程名称输入框
                shape: RoundedRectangleBorder(
                  // 卡片形状
                  borderRadius: BorderRadius.all(Radius.circular(20.0)), // 圆角矩形
                ),
                child: Container(
                  // 容器组件，包裹文本输入框
                  padding: const EdgeInsets.all(15.0), // 内边距
                  child: Row(
                    // 行布局，水平排列子组件
                    children: [
                      // 子组件列表
                      Text(
                        // 文本组件，显示“课程: ”
                        "课程: ", // 文本内容
                        style: const TextStyle(fontSize: 18), // 文本样式
                      ),
                      Expanded(
                        // 扩展组件，填充剩余空间
                        child: TextField(
                          // 文本输入框组件
                          controller: _nameController, // 控制器
                          decoration: InputDecoration(
                            // 输入框装饰
                            hintText: "请填写课程名", // 提示文本
                            border: InputBorder.none, // 去除边框
                          ),
                          style: const TextStyle(fontSize: 18), // 文本样式
                        ),
                      )
                    ],
                  ),
                )),
            Padding(
              // 内边距组件，设置上方内边距
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0), // 上方内边距
              child: Card(
                // 卡片组件，用于显示教室、上课时间等信息
                shape: RoundedRectangleBorder(
                  // 卡片形状
                  borderRadius: BorderRadius.all(Radius.circular(20.0)), // 圆角矩形
                ),
                child: Container(
                    // 容器组件，包裹教室、上课时间等信息
                    padding: const EdgeInsets.all(15.0), // 内边距
                    child: Column(
                      // 列布局，垂直排列子组件
                      mainAxisSize: MainAxisSize.min, // 主轴尺寸最小化
                      children: [
                        // 子组件列表
                        Row(
                          // 行布局，水平排列子组件
                          children: [
                            // 子组件列表
                            Text(
                              // 文本组件，显示“教室: ”
                              "教室: ", // 文本内容
                              style: const TextStyle(fontSize: 18), // 文本样式
                            ),
                            Expanded(
                              // 扩展组件，填充剩余空间
                              child: TextField(
                                // 文本输入框组件
                                controller: _locationController, // 控制器
                                decoration: InputDecoration(
                                  // 输入框装饰
                                  hintText: "可不填", // 提示文本
                                  border: InputBorder.none, // 去除边框
                                ),
                                style: const TextStyle(fontSize: 18), // 文本样式
                              ),
                            )
                          ],
                        ),
                        InkWell(
                          // 水波纹点击组件，用于选择学期周数
                          onTap: _selectWeekOfTerm, // 点击事件
                          child: Container(
                            // 容器组件
                            height: 48, // 容器高度
                            child: Row(
                              // 行布局，水平排列子组件
                              children: [
                                // 子组件列表
                                Text(
                                  // 文本组件，显示“周数: ”
                                  "周数: ", // 文本内容
                                  style: const TextStyle(fontSize: 18), // 文本样式
                                ),
                                Text(
                                  // 文本组件，显示选中的周数
                                  Util.getFormatStringFromWeekOfTerm(
                                      // 调用工具类方法，格式化学期周数
                                      course.weekOfTerm, // 当前课程的周数
                                      Store.getInstanceReadMode(
                                              context) // 获取Store实例，并获取最大周数
                                          .maxWeekNum), // 最大周数
                                  style: const TextStyle(fontSize: 18), // 文本样式
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          // 水波纹点击组件，用于选择上课节数
                          onTap: _selectClassIndex, // 点击事件
                          child: Container(
                            // 容器组件
                            height: 48, // 容器高度
                            child: Row(
                              // 行布局，水平排列子组件
                              children: [
                                // 子组件列表
                                Text(
                                  // 文本组件，显示“节数: ”
                                  "节数: ", // 文本内容
                                  style: const TextStyle(fontSize: 18), // 文本样式
                                ),
                                Text(
                                  // 文本组件，显示选中的节数
                                  _getClassIndexString(), // 调用方法获取选中的节数字符串
                                  style: const TextStyle(fontSize: 18), // 文本样式
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          // 行布局，水平排列子组件
                          children: [
                            // 子组件列表
                            Text(
                              // 文本组件，显示“老师: ”
                              "老师: ", // 文本内容
                              style: const TextStyle(fontSize: 18), // 文本样式
                            ),
                            Expanded(
                              // 扩展组件，填充剩余空间
                              child: TextField(
                                // 文本输入框组件
                                controller: _teacherController, // 控制器
                                decoration: InputDecoration(
                                  // 输入框装饰
                                  hintText: "可不填", // 提示文本
                                  border: InputBorder.none, // 去除边框
                                ),
                                style: const TextStyle(fontSize: 18), // 文本样式
                              ),
                            )
                          ],
                        ),
                        Row(
                          // 行布局，水平排列子组件
                          children: [
                            // 子组件列表
                            Text(
                              // 文本组件，显示“老师: ”
                              "班级: ", // 文本内容
                              style: const TextStyle(fontSize: 18), // 文本样式
                            ),
                            Expanded(
                              // 扩展组件，填充剩余空间
                              child: TextField(
                                // 文本输入框组件
                                controller: _groupController, // 控制器
                                decoration: InputDecoration(
                                  // 输入框装饰
                                  hintText: "可不填", // 提示文本
                                  border: InputBorder.none, // 去除边框
                                ),
                                style: const TextStyle(fontSize: 18), // 文本样式
                              ),
                            )
                          ],
                        ),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveAction() {
    // 保存操作的方法
    Util.cancelFocus(context); // 取消焦点
    _saveInput(); // 保存输入内容
    final Store store = Store.getInstanceReadMode(context); // 获取Store实例

    if (course.classLength == 0 || // 如果课程长度为0
        course.name.trim().isEmpty || // 或者课程名称为空
        !Util.isWeekOfTermValid(course.weekOfTerm, store.maxWeekNum)) {
      // 或者学期周数不合法
      DialogUtil.showTipDialog(context, "请填写课程名、上课时间、上课周数"); // 显示提示对话框
      return; // 返回
    }

    DialogUtil.showConfirmDialog(context, "您确定要保存该课程吗", () {
      // 显示确认对话框
      final List<Course> courses = List.from(store.courses); // 复制课程列表
      if (!widget.isAppended) {
        // 如果不是新增课程
        courses.removeAt(widget.index); // 移除原课程
      }
      courses.add(course); // 添加新课程
      store.courses = courses; // 更新课程列表
      Util.showToastCourse("修改课程成功", context); // 显示成功提示信息
      Navigator.of(context).pop(); // 返回上一页
    });
  }

  void _deleteAction() {
    // 删除操作的方法
    DialogUtil.showConfirmDialog(context, "您确定要删除${course.name}吗？", () {
      // 显示确认对话框
      if (Store.getInstanceReadMode(context) // 如果删除成功
          .deleteCourseByIndex(widget.index)) {
        // 调用删除课程方法
        Util.showToastCourse("删除${course.name}成功", context); // 显示成功提示信息
      } else {
        // 如果删除失败
        Util.showToastCourse("删除${course.name}失败", context); // 显示失败提示信息
      }
      Navigator.pop(context); // 返回上一页
    });
  }

  String _getClassIndexString() {
    // 获取选中的节数字符串的方法
    if (course.classLength > 0) {
      // 如果课程长度大于0
      return "${Util.getDayOfWeekString(course.dayOfWeek)} ${course.classStart}-${course.classStart + course.classLength - 1}节"; // 返回格式化的上课时间字符串
    } else {
      // 否则
      return "请选择节数"; // 返回提示信息
    }
  }

  void _saveInput() {
    // 保存输入内容的方法
    course.name = _nameController.text.trim(); // 保存课程名称
    course.teacher = _teacherController.text.trim(); // 保存教师名称
    course.classRoom = _locationController.text.trim(); // 保存教室信息
    course.group = _groupController.text.trim();
  }

  void _selectWeekOfTerm() {
    // 选择学期周数的方法
    Util.cancelFocus(context); // 取消焦点
    showModalBottomSheet(
        // 显示底部模态对话框
        context: context, // 上下文对象
        builder: (context) {
          // 对话框内容构建器
          return SelectWeekOfTerm(
            // 选择学期周数组件
            height: 300, // 高度
            weekOfTerm: course.weekOfTerm, // 当前学期周数
            okBtnOnClick: (states) {
              // 确定按钮点击事件
              setState(() {
                // 更新状态
                int weekOfTerm = 0; // 初始化学期周数
                for (int i = 0; i < states.length; i++) {
                  // 遍历每一周
                  if (states[i]) {
                    // 如果该周被选中
                    weekOfTerm += (1 << (states.length - 1 - i)); // 计算学期周数
                  }
                }
                course.weekOfTerm = weekOfTerm; // 更新课程的学期周数
              });
            },
          );
        });
  }

  static const week = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]; // 星期列表

  void _selectClassIndex() {
    // 选择上课节数的方法
    Util.cancelFocus(context); // 取消焦点

    PickerController pickerController = // 创建PickerController对象
        PickerController(count: 3, selectedItems: [
      // 初始化，包括3列选择器和默认选中项
      course.dayOfWeek - 1, // 星期几
      course.classStart - 1, // 起始节数
      course.classStart + course.classLength - 2 // 结束节数
    ]);

    PickerViewPopup.showMode(
        // 显示选择器弹窗
        PickerShowMode.BottomSheet, // 显示模式为底部弹窗
        controller: pickerController, // 选择器控制器
        context: context, // 上下文对象
        title: Text(
          // 弹窗标题
          '选择节数', // 标题文本
          style: TextStyle(fontSize: 14), // 文本样式
        ),
        cancel: Text(
          // 取消按钮文本
          '取消', // 文本内容
          style: TextStyle(color: Colors.grey), // 文本样式
        ),
        confirm: Text(
          // 确定按钮文本
          '确定', // 文本内容
          style: TextStyle(color: Colors.blue), // 文本样式
        ),
        onConfirm: (controller) {
          // 确认按钮点击事件
          setState(() {
            // 更新状态
            course.dayOfWeek =
                controller.selectedRowAt(section: 0)! + 1; // 更新星期几
            course.classStart =
                controller.selectedRowAt(section: 1)! + 1; // 更新起始节数
            course.classLength =
                controller.selectedRowAt(section: 2)! - // 更新课程长度
                    controller.selectedRowAt(section: 1)! +
                    1;
          });
        },
        onSelectRowChanged: (section, row) {
          // 选择器行改变事件
          if (section != 0) {
            // 如果不是星期选择器
            final classStart =
                pickerController.selectedRowAt(section: 1)!; // 获取起始节数
            final classEnd =
                pickerController.selectedRowAt(section: 2)!; // 获取结束节数
            if (classStart > classEnd) {
              // 如果起始节数大于结束节数
              pickerController.animateToRow(min(classStart + 1, 11), // 自动滚动到下一行
                  atSection: 2); // 在结束节数选择器中
            }
          }
        },
        builder: (context, popup) {
          // 弹窗内容构建器
          return Container(
            // 容器组件
            height: 250, // 高度
            child: popup, // 子组件为弹窗内容
          );
        },
        itemExtent: 40, // 选择项高度
        numberofRowsAtSection: (section) {
          // 每个选择器的行数
          switch (section) {
            // 根据选择器编号
            case 0: // 星期选择器
              return 7; // 返回7行，表示一周七天
            case 1: // 起始节数选择器
              return 12; // 返回12行，表示一天12节课
            case 2: // 结束节数选择器
              return 12; // 返回12行，表示一天12节课
            default: // 默认情况
              return 0; // 返回0行
          }
        },
        itemBuilder: (section, row) {
          // 每个选择器的行构建器
          if (section == 0) {
            // 如果是星期选择器
            return Text(
              // 文本组件
              week[row], // 星期文本
              style: TextStyle(
                // 文本样式
                fontSize: 12, // 字号为12
                fontFamily: Util.getDesktopFontFamily(), // 字体
              ),
            );
          } else {
            // 如果是起始节数或结束节数选择器
            return Text(
              // 文本组件
              '第${row + 1}节', // 文本内容，表示第几节课
              style: TextStyle(
                // 文本样式
                fontSize: 12, // 字号为12
                fontFamily: Util.getDesktopFontFamily(), // 字体
              ),
            );
          }
        });
  }
}
