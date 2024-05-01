// https://github.com/JakesMD/flutter_capped_progress_indicator
// https://github.com/pktintali/flutter_custom_cards
// https://github.com/fluttercandies/flutter_wechat_assets_picker/blob/main/README-ZH.md

import 'dart:convert';
import 'dart:developer';

import 'package:capped_progress_indicator/capped_progress_indicator.dart';
import 'package:course_schedule/model/Work.dart';
import 'package:course_schedule/model/index.dart';
import 'package:course_schedule/net/apiClientSchedule.dart';
import 'package:course_schedule/utils/dialog_util.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart' as dio;

import '../../../../../../components/clipper/bottom_curve_clipper.dart';
import '../../../../../../data/values.dart';
import '../../../../../components/action_icon_button.dart';
import '../../../../../db/database_manager.dart';
import '../../../../../db/domain/user_db.dart';
import '../../../../../utils/http_util.dart';
import '../../../../../utils/shared_preferences_util.dart';
import '../../../../../utils/util.dart';

class SynopsisPage extends StatefulWidget {
  final Schedule schedule;
  const SynopsisPage({super.key,required this.schedule});

  @override
  State<SynopsisPage> createState() => _SynopsisPageState();
}

class _SynopsisPageState extends State<SynopsisPage> {
  /// 内容距状态栏的高度
  static const double topMargin = 32;
  static const double TodayCourseCardHeight = 40;
  double statusBarHeight = 0;
  double screenHeight = 0;
  double screenWidth = 0;
  double bottomNavBarHeight = 0;
  bool isTeacher = false;
  bool hide = false;
  QuillController _controller = QuillController.basic();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isTeacherOrStu();
    if(widget.schedule.synopsis!=null && widget.schedule.synopsis!=""){
      _controller.document = Document.fromJson(jsonDecode(widget.schedule.synopsis!));
    }
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
    screenWidth = MediaQuery.of(context).size.width;
    bottomNavBarHeight = MediaQuery.of(context).padding.bottom;
    final GlobalKey<ExpansionTileCardState> cardB = GlobalKey<ExpansionTileCardState>(); // 在这里初始化GlobalKey
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.schedule.courseName!),
        actions: <Widget>[
          ActionIconButton(
            icon: Icon(
              Icons.save_rounded,
              color: Colors.green.shade800,
              size: 26,
            ),
            tooltip: "保存",
            onPressed: () async {
              DialogUtil.showConfirmDialog(context, "确认保存课程详情？", () async {
                String json = jsonEncode(_controller.document.toDelta().toJson());
                final resp = await HttpUtil.client.post("/cschedule/schedule/update",
                    data: dio.FormData.fromMap({
                      'courseNum': widget.schedule.courseNum,
                      'synopsis': json,
                    }));
                final data = HttpUtil.getDataFromResponse(resp.toString());
                if(data>0){
                  Util.showToastCourse("编辑成功", context);
                  Navigator.pop(context,json);
                }
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
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
              Container(
                margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)), // 设置容器的圆角属性
                  color: Colors.white, // 设置容器的背景颜色为白色
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // 主轴居中对齐
                  children: [
                    _buildForm(),
                    LinearCappedProgressIndicator(value: 1, minHeight: 1,backgroundColor: Colors.blueGrey.shade100 ,color: Colors.blue ,),
                    QuillToolbar.simple(
                      configurations: QuillSimpleToolbarConfigurations(
                        controller: _controller,
                        sharedConfigurations: const QuillSharedConfigurations(
                          locale: Locale('zh','CN'),
                        ),
                      ),
                    ),
                    LinearCappedProgressIndicator(value: 1, minHeight: 1,backgroundColor: Colors.blueGrey.shade100 ,color: Colors.lightBlue ,),
                    SingleChildScrollView(
                      child: Expanded(
                        child: QuillEditor.basic(
                          configurations: QuillEditorConfigurations(
                            minHeight: screenHeight-300,
                            padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                            placeholder: "开始编辑课程简介吧！",
                            autoFocus: true,
                            showCursor: true,
                            controller: _controller,
                            readOnly: false,
                            sharedConfigurations: const QuillSharedConfigurations(
                              locale: Locale('zh','CN'),
                            ),
                          ),
                        ),
                      ),),
                  ],
                ), // 设置容器的子组件
              ),
            ],
          ),
        ),),
    );
  }
  Widget _buildForm(){
    return Form(
      key: _formKey, // 绑定表单Key
      child: Column(
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.disabled, // 禁用自动验证模式
            controller: _nameController,
            enabled: false,
            decoration: const InputDecoration(labelText: '     课程简介',),
            validator: RequiredValidator(errorText: '作业名必填'),
          ),
        ],
      ),
    );
  }
}