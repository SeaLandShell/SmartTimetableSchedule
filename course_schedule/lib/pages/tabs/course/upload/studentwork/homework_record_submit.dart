// https://pub.dev/packages/group_list_view

import 'package:course_schedule/model/Upload.dart';
import 'package:course_schedule/model/index.dart';
import 'package:course_schedule/pages/tabs/course/upload/studentwork/homework_update_submit.dart';
import 'package:course_schedule/utils/util.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

import '../../../../../components/clipper/bottom_curve_clipper.dart';
import '../../../../../data/values.dart';
import '../../../../../db/database_manager.dart';
import '../../../../../db/domain/user_db.dart';
import '../../../../../model/Work.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/http_util.dart';
import '../../../../../utils/shared_preferences_util.dart';
import 'homework_record_detail_submit.dart';



class HomeworkRecordSubmitPage extends StatefulWidget {
  final Schedule schedule;
  final Work work;
  const HomeworkRecordSubmitPage({super.key,required this.schedule,required this.work});

  @override
  State<HomeworkRecordSubmitPage> createState() => _HomeworkRecordSubmitPageState();
}

class _HomeworkRecordSubmitPageState extends State<HomeworkRecordSubmitPage> {
  /// 内容距状态栏的高度
  static const double topMargin = 32;
  static const double TodayCourseCardHeight = 40;
  double statusBarHeight = 0;
  double screenHeight = 0;
  double progress = 0;
  double bottomNavBarHeight = 0;
  String ext = "jpg";

  bool _loading = true; // 是否正在加载数据的标志
  bool isTeacher = false;
  final List<Upload> _data = [];

  @override
  void initState() {
    super.initState();
    isTeacherOrStu();
    getRecordDetail();
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
                if(_data.isEmpty){
                  Util.showToastCourse("暂无提交/批改记录！", context);
                  return;
                }else if(_data[0].review=="1"){
                  Util.showToastCourse("已审核，不可再次提交！", context);
                  return;
                }
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return HomeworkUpdateSubmitPage(schedule: widget.schedule, upload: _data[0]);
                }));
              },
              child: SizedBox(
                width: 76,
                child: Text("修改提交"),
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
                Container(
                  // color: const Color.fromRGBO(0, 131, 213, 1),
                  // color: const Color(0x90C8F9),
                  // color: const Color.fromRGBO(144, 200, 249, 1),
                  color: Colors.blue,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Marquee(
                      text: '提示：提交/批改记录按时间顺序排序，教师审核批改前或打回后，可再次提交！', // 要滚动的文本
                      style: TextStyle(color: Colors.white), // 文本样式，白色
                      velocity: 50.0, // 滚动速度
                      pauseAfterRound: Duration(seconds: 0), // 一轮滚动后的暂停时间
                      blankSpace: 20.0, // 文本之间的间距
                      crossAxisAlignment: CrossAxisAlignment.center, // 文本对齐方式，居中
                      startPadding: 10.0, // 开始滚动前的内边距
                      accelerationDuration: Duration(seconds: 1), // 加速度持续时间
                      accelerationCurve: Curves.linear, // 加速度曲线
                      decelerationDuration: Duration(milliseconds: 500), // 减速度持续时间
                      decelerationCurve: Curves.easeOut, // 减速度曲线
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(28, 28, 0, 8),
                  child: Text("${widget.work.workName}提交批改记录",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 110, 16, 0),
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
    if(_data.isEmpty){
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 16), // 设置右边距
          child: Material(
            color: Colors.transparent, // 背景颜色透明
            child: Container(
              constraints: BoxConstraints(minHeight: 64, minWidth: 64), // 设置容器最小宽高
              padding: const EdgeInsets.all(3), // 设置内边距
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // 主轴居中对齐
                children: [
                  IconTheme.merge(
                    data: IconThemeData(size: 24), // 图标尺寸
                    child: Icon(Icons.change_circle_rounded,
                      size: 100,
                      color: Colors.blueGrey.shade500,), // 图标
                  ),
                  const Padding(
                    padding: const EdgeInsets.only(top: 8), // 设置顶部边距
                    child: Text(
                      """暂无提交/批改记录，空空如也~""", // 标题文本
                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold), // 文本样式
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return HomeworkRecordDetailSubmitPage(schedule: widget.schedule, upload: _data[index]);
              }));
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
                  _getInitials(_data[index].workName!),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                backgroundColor: _getAvatarColor(_data[index].workId!),
              ),
              title: Text(
                _data[index].workName!,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              subtitle: Text(
                "${_data[index].gmtCreate!}",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
              ),
              trailing:Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  reviewState(_data[index].review!),
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
      return const Text('历史条目',style: TextStyle(fontSize: 13),);
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

  void getRecordDetail() async {
    int userId = await SharedPreferencesUtil.getPreference("userID", 0);
    // print(userId);
    try {
      final resp = await HttpUtil.client.get(
          "/cschedule/uploads/record",
          data: dio.FormData.fromMap({
            'courseId': widget.schedule.courseId,
            'workId': widget.work.workId,
            'userId': userId,
          },),);
      final data = HttpUtil.getDataFromResponse(resp.toString()); // 解析响应数据
      if (data is List) {
        // 如果数据是列表类型
        setState(() {
          _data.clear(); // 清空数据列表
          for(var i=0;i<data.length;i++){
            // data[i]["uploadId"]=data[i]["uploadId"].toString().substring(0,20);
            _data.add(Upload.fromJson(data[i]));
            print(_data[i].toJson());
          }
          _data.sort((a, b) => b.uploadId!.compareTo(a.uploadId!));
          _loading = false; // 加载完成，更新_loading状态为false
        });
      }
    }catch (e) {
      print(e); // 打印错误信息
      setState(() {
        _loading = false; // 加载完成，更新_loading状态为false
      });
    }
  }
}
