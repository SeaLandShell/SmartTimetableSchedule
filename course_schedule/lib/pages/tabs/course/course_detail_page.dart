// https://github.com/JakesMD/flutter_capped_progress_indicator
// https://github.com/pktintali/flutter_custom_cards
// https://github.com/fluttercandies/flutter_wechat_assets_picker/blob/main/README-ZH.md

import 'dart:convert';
import 'dart:io';
import 'package:capped_progress_indicator/capped_progress_indicator.dart';
import 'package:course_schedule/model/index.dart';
import 'package:course_schedule/net/apiClientSchedule.dart';
import 'package:course_schedule/pages/tabs/course/upload/detail/synopsis.dart';
import 'package:course_schedule/pages/tabs/course/upload/teacher_resource/photo_document_preview.dart';
import 'package:course_schedule/pages/tabs/course/upload/teacher_resource/photo_document_upload.dart';
import 'package:course_schedule/pages/tabs/course/upload/teacher_resource/resource_respository.dart';
import 'package:course_schedule/pages/tabs/course/upload/teacher_resource/web_upload.dart';
import 'package:course_schedule/utils/dialog_util.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:shine_flutter/shine_flutter.dart';
import 'package:tbib_downloader/tbib_downloader.dart';
import 'package:tbib_file_uploader/tbib_file_uploader.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '../../../components/card_view.dart';
import '../../../components/clipper/bottom_curve_clipper.dart';
import '../../../components/item_button.dart';
import '../../../data/values.dart';
import '../../../db/database_manager.dart';
import '../../../db/domain/user_db.dart';
import '../../../utils/http_util.dart';
import '../../../utils/shared_preferences_util.dart';
import '../../../utils/util.dart';



class CourseDetailPage extends StatefulWidget {
  final Schedule schedule;
  const CourseDetailPage({super.key,required this.schedule});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  /// 内容距状态栏的高度
  static const double topMargin = 32;
  static const double TodayCourseCardHeight = 40;
  double statusBarHeight = 0;
  double screenHeight = 0;
  double screenWidth = 0;
  double bottomNavBarHeight = 0;
  double progress = 0;
  int userId = 0;
  int resourceLearnCount = 0;
  String ext = "jpg";
  bool isTeacher = false;
  bool hasLearn = false;
  bool hide = false;
  File? selectedFile;
  QuillController _controller = QuillController.basic();

  @override
  void initState() {
    super.initState();
    isTeacherOrStu();
    if(widget.schedule.synopsis!=null && widget.schedule.synopsis!=""){
      _controller.document = Document.fromJson(jsonDecode(widget.schedule.synopsis!));
    }
  }
  void isTeacherOrStu() async {
    int userID = await SharedPreferencesUtil.getPreference('userID', 0);
    UserDb? user = await DataBaseManager.queryUserById(userID);
    setState(() {
      userId = userID;
    });
    if(user?.userType=="01"){
      setState(() {isTeacher = true;});
    }
  }
  @override
  Widget build(BuildContext context) {
    statusBarHeight = MediaQuery.of(context).padding.top; // 获取状态栏高度
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bottomNavBarHeight = MediaQuery.of(context).padding.bottom;
    return Container(
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
                padding:
                const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: _buildCourseDetailOpTool(),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: _buildDetail(),
              ),
            ],
          ),
        ],
      ),
    );
  }
  CardView _buildDetail(){
    return CardView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 主轴居中对齐
          children: [
            CustomCard(
              // height: 116,
              width: screenWidth-60,
              elevation: 6,
              childPadding: 10,
              color: Colors.lightBlueAccent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 0),
                    child: Text(
                      '''课程简介：''',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SingleChildScrollView(
                    child: Expanded(
                      child: QuillEditor.basic(
                        configurations: QuillEditorConfigurations(
                          minHeight: 70,
                          customStyles: DefaultStyles(color: Colors.white),
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          autoFocus: false,
                          showCursor: false,
                          controller: _controller,
                          readOnly: true,
                          sharedConfigurations: const QuillSharedConfigurations(
                            locale: Locale('zh','CN'),
                          ),
                        ),
                      ),
                    ),),
                  if(isTeacher)
                  Center(
                    widthFactor: screenWidth-70,
                    child: TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return SynopsisPage(schedule: widget.schedule);
                        })).then((value) => setState(() {
                          _controller.document = Document.fromJson(jsonDecode(value));
                        }));
                      },
                      child: const Text("编辑简介",style: TextStyle(color: Colors.blue),),
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.6)),
                        minimumSize: MaterialStateProperty.resolveWith<Size>((states) {
                          // 计算按钮的最小尺寸，设置为屏幕宽度减去指定的间距
                          return Size(screenWidth - 70, 0);
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  CardView _buildCourseDetailOpTool() {
    return CardView(
      // title: "${widget.schedule.courseName}",
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 主轴居中对齐
          children: [
            CustomCard(
              height: 116,
              width: screenWidth-60,
              elevation: 6,
              childPadding: 10,
              color: Colors.lightBlueAccent,
              // onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 0.0),
                    child: Text(
                      '学期：${widget.schedule.term}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 0.0),
                    child: Text(
                      '班级：${widget.schedule.clazzName}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 0.0),
                    child: Text(
                      '教师：${widget.schedule.teacherName}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 0.0),
                    child: Text(
                      '云课号：${widget.schedule.courseNum}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



}
