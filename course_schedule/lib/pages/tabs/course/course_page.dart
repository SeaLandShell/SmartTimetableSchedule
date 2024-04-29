// https://github.com/sooxt98/google_nav_bar
// https://github.com/jamesblasco/modal_bottom_sheet

import 'package:course_schedule/model/index.dart';
import 'package:course_schedule/pages/tabs/course/course_activity_page.dart';
import 'package:course_schedule/pages/tabs/course/course_detail_page.dart';
import 'package:course_schedule/pages/tabs/course/course_interact_page.dart';
import 'package:course_schedule/pages/tabs/course/course_member_page.dart';
import 'package:course_schedule/pages/tabs/course/course_recourse_page.dart';
import 'package:course_schedule/pages/tabs/course/upload/teacherwork/publish_homework.dart';
import 'package:flutter/material.dart';

import '../../../data/values.dart';
import '../../../db/database_manager.dart';
import '../../../db/domain/user_db.dart';
import '../../../utils/shared_preferences_util.dart';

class CoursePage extends StatefulWidget {
  final int index;
  final Color backgroundColor;
  final String className;
  final Schedule schedule;
  const CoursePage({super.key,this.index=0,this.backgroundColor = Values.bgWhite,this.className="云课堂",required this.schedule});
  @override
  State<CoursePage> createState() => _CoursePageState();
}
class _CoursePageState extends State<CoursePage> {
  bool isTeacher = false;
  late int _currentIndex;
  late List<Widget> _pages;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isTeacherOrStu();
    _currentIndex=widget.index;
    _pages = [
      CourseRecoursePage(schedule: widget.schedule),
      CourseMemberPage(schedule: widget.schedule),
      CourseActivityPage(schedule: widget.schedule),
      CourseInteractPage(schedule: widget.schedule),
      CourseDetailPage(schedule: widget.schedule),
    ];
    // print("我是当前课程课堂页：${widget.schedule.toJson()}");
  }
  void isTeacherOrStu() async {
    int userID = await SharedPreferencesUtil.getPreference('userID', 0);
    UserDb? user = await DataBaseManager.queryUserById(userID);
    if(user?.userType=="01"){
      setState(() {isTeacher = true;});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.className),
        actions: [
          if(_currentIndex==2 && isTeacher)
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PublishHomeworkPage(schedule: widget.schedule);
                }),);
              },
              child: SizedBox( // 使用SizedBox设置Tab的宽度
                width: 90, // 屏幕宽度除以Tab数量
                child: Center(child: Text("编辑作业",style: TextStyle(color: Colors.black,fontSize: 16),)),
              ),
            ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          fixedColor: Colors.blue, //选中的颜色
          // iconSize:20,           //底部菜单大小
          currentIndex: _currentIndex, //第几个菜单选中
          type: BottomNavigationBarType.fixed, //如果底部有4个或者4个以上的菜单的时候就需要配置这个参数
          onTap: (index) {
            //点击菜单触发的方法
            //注意
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.folder_copy_rounded), label: "资源"),
            BottomNavigationBarItem(icon: Icon(Icons.person_2_rounded), label: "成员"),
            BottomNavigationBarItem(icon: Icon(Icons.poll_rounded), label: "活动"),
            BottomNavigationBarItem(icon: Icon(Icons.interpreter_mode_rounded), label: "互动"),
            BottomNavigationBarItem(icon: Icon(Icons.view_comfy_alt_rounded), label: "详情"),
          ]),
    );
  }
}
