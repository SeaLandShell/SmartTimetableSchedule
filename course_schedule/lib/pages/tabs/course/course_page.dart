
import 'package:course_schedule/pages/tabs/course/course_activity_page.dart';
import 'package:course_schedule/pages/tabs/course/course_detail_page.dart';
import 'package:course_schedule/pages/tabs/course/course_interact_page.dart';
import 'package:course_schedule/pages/tabs/course/course_member_page.dart';
import 'package:course_schedule/pages/tabs/course/course_recourse_page.dart';
import 'package:flutter/material.dart';

import '../../../data/values.dart';

class CoursePage extends StatefulWidget {
  final int index;
  final Color backgroundColor;
  final String className;
  const CoursePage({super.key,this.index=0,this.backgroundColor = Values.bgWhite,this.className="云课堂"});
  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  late int _currentIndex;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentIndex=widget.index;
  }
  final List<Widget> _pages = const [
    CourseRecoursePage(),
    CourseMemberPage(),
    CourseActivityPage(),
    CourseInteractPage(),
    CourseDetailPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.className)),
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
