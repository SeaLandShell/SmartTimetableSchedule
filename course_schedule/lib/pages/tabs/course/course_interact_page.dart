import 'dart:convert';
import 'dart:developer';

import 'package:course_schedule/model/index.dart';
import 'package:course_schedule/model/notice.dart';
import 'package:course_schedule/net/apiClientSchedule.dart';
import 'package:course_schedule/pages/tabs/course/upload/notification/publish_notice.dart';
import 'package:course_schedule/utils/dialog_util.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:shine_flutter/shine_flutter.dart';

import '../../../../../components/clipper/bottom_curve_clipper.dart';
import '../../../../../data/values.dart';
import '../../../../../db/database_manager.dart';
import '../../../../../db/domain/user_db.dart';
import '../../../../../utils/shared_preferences_util.dart';
import '../../../../../utils/util.dart';
import '../../../model/course.dart';
import '../../../provider/store.dart';
import '../../../ui/coursedetail/course_detail.dart';
import '../../../utils/file_util.dart';
import '../../../utils/http_util.dart';
import '../course/course_import_page.dart';
import '../course/course_page.dart';

class CourseInteractPage extends StatefulWidget {
  final Schedule schedule;
  const CourseInteractPage({super.key,required this.schedule});

  @override
  State<CourseInteractPage> createState() => _CourseInteractPageState();
}

class _CourseInteractPageState extends State<CourseInteractPage> {
  /// 内容距状态栏的高度
  static const double topMargin = 32;
  static const double TodayCourseCardHeight = 40;
  double statusBarHeight = 0;
  double screenHeight = 0;
  double progress = 0;
  double bottomNavBarHeight = 0;
  String term="";
  bool _loading = true; // 是否正在加载数据的标志
  bool isTeacher = false;
  bool hasLearn = false;
  bool hide = false;
  QuillController _controller = QuillController.basic();
  final List<Notice> _data = [];

  @override
  void initState() {
    super.initState();
    isTeacherOrStu();
    getCourseDetail();
  }
  void isTeacherOrStu() async {
    UserDb? user = await DataBaseManager.queryUserById(await SharedPreferencesUtil.getPreference('userID', 0));
    if(user?.userType=="01"){
      setState(() {isTeacher = true;});
    }
  }
  @override
  Widget build(BuildContext context) {
    statusBarHeight = MediaQuery.of(context).padding.top; // 获取状态栏高度
    screenHeight = MediaQuery.of(context).size.height;
    bottomNavBarHeight = MediaQuery.of(context).padding.bottom;
    return Scaffold(
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
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 0, 0, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '通知栏',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 28.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '共${_data.length}个通知',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: SingleChildScrollView(child: _buildExpansionTileCards(),),
                ),
              ],
            ),
          ],
        ),
      ),);
  }
  Widget _buildExpansionTileCards() {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    );
    if (_loading) {
      return Center(child: CircularProgressIndicator()); // 显示加载指示器
    }
    if (_data.isEmpty || _data.length==0) {
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
                      """暂未发布通知，空空如也~""", // 标题文本
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
    double height = screenHeight - statusBarHeight - topMargin - TodayCourseCardHeight - bottomNavBarHeight-130;
    return Container(
      height: height, // 设置一个固定的高度
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          if(_data[index].content!=""){
            _controller.document = Document.fromJson(jsonDecode(_data[index].content!));
          }
          final GlobalKey<ExpansionTileCardState> cardB = GlobalKey<ExpansionTileCardState>(); // 在这里初始化GlobalKey
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: ExpansionTileCard(
              key: cardB, // 使用UniqueKey确保每个ExpansionTileCard都是唯一的
              baseColor: Colors.white,
              leading: CustomCard(
                height: 50,
                width: 50,
                elevation: 5,
                color: Colors.blue.shade400,
                borderColor: Colors.cyanAccent,
                borderWidth: 2,
                child: CardWidget(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  backgroundColor: Colors.white,
                  children: [
                    Align(
                      heightFactor: 1.8,
                      alignment: Alignment.center,
                      child: GradientText(
                        _getInitials(_data[index].content!),
                        gradient: SweepGradient(
                          colors: [Colors.blue[900]!, Colors.blueAccent],
                        ),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              title: Text("发布者：${_data[index].author!}"),
              subtitle: Text("时间：${_data[index].releaseTime!}"),
              children: <Widget>[
                const Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24, 8, 24, 0),
                    child: Text("内容："),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 0.0,
                    ),
                    child: SingleChildScrollView(
                      child: Expanded(
                        child: QuillEditor.basic(
                          configurations: QuillEditorConfigurations(
                            // minHeight: screenHeight-300,
                            padding: EdgeInsets.fromLTRB(36, 0, 16, 8),
                            placeholder: "开始编辑通知内容吧！",
                            autoFocus: false,
                            showCursor: false,
                            controller: _controller,
                            readOnly: false,
                            sharedConfigurations: const QuillSharedConfigurations(
                              locale: Locale('zh','CN'),
                            ),
                          ),
                        ),
                      ),),
                  ),
                ),
                if(isTeacher)
                ButtonBar(
                  alignment: MainAxisAlignment.spaceAround,
                  buttonHeight: 52.0,
                  buttonMinWidth: 90.0,
                  children: <Widget>[
                    TextButton(
                      style: flatButtonStyle,
                      onPressed: () {
                        DialogUtil.showConfirmDialog(context, "确认删除这条通知？", () async {
                          final resp = await HttpUtil.client.delete("/cschedule/notices/${_data[index].noticeId}",);
                          print(resp.toString());
                          final data = HttpUtil.getDataFromResponse(resp.toString()); // 解析响应数据
                          if(data>0){
                            Util.showToastCourse("删除成功！", context);
                            _loading=true;
                            getCourseDetail();
                          }
                        });
                      },
                      child: const Column(
                        children: <Widget>[
                          Icon(Icons.delete_forever_rounded,color: Colors.red,),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('删除',style: TextStyle(color: Colors.red),),
                        ],
                      ),
                    ),
                    TextButton(
                      style: flatButtonStyle,
                      onPressed: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return PublishNoticePage(schedule: widget.schedule,notice: _data[index]);
                        })).then((value) => setState(() {
                          if(value==true){
                            _loading=true;
                            getCourseDetail();
                          }
                        }));
                      },
                      child: const Column(
                        children: <Widget>[
                          Icon(Icons.grass_outlined,color: Colors.blue,),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('编辑',style: TextStyle(color: Colors.blueAccent),),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        itemCount: _data.length,
      ),
    );
  }

  String _getInitials(String user) {
    // var buffer = StringBuffer();
    // var split = user.split(" ");
    // for (var s in split) buffer.write(s[0]);
    // return buffer.toString().substring(0, split.length);
    return user.substring(12,13);
  }

  void getCourseDetail() async {
    try {
      final resp = await HttpUtil.client.get(
          "/cschedule/classes/${widget.schedule.courseId}",
          data: {
            'courseId': widget.schedule.courseId,
          });
      final data = HttpUtil.getDataFromResponse(resp.toString()); // 解析响应数据
      // log(data.toString());
      if (data['notices'] is List) {
        // 如果数据是列表类型
        setState(() {
          _data.clear(); // 清空数据列表
          for(var i=0;i<data['notices'].length;i++){
            // print('我是Resource$i:${Resource.fromJson(data['resources'][i]).toJson()}');
            _data.add(Notice.fromJson(data['notices'][i]));
          }
          _data.sort((a, b) => a.releaseTime!.compareTo(b.releaseTime!));
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
