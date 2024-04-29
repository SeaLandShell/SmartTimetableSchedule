import 'dart:convert'; // 导入dart:convert模块，用于JSON编解码
import 'dart:math';

import 'package:flutter/material.dart'; // 导入Flutter框架的Material组件库
import 'package:course_schedule/entity/time.dart'; // 导入自定义的TimeEntity类
import 'package:course_schedule/model/course.dart'; // 导入自定义的Course类
import 'package:course_schedule/utils/file_util.dart'; // 导入自定义的文件工具类
import 'package:course_schedule/utils/shared_preferences_util.dart'; // 导入自定义的SharedPreferences工具类
import 'package:course_schedule/utils/util.dart'; // 导入自定义的工具类
import 'package:path/path.dart'; // 导入path库，用于处理文件路径
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../components/select_term_dialog.dart'; // 导入provider库，用于状态管理

class Store extends ChangeNotifier {
  // 定义Store类，继承自ChangeNotifier，用于管理应用状态
  static const COURSE_JSON_FILE_NAME = "timetable.json"; // 定义课程JSON文件的文件名常量

  // 当前周数
  int currentWeek = 1;

  // 最大周数
  int maxWeekNum = 25;

  // 课程列表
  List<Course>? _courses; // 课程列表，使用可空类型List<Course>?

  List<Course> get courses => _courses ?? const []; // 获取课程列表，使用getter方法

  List<TimeEntity> _classTime = []; // 课程时间列表，初始为空列表

  List<TimeEntity> get classTime => _classTime; // 获取课程时间列表，使用getter方法

  set classTime(List<TimeEntity> list) {
    // 设置课程时间列表，使用setter方法
    if (_classTime != list) {
      // 判断传入的列表是否与当前列表相同
      _classTime = list; // 更新课程时间列表
      notifyListeners(); // 通知监听器，状态已更新
      SharedPreferencesUtil.savePreference(
          // 保存课程时间到SharedPreferences中
          SharedPreferencesKey.CLASS_TIME,
          json.encode(_classTime));
    }
  }

  set courses(List<Course>? courses) {
    // 设置课程列表，使用setter方法
    if (_courses == courses) {
      // 判断传入的列表是否与当前列表相同
      return; // 若相同则直接返回，不做处理
    }
    _courses = courses ?? const []; // 更新课程列表，若传入列表为空则使用空列表
    _courses!.sort(); // 对课程列表进行排序
    saveCourses(); // 保存课程列表
    notifyListeners(); // 通知监听器，状态已更新
    // print('我在setcourse里面，且已工作(已保存、已通知)完成，course：$_courses');
  }

  Future<void> saveCourses() async {
    // 保存课程列表到本地文件
    // for(int i=0;i<courses.length;i++){print(courses[i].toJson());}
    // final directory = (await getApplicationDocumentsDirectory()).path; // 获取应用程序文档目录路径
    // final path = "$directory/json/$COURSE_JSON_FILE_NAME";
    // print(FileUtil.delete(path));
    List<String> terms = [await SharedPreferencesUtil.getPreference('term', "2023-2024学年 第2学期")];
    List<String> courses_str = [];
    for (String term in terms) {
      List<Course> list = courses;
      list.sort((a, b) => a.compareTo(b));
      String jsonString = jsonEncode(list);
      courses_str.add(jsonString);
    }
    // 获取当前用户ID，并上传课表
    int userID = await SharedPreferencesUtil.getPreference('userID', -1);
    bool? res = await addCalendar(userID,terms,courses_str);
    if(!res!){
      Util.showToastCourse("服务端数据联动失败，请检查网络！",context as BuildContext);
      return;
    }
    FileUtil.saveAsJson(COURSE_JSON_FILE_NAME, json.encode(courses))
        .then((success) {
      // 使用FileUtil工具类保存课程列表到JSON文件
      if (!success) {
        // 若保存失败
        Util.showToastCourse("课表保存到本地失败！",context as BuildContext); // 弹出提示信息
      }
    });
  }

  bool deleteCourseByIndex(int index) {
    // 根据索引删除课程
    if (index >= 0 && index < courses.length) {
      // 判断索引是否有效
      courses.removeAt(index); // 删除指定索引处的课程
      courses = List.from(courses); // 更新课程列表
      notifyListeners(); // 通知监听器，状态已更新
      return true; // 返回删除成功
    }
    return false; // 返回删除失败
  }

  bool deleteCourseByCourse(Course course) {
    // 根据课程对象删除课程
    return deleteCourseByIndex(
        courses.indexOf(course)); // 调用deleteCourseByIndex方法
  }

  void updateCurrentWeek(int currentWeek) {
    // 更新当前周数
    if (this.currentWeek == currentWeek) {
      // 判断当前周数是否与传入的周数相同
      return; // 若相同则直接返回，不做处理
    }
    this.currentWeek = currentWeek; // 更新当前周数
    notifyListeners(); // 通知监听器，状态已更新
    SharedPreferencesUtil.savePreference(SharedPreferencesKey.CURRENT_WEEK,
            Util.getWeekSinceEpoch() - currentWeek)
        .catchError((error) {
      // 使用SharedPreferencesUtil保存当前周数到SharedPreferences中
      print(error); // 打印错误信息
      Util.showToastCourse("保存当前周数失败", context as BuildContext); // 弹出提示信息
    });
  }

  static Store getInstance(BuildContext context, {bool listen = false}) {
    // 获取Store实例
    return Provider.of<Store>(context, listen: listen); // 使用Provider获取Store实例
  }

  static Store getInstanceReadMode(BuildContext context) {
    // 获取只读模式的Store实例
    return getInstance(context, listen: false); // 使用Provider获取Store实例
  }

  Future<void> updateLoginState() async {
    _courses = [];
    SharedPreferencesUtil.remove('userID');
    SharedPreferencesUtil.remove('phoneNumber');
    SharedPreferencesUtil.remove('college_name');
    final directory = (await getApplicationDocumentsDirectory()).path;
    final path = "$directory/json/$COURSE_JSON_FILE_NAME";
    FileUtil.delete(path);
    notifyListeners();
  }
}
