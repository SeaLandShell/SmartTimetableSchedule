import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../components/card_view.dart';
import '../../../components/clipper/bottom_curve_clipper.dart';
import '../../../data/values.dart';

class ApproachPage extends StatefulWidget {

  const ApproachPage({super.key});

  @override
  State<ApproachPage> createState() => _ApproachPageState();
}

class _ApproachPageState extends State<ApproachPage> {
  /// 内容距状态栏的高度
  static const double topMargin = 32;
  static const double TodayCourseCardHeight = 40;
  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top; // 获取状态栏高度
    return Scaffold(
      backgroundColor: Values.bgWhite,
      appBar: AppBar(
        title: Text("使用技巧"),
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
            SingleChildScrollView(child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
                  child: _buildBody(), // 今日课程
                ),
              ],
            ),),
          ],
        ),
      ),
    );
  }
  CardView _buildBody(){
    return CardView(
      title: "智课表",
      child: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Center(
            child: Text('''
    智课表可以通过教务系统导入课表，通过课表教师开通课程，学生进入课程，也可以在日程栏目中自定义事件记录（限于100字 三行以内），这些事件记录以可视化形式展现在日历栏目中，直观展示。
    教师可以上传资源、查改删资源，学生可查看资源，配带预览功能。
    成员模块有签到码签到功能，教师可设置签到有效期，学生在该期限内签到，配带签到次数统计功能。
    活动管理模块（即作业）教师可以上传、修改、删除作业要求，批改作业，学生可以提交作业、查看每次的作业提交记录和教师的批改情况。作业编辑栏目配带丰富的文本编辑器功能，其中的附件功能可暂时由资源模块代替，后期系统更新，可弥补该功能。
    通知模块，教师可发布班级通知，学生可查看班级通知，暂不支持班级成员实时聊天、会议聊天、成员间沟通功能，后期系统更新弥补该功能。
    课程详情模块，系统自行导入课程详情信息，教师可编辑查看课程详情，学生可查看课程详情。
  ''',style: TextStyle(fontSize: 16,fontFamily: "宋体",
                color: Colors.black),),
          ),
        ),
    );
  }
}
