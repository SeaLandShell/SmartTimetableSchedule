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
import '../../../components/action_icon_button.dart';
import '../../../utils/dialog_util.dart';
import 'package:dio/dio.dart' as dio;

import '../../../utils/http_util.dart';
import '../../../utils/event_util.dart';
class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  /// 内容距状态栏的高度
  static const double topMargin = 32;
  static const double TodayCourseCardHeight = 40;
  double statusBarHeight = 0;
  double screenHeight = 0;
  double screenWidth = 0;
  double bottomNavBarHeight = 0;
  bool isTeacher = false;
  bool hide = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _startController = TextEditingController();

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
      backgroundColor: Values.bgWhite,
      appBar: AppBar(
        title: Text("新增日程"),
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
            controller: _startController,
            decoration: const InputDecoration(labelText: '日期',
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 20.0,right: 15.0), // 这里设置右边内边距的大小
                child: Icon(Icons.keyboard_double_arrow_right_rounded, color: Colors.blue,),
              ),),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '日程必选';
              }
              try {
                // 尝试解析输入的时间
                final parsedDate = DateFormat('yyyy-MM-dd').parseStrict(value);
                // 确保解析后的时间与原始输入值相同
                if (DateFormat('yyyy-MM-dd').format(parsedDate) != value) {
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
                firstDate: DateTime(1970),
                lastDate: DateTime(2070),
              );
              if (pickedDate != null) {
                setState(() {
                  _startController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                });
              }
            },
          ),
          SizedBox(height: 20,),
          TextFormField(
            autovalidateMode: AutovalidateMode.disabled, // 禁用自动验证模式
            controller: _nameController,
            maxLines: 2,
            decoration: const InputDecoration(labelText: '日程内容（三行以内）',
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 20.0,right: 15.0), // 这里设置右边内边距的大小
                child: Icon(Icons.edit_calendar_rounded, color: Colors.blue,),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
            ),
            validator: RequiredValidator(errorText: '日程内容'),
          ),
          SizedBox(height: 20,),
          SizedBox(
            width: screenWidth-32,
            height: 48,
            child: ElevatedButton(
              onPressed: save,
              style: ButtonStyle(
                // backgroundColor: MaterialStateProperty.all<Color>(_countdown == 0 ? Colors.lightBlueAccent : Colors.grey), // 根据倒计时状态设置按钮颜色
                backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
              ),
              child: const Text("保存",
                style: TextStyle(color: Colors.white,fontSize: 20),
              ),
            ),
          ),
          SizedBox(height: 20,)
        ],
      ),
    );
  }

  Future<void> save() async {
    String date = _startController.text.trim();
    String content = _nameController.text.trim();
    Map<String, List> _kEventSource = {
      date : [
        Event(content).toJson(),
      ],
    };
    String jsonString = jsonEncode(_kEventSource);
    print(jsonString);
    if(_formKey.currentState!.validate()){
      int userId=await SharedPreferencesUtil.getPreference("userID", 0);
      DialogUtil.showConfirmDialog(context, "确认保存该日程？", () async {
        final resp = await HttpUtil.client.post("/acuser/program",
            data: dio.FormData.fromMap({
              'userId': userId,
              'title': jsonString,
            }));
        final data = HttpUtil.getDataFromResponse(resp.toString());
        if(data>0){
          Util.showToastCourse("保存成功", context);
          Navigator.pop(context);
        }
      });
    }
  }
}