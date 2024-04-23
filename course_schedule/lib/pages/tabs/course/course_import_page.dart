import 'dart:math'; // 导入dart:math库，用于数学计算

import 'package:course_schedule/db/database_manager.dart';
import 'package:course_schedule/model/index.dart';
import 'package:course_schedule/model/member.dart';
import 'package:course_schedule/utils/shared_preferences_util.dart';
import 'package:flutter/cupertino.dart'; // 导入Flutter的Cupertino库，用于iOS风格的UI组件
import 'package:flutter/material.dart'; // 导入Flutter的material库，包含Flutter应用程序的基本组件和风格
import 'package:course_schedule/components/pickerview/picker_view.dart'; // 导入自定义的PickerView组件
import 'package:course_schedule/components/pickerview/picker_view_popup.dart'; // 导入自定义的PickerViewPopup组件
import 'package:course_schedule/model/course.dart'; // 导入课程模型类
import 'package:course_schedule/provider/store.dart'; // 导入Store提供者类，用于管理课程数据状态
import 'package:course_schedule/utils/dialog_util.dart'; // 导入对话框工具类，用于显示对话框
import 'package:course_schedule/utils/util.dart'; // 导入工具类，包含一些常用的工具方法
import 'package:flutter/services.dart';

import '../../../net/apiClientSchedule.dart'; // 导入Flutter的services库，用于访问底层系统服务

class CourseImportPage extends StatefulWidget {
  final Course course;
  final bool isTeacher;
  CourseImportPage(
      {required this.course,required this.isTeacher, Key? key}) // 构造函数
      : super(key: key); // 调用父类构造函数
  @override
  _CourseImportPageState createState() => _CourseImportPageState(); // 创建状态对象
}

