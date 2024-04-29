// https://pub.dev/packages/group_list_view

import 'dart:developer';

import 'package:course_schedule/model/Upload.dart';
import 'package:course_schedule/model/index.dart';
import 'package:course_schedule/model/memberDTO.dart';
import 'package:course_schedule/model/memberDTOO.dart';
import 'package:course_schedule/pages/tabs/course/upload/teacherwork/correct_homework.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../components/clipper/bottom_curve_clipper.dart';
import '../../../../../data/values.dart';
import '../../../../../db/database_manager.dart';
import '../../../../../db/domain/user_db.dart';
import '../../../../../model/Work.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/http_util.dart';
import '../../../../../utils/shared_preferences_util.dart';



class SubmitedHomeworkPage extends StatefulWidget {
  final Schedule schedule;
  final Work work;
  const SubmitedHomeworkPage({super.key,required this.schedule,required this.work});

  @override
  State<SubmitedHomeworkPage> createState() => _SubmitedHomeworkPageState();
}

class _SubmitedHomeworkPageState extends State<SubmitedHomeworkPage> {
  /// 内容距状态栏的高度
  static const double topMargin = 32;
  static const double TodayCourseCardHeight = 40;
  double statusBarHeight = 0;
  double screenHeight = 0;
  double bottomNavBarHeight = 0;

  bool _loading = true; // 是否正在加载数据的标志
  bool isTeacher = false;
  final List<MemberDtoo> _data = [];

  @override
  void initState() {
    super.initState();
    isTeacherOrStu();
    getSubmit();
  }
  void isTeacherOrStu() async {
    int userID = await SharedPreferencesUtil.getPreference('userID', 0);
    UserDb? user = await DataBaseManager.queryUserById(userID);
    if(user?.userType=="01"){
      setState(() {isTeacher = true;});
    }else{
      setState(() {
        isTeacher = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    statusBarHeight = MediaQuery.of(context).padding.top; // 获取状态栏高度
    screenHeight = MediaQuery.of(context).size.height;
    bottomNavBarHeight = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      appBar: AppBar(title: Text(widget.schedule.courseName!),
        actions: [
          GestureDetector(
            onTap: (){
            },
            child: SizedBox(
              width: 76,
              child: Text(""),
            ),
          ),
        ],
      ),
      body: Container(
        color: Values.bgWhite, // 设置背景颜色为白色
        child: Stack(
          children: [
            // 使用ClipPath小部件，通过指定clipper来裁剪子部件
            ClipPath(
              // 指定裁剪的方式为BottomCurveClipper，传入一个偏移量作为参数
              clipper: BottomCurveClipper(offset: TodayCourseCardHeight / 2 + 8),
              // 子部件为一个Container容器
              child: Container(
                // 设置容器的高度，包括状态栏高度、顶部边距和用户卡片高度
                height: statusBarHeight + topMargin + TodayCourseCardHeight,
                // 设置容器的装饰，包括一个渐变背景色
                decoration: BoxDecoration(
                  // 定义一个线性渐变，指定起点和终点
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft, // 渐变起点为居中左侧
                      end: Alignment.centerRight, // 渐变终点为居中右侧
                      colors: [Colors.blue.shade400, Colors.blue.shade700] // 渐变色从浅蓝到深蓝
                  ),
                ),
                // 应用渐变背景色
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(28, 24, 0, 8),
                    child: Text("${widget.work.workName}学生提交情况",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 60, 16, 0),
              child: _buildExpansionTileCards(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpansionTileCards() {
    if (_loading) {
      return Center(child: CircularProgressIndicator()); // 显示加载指示器
    }
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: GestureDetector(
            onTap: (){
              if(!(_data[index].upload!.workName==null || _data[index].upload!.workName=="")){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return CorrectHomeworkPage(schedule: widget.schedule, upload: _data[index].upload!);
                }));
              }
            },
            child: Card(
              elevation: 8,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6.0),
                tileColor: Colors.white,
                selectedTileColor: Colors.lightBlueAccent.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                leading: CircleAvatar(
                  child: Text(
                    _getInitials(_data[index].memberDTO!.stuName!),
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  backgroundColor: _getAvatarColor(_data[index].memberDTO!.userId!.toString()),
                ),
                title: Text(
                  _data[index].memberDTO!.stuName!,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                subtitle: Text(
                  _data[index].memberDTO!.stuNum!,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                ),
                trailing:Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _data[index].upload!.workName==null || _data[index].upload!.workName==""
                        ? Text('暂未提交',style: TextStyle(fontSize: 13),) :
                         reviewState(_data[index].upload!.review!),
                    Icon(Icons.arrow_forward_ios,color: Colors.blue,),
                  ],
                ),
              ),
            ),
          ),);
      },
      itemCount: _data.length,
    );
  }

  Widget reviewState(String status){
    if(status=="0"){
      return const Text('待审核批阅',style: TextStyle(fontSize: 13),);
    }else if(status=="1"){
      return const Text('已审核批阅',style: TextStyle(fontSize: 13),);
    }else if(status=="2"){
      return const Text("已被打回",style: TextStyle(fontSize: 13));
    }else{
      return const Text("已重新提交",style: TextStyle(fontSize: 13));
    }
  }

  String _getInitials(String user) {
    var buffer = StringBuffer();
    var split = user.split(" ");
    for (var s in split) buffer.write(s[0]);
    return buffer.toString().substring(0, split.length);
  }

  Color _getAvatarColor(String user) {
    return AppColors
        .avatarColors[user.hashCode % AppColors.avatarColors.length];
  }

  void getSubmit() async {
    try {
      final resp = await HttpUtil.client.get(
        "/cschedule/uploads/allSubmit",
        data: dio.FormData.fromMap({
          'courseId': widget.schedule.courseId,
          'workId': widget.work.workId,
        },),);
      final data = HttpUtil.getDataFromResponse(resp.toString()); // 解析响应数据
      if (data is List) {
        // 如果数据是列表类型
        setState(() {
          _data.clear();
          for(var i=0;i<data.length;i++){
            log(data[i].toString());
            MemberDtoo memberDtoo = MemberDtoo();
            if(data[i]["memberDTO"]==null){
              _data.clear();
              return;
            }else{
              memberDtoo.memberDTO=MemberDto.fromJson(data[i]["memberDTO"]);
            }
            if(data[i]["upload"]==null){
              Upload upload = Upload();
              upload.gmtCreate=DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
              memberDtoo.upload=upload;
            }else{
              memberDtoo.upload=Upload.fromJson(data[i]["upload"]);
            }
            _data.add(memberDtoo);
          }
          _data.sort((a, b) {
            // 确保a和b的upload属性不为null
            if (a.upload == null || b.upload == null) {
              // 这里可以根据实际情况处理null的情况，比如抛出异常或者返回0
              throw StateError("Cannot sort _data with null Upload objects");
            }
            // 比较gmtCreate字段
            return a.upload!.gmtCreate!.compareTo(b.upload!.gmtCreate!);
          });
          _loading = false; // 加载完成，更新_loading状态为false
        });
      }
    } catch (e) {
      print(e); // 打印错误信息
      setState(() {
        _loading = false; // 加载完成，更新_loading状态为false
      });
    }
  }
}
