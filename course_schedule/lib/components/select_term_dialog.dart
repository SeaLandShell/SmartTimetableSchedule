import 'package:course_schedule/utils/shared_preferences_util.dart';
import 'package:dio/dio.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:course_schedule/components/pickerview/picker_view.dart';
import 'package:course_schedule/components/pickerview/picker_view_popup.dart';
import 'package:course_schedule/model/course.dart';
import 'package:course_schedule/provider/store.dart';
import 'package:course_schedule/utils/http_util.dart';
import 'package:course_schedule/utils/util.dart';

/// 从网络获取学期选项
Future<List<String>> getTermOptionsFormInternet() async {
  int userID = await SharedPreferencesUtil.getPreference('userID', -1);
  final resp = await HttpUtil.client.get<String>("/ctimetable/college/term-options?userID=$userID"); // 发起网络请求获取学期选项
  final data = HttpUtil.getDataFromResponse(resp.data); // 解析响应数据
  if (data is List) {
    return data.cast<String>(); // 如果响应数据是列表，则转换为字符串列表并返回
  } else {
    return <String>[]; // 否则返回空列表
  }
}
Future<bool?> addCalendar(int userID,List<String> terms,List<String> courses) async {
  final resp = await HttpUtil.client.post("/ctimetable/college/addCalendar",
      data: {
        'userID': userID,
        'terms': terms,
        'courses': courses,
      });
  final data = HttpUtil.getDataFromResponse(resp.toString()); // 解析响应数据
  if (data is bool) {
    return data;
  } else {
    return false;
  }
}

/// 显示选择学期的对话框
Future<bool?> showSelectTermDialog(List<String?>? terms, BuildContext context) async {
  int userID = await SharedPreferencesUtil.getPreference('userID', -1);
  if (terms == null || terms.isEmpty) { // 如果学期选项为空，直接返回空
    return Future.value(null);
  }
  final List<String> _terms = [];
  for (var term in terms) {
    if (term != null && term.trim().isNotEmpty) {
      _terms.add(term); // 过滤空值和空字符串，并添加到_terms列表中
    }
  }

  final PickerController pickerController =
  PickerController(count: 1, selectedItems: [0]); // 创建选择器控制器

  return PickerViewPopup.showMode<bool>(
      PickerShowMode.BottomSheet, // 显示模式为底部弹出式对话框
      controller: pickerController,
      context: context,
      title: Text(
        '选择学期', // 对话框标题
        style: TextStyle(fontSize: 14),
      ),
      cancel: Text(
        '取消', // 取消按钮文本
        style: TextStyle(color: Colors.grey),
      ),
      confirm: Text(
        '确定', // 确定按钮文本
        style: TextStyle(color: Colors.blue),
      ),
      onConfirm: (controller) async { // 确认选择学期后的回调函数
        final term = _terms[controller.selectedRowAt(section: 0)!]; // 获取选中的学期
        final resp = await HttpUtil.client
            .get<String>("/ctimetable/college/timetable", queryParameters: {"term": term,'userID': userID}); // 发起获取课程表的网络请求

        final data = HttpUtil.getDataFromResponse(resp.toString()); // 解析响应数据
        final List<Course> courses = [];
        if (data is List) {
          data.forEach((v) {
            // print(v);
            courses.add(new Course.fromJson(v)); // 将响应数据转换为Course对象列表
          });
        }
        Store.getInstanceReadMode(context).courses = courses; // 将获取的课程列表存储到全局状态管理器中
        Util.showToastCourse("导入课程成功",context); // 弹出提示信息
      },
      builder: (context, popup) { // 对话框构建器
        return Container(
          height: 250,
          child: popup,
        );
      },
      itemExtent: 40, // 每一行的高度
      numberofRowsAtSection: (section) { // 获取每个section的行数
        return _terms.length; // 返回学期选项列表的长度
      },
      itemBuilder: (section, row) { // 构建每一行的子部件
        return Text(
          _terms[row], // 显示学期选项
          style: const TextStyle(fontSize: 14), // 文本样式
        );
      });
}