class _CourseImportPageState extends State<CourseImportPage> {
  late final TextEditingController _teacherController; // 教师输入框控制器
  late final TextEditingController _groupController; // 班级输入框控制器
  late final TextEditingController _courseNumController;
  late final Store store; // 获取Store实例
  String term = "";
  @override
  void initState() {
    // 初始化状态
    super.initState(); // 调用父类方法
    _loadTerm();
    _teacherController = TextEditingController(text: widget.course.teacher); // 初始化教师输入框控制器
    _groupController = TextEditingController(text: widget.course.group);
    _courseNumController = TextEditingController(text: "");
    store = Store.getInstanceReadMode(context);
  }
  Future<void> _loadTerm() async {
    String xnxq = await SharedPreferencesUtil.getPreference('term', '2021-2022学年 第1学期');
    setState(() {
      term = xnxq;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 构建UI界面的方法
    return Scaffold(
      // 脚手架组件，用于构建页面的基本结构
      appBar: AppBar(
        // 应用栏，位于页面顶部
        title: Text(widget.course.name), // 标题文本
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
                          controller: TextEditingController(text: widget.course.name), // 设置初始值为widget.name
                          enabled: false, // 设置为禁用状态
                          decoration: InputDecoration(
                            hintText: "请填写课程名",
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
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
                            const Text(
                              // 文本组件，显示“教室: ”
                              "学期: ", // 文本内容
                              style: TextStyle(fontSize: 18), // 文本样式
                            ),
                            Expanded(
                              // 扩展组件，填充剩余空间
                              child: TextField(
                                // 文本输入框组件
                                controller: TextEditingController(text: term),
                                enabled: false, // 设置为禁用状态
                                decoration: const InputDecoration(
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
                              "老师: ", // 文本内容
                              style: const TextStyle(fontSize: 18), // 文本样式
                            ),
                            Expanded(
                              // 扩展组件，填充剩余空间
                              child: TextField(
                                // 文本输入框组件
                                controller: _teacherController, // 控制器
                                enabled: false,
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
                        if(widget.isTeacher)
                          Row(
                            // 行布局，水平排列子组件
                            children: [
                              // 子组件列表
                              const Text(
                                // 文本组件，显示“老师: ”
                                "班级: ", // 文本内容
                                style: TextStyle(fontSize: 18), // 文本样式
                              ),
                              Expanded(
                                // 扩展组件，填充剩余空间
                                child: TextField(
                                  // 文本输入框组件
                                  controller: _groupController, // 控制器
                                  decoration: InputDecoration(
                                    // 输入框装饰
                                    hintText: "请输入教学班", // 提示文本
                                    border: InputBorder.none, // 去除边框
                                  ),
                                  style: const TextStyle(fontSize: 18), // 文本样式
                                ),
                              )
                            ],
                          ),
                        if(!widget.isTeacher)
                          Row(
                            // 行布局，水平排列子组件
                            children: [
                              // 子组件列表
                              const Text(
                                // 文本组件，显示“老师: ”
                                "云课号: ", // 文本内容
                                style: TextStyle(fontSize: 18), // 文本样式
                              ),
                              Expanded(
                                // 扩展组件，填充剩余空间
                                child: TextField(
                                  // 文本输入框组件
                                  controller: _courseNumController, // 控制器
                                  decoration: InputDecoration(
                                    // 输入框装饰
                                    hintText: "请输入教师所给云课号", // 提示文本
                                    border: InputBorder.none, // 去除边框
                                  ),
                                  style: const TextStyle(fontSize: 18), // 文本样式
                                ),
                              )
                            ],
                          ),
                      ],
                    ),
                ),
              ),
            ),
            Padding(
              // 内边距组件，设置上方内边距
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0), // 上方内边距
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: SizedBox(
                  height: 50, // 设置按钮的高度与卡片的高度一致
                  width: 360,
                  child: widget.isTeacher? ElevatedButton(
                    onPressed: _saveActionTeacher,
                    child: const Text('开通课程', style: TextStyle(color: Colors.white,fontSize: 16)),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
                    ),
                  ) : ElevatedButton(
                    onPressed: _saveActionStu,
                    child: const Text('进入课程', style: TextStyle(color: Colors.white,fontSize: 16)),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveActionTeacher() async {
    // List<Schedule> ss= await DataBaseManager.queryAllSchedule();
    // for(var s in ss){
    //   await DataBaseManager.deleteSchedule(s);
    // }
    // return;
    Schedule? s1= await DataBaseManager.findScheduleByCourseNum(widget.course.courseNum);
    if(s1!=null || widget.course.courseNum!=""){
      Util.showToastCourse("课程已存在，云课号${s1?.courseNum}，请重新进入！", context);
      return;
    }
    // 保存操作的方法
    Util.cancelFocus(context); // 取消焦点
    if (_groupController.text.trim().isEmpty) {
      DialogUtil.showTipDialog(context, "请输入教学班名称"); // 显示提示对话框
      return; // 返回
    }
    Schedule schedule = Schedule();
    schedule.courseName=widget.course.name;
    schedule.term = term;
    schedule.clazzName = _groupController.text.trim();
    schedule.teacherName = widget.course.teacher;
    schedule.teacherId = await SharedPreferencesUtil.getPreference('userID', 0);
    await DialogUtil.showConfirmDialog(context, "您确定要开通该课程吗", () async {
      // 发请求，保存数据库
      Schedule sche = await ApiClientSchdedule.createCourse(schedule);
      await DataBaseManager.insertSchedule(sche);
      // 保存云课号
      saveCourseNumStore(sche.courseNum!);
      // 修改完毕
      Util.showToastCourse("课程已开通！", context); // 显示成功提示信息
      DialogUtil.showTipDialog(context, "${schedule.clazzName}的云课号为：${widget.course.courseNum}，请将该云课号告知本课程学生，加入本课程。");
    },cancelBtnClick: (){
      return;
    });
  }
  Future<void> _saveActionStu() async {
    // 保存操作的方法
    Util.cancelFocus(context); // 取消焦点
    final Store store = Store.getInstanceReadMode(context); // 获取Store实例
    if (_courseNumController.text.trim().isEmpty) {
      DialogUtil.showTipDialog(context, "请输入云课号"); // 显示提示对话框
      return; // 返回
    }
    Member member = Member();
    member.userId = await SharedPreferencesUtil.getPreference('userID', 0);
    // 远程查找是否有该课程
    Schedule? sche = await ApiClientSchdedule.searchCourse(_courseNumController.text.trim());
    if(sche==null){
      Util.showToastCourse("请输入正确的云课号！", context);
      return;
    }
    member.courseId = sche.courseId;
    // 保存云课号到对应课程，并修改课表
    saveCourseNumStore(sche.courseNum!);
    await DialogUtil.showConfirmDialog(context, "您确定要进入该课程吗", () async {
      // 发请求，保存数据库
      Member? mem = await ApiClientSchdedule.addMember(member);
      await DataBaseManager.insertMember(mem);
      // 修改完毕
      Util.showToastCourse("已关联课程，点击进入图标进入课程！", context); // 显示成功提示信息
    },cancelBtnClick: (){
      return;
    });
  }
  void saveCourseNumStore(String courseNum){
    final List<Course> courses_copy = List.from(store.courses);
    courses_copy.removeAt(store.courses.indexOf(widget.course));
    widget.course.courseNum = courseNum;
    courses_copy.add(widget.course);
    store.courses = courses_copy;
  }
}
