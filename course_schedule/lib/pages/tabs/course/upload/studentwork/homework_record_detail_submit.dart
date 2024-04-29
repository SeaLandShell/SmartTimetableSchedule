// https://github.com/JakesMD/flutter_capped_progress_indicator
// https://github.com/pktintali/flutter_custom_cards
// https://github.com/fluttercandies/flutter_wechat_assets_picker/blob/main/README-ZH.md
// 学生修改作业页面

import 'dart:convert';

import 'package:capped_progress_indicator/capped_progress_indicator.dart';
import 'package:course_schedule/model/Upload.dart';
import 'package:course_schedule/model/index.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../../../../../components/clipper/bottom_curve_clipper.dart';
import '../../../../../../data/values.dart';
import '../../../../../db/database_manager.dart';
import '../../../../../db/domain/user_db.dart';
import '../../../../../utils/shared_preferences_util.dart';

class HomeworkRecordDetailSubmitPage extends StatefulWidget {
  final Schedule schedule;
  final Upload upload;
  const HomeworkRecordDetailSubmitPage({super.key,required this.schedule,required this.upload});

  @override
  State<HomeworkRecordDetailSubmitPage> createState() => _HomeworkRecordDetailSubmitPageState();
}

class _HomeworkRecordDetailSubmitPageState extends State<HomeworkRecordDetailSubmitPage> {
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
  late final TextEditingController _nameController;
  late final TextEditingController _appraiseController;
  late final TextEditingController _criticismController;
  late final TextEditingController _scoreController;
  late final TextEditingController _reviewController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.upload.workName);
    _appraiseController = TextEditingController(text: widget.upload.appraise);
    _criticismController = TextEditingController(text: widget.upload.criticism);
    _scoreController = TextEditingController(text: widget.upload.score.toString());
    String state=widget.upload.review!;
    if(state=="0"){
      _reviewController = TextEditingController(text: "等待审核");
    }else if(state=="1"){
      _reviewController = TextEditingController(text: "已审核");
    }else{
      _reviewController = TextEditingController(text: "打回重交");
    }
    _controller.document = Document.fromJson(jsonDecode(widget.upload.content!));
    isTeacherOrStu();
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
        actions: [
          GestureDetector(
            onTap: () async {

            },
            child: const SizedBox( // 使用SizedBox设置Tab的宽度
              width: 85, // 屏幕宽度除以Tab数量
              child: Row(children: [
                // Icon(Icons.done_rounded,color: Colors.greenAccent,),
                Text("",style: TextStyle(color: Colors.black,fontSize: 16),),
              ]),
            ),
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
                    ExpansionTileCard(
                      key: cardB,
                      baseColor: Colors.white,
                      title: Text("富文本编辑器"),
                      subtitle: Text("点击展开编辑项"),
                      leading: Icon(Icons.edit_note_rounded,color: Colors.blue,),
                      children: [
                        QuillToolbar.simple(
                          configurations: QuillSimpleToolbarConfigurations(
                            controller: _controller,
                            sharedConfigurations: const QuillSharedConfigurations(
                              locale: Locale('zh','CN'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    LinearCappedProgressIndicator(value: 1, minHeight: 1,backgroundColor: Colors.blueGrey.shade100 ,color: Colors.lightBlue ,),
                    SingleChildScrollView(
                      child: Expanded(
                        child: QuillEditor.basic(
                          configurations: QuillEditorConfigurations(
                            minHeight: screenHeight-100,
                            padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                            placeholder: "开始编辑作业吧！",
                            autoFocus: true,
                            showCursor: true,
                            controller: _controller,
                            readOnly: true,
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
    String term=widget.schedule.term!;
    return Form(
      key: _formKey, // 绑定表单Key
      child: Column(
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.disabled, // 禁用自动验证模式
            controller: _nameController,
            enabled: false,
            decoration: const InputDecoration(labelText: '作业名(本课程该作业唯一标识)',
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 20.0,right: 15.0), // 这里设置右边内边距的大小
                child: Icon(Icons.drive_file_rename_outline_rounded, color: Colors.blue,),
              ),),
            validator: RequiredValidator(errorText: '作业名必填'),
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.disabled, // 禁用自动验证模式
            controller: _appraiseController,
            enabled: false,
            decoration: const InputDecoration(labelText: '评价',
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 20.0,right: 15.0), // 这里设置右边内边距的大小
                child: Icon(Icons.control_point_rounded, color: Colors.blue,),
              ),),
            validator: RequiredValidator(errorText: '必填'),
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.disabled, // 禁用自动验证模式
            controller: _criticismController,
            enabled: false,
            decoration: const InputDecoration(labelText: '批语',
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 20.0,right: 15.0), // 这里设置右边内边距的大小
                child: Icon(Icons.comment_rounded, color: Colors.blue,),
              ),),
            validator: RequiredValidator(errorText: '必填'),
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.disabled, // 禁用自动验证模式
            controller: _scoreController,
            enabled: false,
            decoration: const InputDecoration(labelText: '评分',
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 20.0,right: 15.0), // 这里设置右边内边距的大小
                child: Icon(Icons.score_rounded, color: Colors.blue,),
              ),),
            validator: RequiredValidator(errorText: '必填'),
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.disabled, // 禁用自动验证模式
            controller: _reviewController,
            enabled: false,
            decoration: const InputDecoration(labelText: '状态',
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 20.0,right: 15.0), // 这里设置右边内边距的大小
                child: Icon(Icons.checklist_rounded, color: Colors.blue,),
              ),),
            validator: RequiredValidator(errorText: '必填'),
          ),
        ],
      ),
    );
  }
}