// https://github.com/JakesMD/flutter_capped_progress_indicator
// https://github.com/pktintali/flutter_custom_cards
// https://github.com/fluttercandies/flutter_wechat_assets_picker/blob/main/README-ZH.md

import 'dart:convert';
import 'dart:developer';

import 'package:capped_progress_indicator/capped_progress_indicator.dart';
import 'package:course_schedule/model/Work.dart';
import 'package:course_schedule/model/index.dart';
import 'package:course_schedule/net/apiClientSchedule.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';

import '../../../../../../components/clipper/bottom_curve_clipper.dart';
import '../../../../../../data/values.dart';
import '../../../../../db/database_manager.dart';
import '../../../../../db/domain/user_db.dart';
import '../../../../../utils/shared_preferences_util.dart';
import '../../../../../utils/util.dart';

class PublishHomeworkPage extends StatefulWidget {
  final Schedule schedule;
  const PublishHomeworkPage({super.key,required this.schedule});

  @override
  State<PublishHomeworkPage> createState() => _PublishHomeworkPageState();
}

class _PublishHomeworkPageState extends State<PublishHomeworkPage> {
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
  TextEditingController _startController = TextEditingController();
  TextEditingController _endController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
                if(_formKey.currentState!.validate()){
                  String json = jsonEncode(_controller.document.toDelta().toJson());
                  if(json=='''[{"insert":"\n"}]'''){
                    Util.showToastCourse("请输入作业要求！", context);
                  }
                  Work work = Work();
                  work.courseId=widget.schedule.courseId;
                  work.workName=_nameController.text.trim();
                  work.isEnabled=true;
                  work.content=json??"";
                  work.startTime=_startController.text.trim();
                  work.endTime=_endController.text.trim();
                  work.linkResource="";
                  final now = DateTime.now();
                  final startTime = DateFormat('yyyy-MM-dd HH:mm:ss').parseStrict(_startController.text.trim());
                  final endTime = DateFormat('yyyy-MM-dd HH:mm:ss').parseStrict(_endController.text.trim());
                  if (now.millisecondsSinceEpoch > endTime.millisecondsSinceEpoch) {
                    work.state=2;//表示作业已结束
                  }else if(now.millisecondsSinceEpoch < startTime.millisecondsSinceEpoch){
                    work.state=0;//标识作业未开始
                  }else{
                    work.state=1;//标识作业正在进行中
                  }
                  Work? resWork=await ApiClientSchdedule.addWork(work);
                  if(resWork!=null){
                    FocusNode().unfocus();
                    Util.showToastCourseNew("发布成功!", context);
                    Navigator.of(context).pop();
                  }
                  // log(work.content!);
                }
              },
              child: SizedBox( // 使用SizedBox设置Tab的宽度
                width: 85, // 屏幕宽度除以Tab数量
                child: Row(children: [
                  // Icon(Icons.done_rounded,color: Colors.greenAccent,),
                  Text("发布作业",style: TextStyle(color: Colors.black,fontSize: 16),),
                ]),
              ),
            )
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
    String term=widget.schedule.term!;
    int termStart=int.parse(term.substring(0,4))-5;
    int termEnd=int.parse(term.substring(5,9))+5;
    return Form(
      key: _formKey, // 绑定表单Key
      child: Column(
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.disabled, // 禁用自动验证模式
            controller: _nameController,
            decoration: const InputDecoration(labelText: '作业名(本课程该作业唯一标识)',
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 20.0,right: 15.0), // 这里设置右边内边距的大小
                child: Icon(Icons.drive_file_rename_outline_rounded, color: Colors.blue,),
              ),),
            validator: RequiredValidator(errorText: '作业名必填'),
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.disabled, // 禁用自动验证模式
            controller: _startController,
            decoration: const InputDecoration(labelText: '作业开始时间',
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 20.0,right: 15.0), // 这里设置右边内边距的大小
                child: Icon(Icons.keyboard_double_arrow_right_rounded, color: Colors.blue,),
              ),),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '作业开始时间必填';
              }
              try {
                // 尝试解析输入的时间
                final parsedDate = DateFormat('yyyy-MM-dd HH:mm:ss').parseStrict(value);
                // 确保解析后的时间与原始输入值相同
                if (DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedDate) != value) {
                  return '请输入有效的日期时间';
                }
                // 还可以添加其他的时间逻辑检查，比如检查是否在当前时间之后等等
              } catch (e) {
                return '请输入有效的日期时间';
              }
              return null; // 通过验证
            },
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(termStart),
                lastDate: DateTime(termEnd),
              );
              if (pickedDate != null) {
                setState(() {
                  _startController.text = DateFormat('yyyy-MM-dd HH:mm:ss').format(pickedDate);
                });
              }
            },
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.disabled, // 禁用自动验证模式
            controller: _endController,
            decoration: const InputDecoration(labelText: '作业结束时间',
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 20.0,right: 15.0), // 这里设置右边内边距的大小
                child: Icon(Icons.keyboard_double_arrow_left_rounded, color: Colors.blue,),
              ),),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '作业结束时间必填且不得晚于作业开始时候';
              }
              try {
                // 尝试解析输入的时间
                final parsedDate = DateFormat('yyyy-MM-dd HH:mm:ss').parseStrict(value);
                // 确保解析后的时间与原始输入值相同
                if (DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedDate) != value) {
                  return '请输入有效的日期时间';
                }
                // 还可以添加其他的时间逻辑检查，比如检查是否在当前时间之后等等
                if(_startController.text.trim()==""){
                  return "请选择作业开始时间";
                }
                // 检查时间是否合理
                final startTime = DateFormat('yyyy-MM-dd HH:mm:ss').parseStrict(_startController.text.trim());
                final endTime = parsedDate;
                if (endTime.isBefore(startTime)) {
                  return '结束时间不能早于开始时间';
                }
              } catch (e) {
                return '请输入有效的日期时间';
              }
              return null; // 通过验证
            },
            onTap: () async {
              // print(termStart);
              // print(termEnd);
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(termStart),
                lastDate: DateTime(termEnd),
              );
              if (pickedDate != null) {
                setState(() {
                  _endController.text = DateFormat('yyyy-MM-dd HH:mm:ss').format(pickedDate);
                });
              }
            },
          ),
        ],
      ),
    );
  }
}