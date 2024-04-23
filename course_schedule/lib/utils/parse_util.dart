import 'dart:convert';
import 'dart:developer';

import 'package:course_schedule/utils/shared_preferences_util.dart';
import 'package:course_schedule/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';
import '../components/select_term_dialog.dart';
import '../model/course.dart';
import '../pages/tabs/home/home_page_view_model.dart';
import '../provider/store.dart';

class ParseUtil {
  ParseUtil._(); // 私有构造函数，防止类被实例化
  static final ParseUtil instance = ParseUtil._();
  // 导入课表
  void importTimetable(String html, BuildContext context) async {
    // 在这里解析课表数据并导入
    List<Course> courses = parseCourseTableHtml(html);
    String xnxq = getCourseTerm(html);
    await SharedPreferencesUtil.savePreference('term', xnxq);
    List<String> terms = [xnxq];
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
    if(res!){
      Store.getInstanceReadMode(context).courses = courses;
      Util.showToastCourse("导入课程成功",context);
    }else{
      Util.showToastCourse("导入课程失败，服务端出错",context);
    }
  }
  // 这个函数接受一个包含课程的列表作为输入参数，并返回一个不包含重复课程的新列表。
  List<Course> removeDuplicates(List<Course> courses) {
    // 创建一个空的 Set 来存储课程的唯一标识符
    Set<String> courseSet = Set<String>();
    // 创建一个空的列表来存储不重复的课程
    List<Course> uniqueCourses = [];
    // 遍历输入的课程列表
    for (Course course in courses) {
      // 使用课程的各个属性构建唯一的标识符
      String courseKey = '${course.name}-${course.teacher}-${course.classLength}-${course.classStart}-${course.classRoom}-${course.weekOfTerm}-${course.dayOfWeek}';
      // 如果课程的标识符不在 Set 中，说明该课程是唯一的
      if (!courseSet.contains(courseKey)) {
        // 将课程添加到不重复的课程列表中
        uniqueCourses.add(course);
        // 将课程的标识符添加到 Set 中，以便后续进行重复性检查
        courseSet.add(courseKey);
      }
    }
    // 返回不重复的课程列表
    return uniqueCourses;
  }
  List<Course> parseCourseTableHtml(String html) {
    List<String> courseListHtml = getCourseListHtml(html);
    List<String> courseList = getCourseList(courseListHtml);
    List<Course> courses_start = parseCourseList(courseList);
    List<Course> courses = removeDuplicates(courses_start);
    return courses;
  }
  String getCourseTerm(String htmlString){
    var document = parser.parse(htmlString); // 使用 html 包解析 HTML 字符串
    var select1 = document.querySelector('#xnd');
    var selectedOption1 = select1?.querySelector('option[selected]')?.attributes['value'];
    var select2 = document.querySelector('#xqd');
    var selectedOption2 = select2?.querySelector('option[selected]')?.attributes['value'];
    var xnxq = '$selectedOption1学年 第$selectedOption2学期';
    return xnxq;
  }
  List<String> getCourseListHtml(String htmlString) {
    var document = parser.parse(htmlString); // 使用 html 包解析 HTML 字符串
    var courseRows = document.querySelectorAll("#Table1 tr");
    var courseHtmlList = <String>[]; // 创建一个字符串列表用于存储课程HTML
    for (var row in courseRows) { // 遍历课程行
      // log('row:${row.innerHtml}');
      var dateListTdsString = row.querySelectorAll("td[rowspan='2']"); // 获取当前行下具有rowspan=2属性的td元素
      for (var td in dateListTdsString) { // 遍历td元素列表
        var courseHtml = td.outerHtml; // 将td元素转换为字符串并添加到课程HTML列表中
        // log('courhtml:$courseHtml');
        courseHtmlList.add(courseHtml);
      }
    }
    // log('我在getCourseListHtml：${courseHtmlList.toString()}');
    return courseHtmlList; // 返回课程HTML列表
  }
  List<String> getCourseList(List<String> courseListHtml) {
    // 删除调课信息, \\s 表示匹配任何空白字符，<font.*?> 用来匹配开始的 <font> 标签并使用非贪婪模式匹配尽可能少的字符，(.*?) 用来捕获 <font> 标签内的所有内容，而 </font> 匹配闭合的 </font> 标签。
    String regexFont = "\\s<font.*?>(.*?)</font>";
    // 删除所有html标签，但保留标签内内容
    String regexHtml = "<[^>]+(>*)";
    // 删除期末考试时间信息
    String regexExam = "\\s(\\d{4})年(\\d{2})月(\\d{2})日(\\S+)\\s*(\\S*)";
    List<String> courseList = [];
    String insertExtraSpace(String schedule) {
      RegExp regExp = RegExp(r'教\d+\s'); // 匹配'教'后面跟着数字和一个空格
      return schedule.replaceAllMapped(regExp, (Match match) => '${match.group(0)} '); // 在匹配到的字符串后加上一个空格
    }
    for (String courseHtml in courseListHtml) {
      // 将两个 <br> 替换为两个空格
      // 将单个 <br> 替换为一个空格
      // 删除所有 <font> 标签及其内部内容
      // 删除所有 HTML 标签，但保留标签内的内容
      // 删除期末考试时间信息
      String courses = courseHtml
          .replaceAll(RegExp("<br><br>"), "  ")
          .replaceAll(RegExp("<br>"), " ")
          .replaceAll(RegExp(regexFont), "")
          .replaceAll(RegExp(regexHtml), "")
          .replaceAll(RegExp(regexExam), "");
      if(courses.split(RegExp("\\s{1}")).length >=8){
        courses=insertExtraSpace(courses);
      }
      // 使用两个空格拆分字符串，将结果添加到课程列表中
      courseList.addAll(courses.split(RegExp("\\s{2}")));
    }
    // log('我在getCourseList，我是字符串列表courseList：$courseList');
    return courseList;
  }
  // (\S+) 匹配课程名称，如 "大学英语(Ⅳ)"。
  // 周(\S) 匹配星期几，如 "周二"。
  // 第(\d+),(\d+)节 匹配上课的节次，如 "第1,2节"。
  // \{第(\d+)-(\d+)周 匹配上课的开始周和结束周，如 "第1-16周"。
  // (\S*)\} 匹配特殊的周信息，如 "双周"，如果有的话。
  // (\S+) 匹配任课老师的名字，如 "王科"。
  // (\S+) 匹配上课地点，如 "教2026"。
  List<Course> parseCourseList(List<String> courseList) {
    // 定义方法，解析课程列表并返回Course列表
    const regexCourse = r'(\S+) 周(\S)第(\d+),(\d+)节\{第(\d+)-(\d+)周(\S*)\} (\S+) (\S+)';
    final pattern = RegExp(regexCourse); // 编译正则表达式为RegExp对象
    final courses = <Course>[]; // 创建一个Course列表用于存储课程信息
    for (final str in courseList) {
      // 遍历课程列表
      final course = Course(); // 创建一个Course对象
      final matchedStr = str.replaceAll('|', ''); // 替换课程信息中的竖线字符
      // print('我是matchStr：$matchedStr');
      final match = pattern.firstMatch(matchedStr); // 使用正则表达式匹配课程信息
      int classStart=0;
      int startWeek=1;
      int endWeek=25;
      if (match != null) {
        // 如果匹配成功
        for (var i = 1; i <= match.groupCount; i++) {
          // 遍历匹配的组
          final text = match.group(i) ?? ''; // 获取当前组的文本内容
          switch (i) {
          // 根据组的索引进行处理
            case 1:
              course.name = text; // 设置课程名称
              break;
            case 2:
              course.dayOfWeek = setDayOfWeek(text); // 设置课程性质
              break;
            case 3:
              classStart = int.parse(text); // 设置星期几
              course.classStart=classStart;
              break;
            case 4:
              course.classLength = int.parse(text)-classStart+1; // 设置第几节
              break;
            case 5:
              startWeek = int.parse(text); // 设置开课周
              break;
            case 6:
              endWeek = int.parse(text); // 设置结课周
              break;
            case 7:
              course.weekOfTerm = setWeekOfTerm(startWeek, endWeek,text: text);
              break;
            case 8:
              course.teacher = text; // 设置任课老师
              break;
            case 9:
              final room = text.isEmpty ? '暂无安排' : text; // 如果教室地点为空，则设置为"暂无安排"
              course.classRoom = room; // 设置教室地点
              break;
          }
        }
        courses.add(course); // 将Course对象添加到列表中
        // print(course.toJson()); // 打印课程信息
      }
    }
    return courses; // 返回课程信息列表
  }
  List<Course> parseTeacherCourseList(List<String> courseList) {
    // ^：匹配字符串的开头
    // ([\u4e00-\u9fa5]+)：匹配一个或多个汉字，表示姓名或课程名称
    // \s+：匹配一个或多个空白字符
    // (\d+-\d+,\d+-\d+$\d,\d$)：匹配类似“1-11,13-17(1,2)”这样的数字范围和括号内的数字
    // \s+：匹配一个或多个空白字符
    // ([\u4e00-\u9fa5]+)：匹配一个或多个汉字，表示姓名或课程名称
    // \s+：匹配一个或多个空白字符
    // (\w+)：匹配一个或多个字母、数字或下划线，表示教室号
    // \s+：匹配一个或多个空白字符
    // (\w+)：匹配一个或多个字母、数字或下划线，表示班级号
    const regexTeacherCourse = r'(\S+) (\d+)-(\d+),(\d+)-(\d+)$(\d+),(\d+)$ (\S+) (\S+) (\S+)';
    final pattern = RegExp(regexTeacherCourse); // 编译正则表达式为RegExp对象
    final courses = <Course>[]; // 创建一个Course列表用于存储课程信息
    for (final str in courseList) {
      // 遍历课程列表
      final course = Course(); // 创建一个Course对象
      final matchedStr = str.replaceAll('|', ''); // 替换课程信息中的竖线字符
      // print('我是matchStr：$matchedStr');
      final match = pattern.firstMatch(matchedStr); // 使用正则表达式匹配课程信息
      int classStart=0;
      int startWeek=1;
      int endWeek=25;
      if (match != null) {
        // 如果匹配成功
        for (var i = 1; i <= match.groupCount; i++) {
          // 遍历匹配的组
          final text = match.group(i) ?? ''; // 获取当前组的文本内容
          switch (i) {
          // 根据组的索引进行处理
            case 1:
              course.name = text; // 设置课程名称
              break;
            case 2:
              course.dayOfWeek = setDayOfWeek(text); // 设置课程性质
              break;
            case 3:
              classStart = int.parse(text); // 设置星期几
              course.classStart=classStart;
              break;
            case 4:
              course.classLength = int.parse(text)-classStart+1; // 设置第几节
              break;
            case 5:
              startWeek = int.parse(text); // 设置开课周
              break;
            case 6:
              endWeek = int.parse(text); // 设置结课周
              break;
            case 7:
              course.weekOfTerm = setWeekOfTerm(startWeek, endWeek,text: text);
              break;
            case 8:
              course.teacher = text; // 设置任课老师
              break;
            case 9:
              final room = text.isEmpty ? '暂无安排' : text; // 如果教室地点为空，则设置为"暂无安排"
              course.classRoom = room; // 设置教室地点
              break;
          }
        }
        courses.add(course); // 将Course对象添加到列表中
        // print(course.toJson()); // 打印课程信息
      }
    }
    return courses; // 返回课程信息列表
  }

  int setDayOfWeek(String text){
    return text == '一' ? 1
        : text == '二' ? 2
        : text == '三' ? 3
        : text == '四' ? 4
        : text == '五' ? 5
        : text == '六' ? 6
        : text == '日' ? 7
        : 7;
  }
  int setWeekOfTerm(int startWeek, int endWeek, {String? text}) {
    int weekOfTerm = 0; // 初始化weekOfTerm为0，所有位均为0
    // eg:startWeek=3,endWeek=5
    for (int week = startWeek; week <= endWeek; week++) {
      if (text == null) {
        weekOfTerm |= (1 << (25 - week));
      } else if (text == "单周" && week % 2 == 0) {
        // 处理单周
        week+=1;
        weekOfTerm |= (1 << (25 - week));
      } else if (text == "双周" && week % 2 == 1) {
        // 处理双周
        week+=1;
        weekOfTerm |= (1 << (25 - week));
      }else{
        weekOfTerm |= (1 << (25 - week));
      }
    }
    return weekOfTerm; // 返回包含了从startWeek到endWeek所有周的weekOfTerm，即 00011100(28)
  }
}
