import 'package:course_schedule/db/database_manager.dart';
import 'package:course_schedule/db/domain/user_db.dart';
import 'package:course_schedule/model/index.dart';
import 'package:course_schedule/model/memberDTO.dart';
import 'package:course_schedule/net/apiClient.dart';
import 'package:course_schedule/net/apiClientSchedule.dart';
import 'package:course_schedule/utils/shared_preferences_util.dart';
import 'package:dio/dio.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../../components/card_view.dart';
import '../../../components/clipper/bottom_curve_clipper.dart';
import '../../../components/item_button.dart';
import '../../../data/values.dart';
import '../../../utils/dialog_util.dart';
import '../../../utils/http_util.dart';
import '../../../utils/util.dart';

class CourseMemberPage extends StatefulWidget {
  final Schedule schedule;
  const CourseMemberPage({super.key,required this.schedule});

  @override
  State<CourseMemberPage> createState() => _CourseMemberPageState();
}

class _CourseMemberPageState extends State<CourseMemberPage> {
  /// 内容距状态栏的高度
  static const double topMargin = 32;
  static const double TodayCourseCardHeight = 40;
  double statusBarHeight = 0;
  double screenHeight = 0;
  double bottomNavBarHeight = 0;
  int attendance_count=0;
  int userId =0;
  bool _loading = true; // 是否正在加载数据的标志
  bool isTeacher = false;
  ApiClient apiClient=ApiClient();
  final List<MemberDto> _data = []; // 学校数据列表
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _signCodeController = TextEditingController();
  final TextEditingController _tuStuNumberController = TextEditingController();
  @override
  void initState() {
    super.initState();
    isTeacherStu();
    getCourseDetail();
    getAttendanceAccount();
  }
  void isTeacherStu() async{
    int userid = await SharedPreferencesUtil.getPreference('userID', 0);
    UserDb? user = await DataBaseManager.queryUserById(userid);
    setState(() {
      if(user!.userType=="01"){
        isTeacher = true;
      }else{
        isTeacher = false;
      }
      userId = userid;
    });
  }
  @override
  Widget build(BuildContext context) {
    statusBarHeight = MediaQuery.of(context).padding.top; // 获取状态栏高度
    screenHeight = MediaQuery.of(context).size.height;
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
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: _buildMemberOpTool(), // 构建提醒工具
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 0, 0, 16),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '成员列表',
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
                            '共计${_data.length}人',
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
                child: _buildExpansionTileCards(), // 构建提醒工具
              ),
            ],
          ),
        ],
      ),
    );
  }
  CardView _buildMemberOpTool() {
    return CardView(
      title: "成员菜单",
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Row(
          children: [
            ItemButton(
              onClick: () {

              },
              title: '扫码签到',
              icon: Icon(
                Icons.qr_code_2_rounded,
                color: Colors.blue.shade400,
              ),
            ),
            ItemButton(
              onClick: isTeacher ?  () async {
                DialogUtil.showCustomWidgetDialog(context, "签到码申领时长(分钟)", signCodeForm(),() async {
                  const regexTeacherCourse = r'(\d+)';
                  final pattern = RegExp(regexTeacherCourse);
                  final match = pattern.firstMatch(_signCodeController.text.trim());
                  if (match == null) {
                    Util.showToastCourse("只允许输入数字", context);
                    return;
                  }
                  if(_formKey.currentState!.validate()){
                    int timeMinute = int.parse(_signCodeController.text.trim());
                    final resp = await HttpUtil.client.get("/cschedule/classes/signCode?timeMinute=$timeMinute&courseId=${widget.schedule.courseId}");
                    int signCode = HttpUtil.getDataFromResponse(resp.toString());
                    if (signCode != null) {
                      DialogUtil.showTipDialog(context, "签到码为：${signCode}，签到码有效时长为${timeMinute}分钟，请告知给本课程学生！");
                    }
                    Util.showToastCourse("申领成功！", context);
                  }
                });
                // bool applyCode = false;
                // DialogUtil.showConfirmDialog(context, "申领2分钟签到码?", () {
                //   setState(() {
                //     applyCode = true;
                //   });
                // }).then((value) async {
                //   if (value == DialogResult.OK && applyCode) {
                //
                //   }
                // });
              } : (){
                DialogUtil.showCustomWidgetDialog(context, "输入签到码", signCodeForm(),() async {
                  const regex = r'(\d{6})';
                  final pattern = RegExp(regex);
                  final match = pattern.firstMatch(_signCodeController.text.trim());
                  if (match == null) {
                    Util.showToastCourse("只允许输入6位数字", context);
                    return;
                  }
                  if(_formKey.currentState!.validate()){
                    if(_signCodeController.text.trim()!=""){
                      int signCode = int.parse(_signCodeController.text.trim());
                      final resp = await HttpUtil.client.post("/cschedule/members/attendance",
                      data: FormData.fromMap({
                        'userId': userId,
                        'courseId': widget.schedule.courseId,
                        'code': signCode,
                      }),);
                      print(resp.toString());
                      final data = HttpUtil.getDataFromResponse(resp.toString());
                      Member member = Member.fromJson(data);
                      if(member!=null){
                        getCourseDetail();
                        Util.showToastCourse("签到成功！", context);
                      }
                    }
                  }
                  // int signCode = HttpUtil.getDataFromResponse(resp.toString());
                });
              },
              title: '签到码',
              icon: Icon(
                Icons.assignment_turned_in_rounded,
                color: Colors.blue.shade400,
              ),
            ),
            if(isTeacher)
              ItemButton(
                onClick: () {
                  DialogUtil.showCustomWidgetDialog(context, "输入成员学工号", addMemberToScheduleWidget(),() async {
                    const regex = r'(\d+)';
                    final pattern = RegExp(regex);
                    final match = pattern.firstMatch(_tuStuNumberController.text.trim());
                    if (match == null) {
                      Util.showToastCourse("学工号只允许输入数字", context);
                      return;
                    }
                    if(_formKey.currentState!.validate()){
                      if(_tuStuNumberController.text.trim()!=""){
                        String tuStuNumber = _tuStuNumberController.text.trim();
                        User userr = await apiClient.searchUserByTuStuNumber(tuStuNumber);
                        UserDb user = UserDb.fromJson(userr.data);
                        // print(user.toJson());
                        List<MemberDto> filteredMembers = _data.where((member) => member.userId == user.userId && member.courseId == widget.schedule.courseId).toList();
                        if(filteredMembers.isNotEmpty){
                          Util.showToastCourse("成员已存在", context);
                          return;
                        }
                        Member member = Member();
                        member.userId = user.userId;
                        member.courseId = widget.schedule.courseId;
                        Member? mem = await ApiClientSchdedule.addMember(member);
                        if(mem!=null){
                          getCourseDetail();
                          DialogUtil.showTipDialog(context, '''成员：${user.userName}加入成功！
请通知该成员使用本课程云课号${widget.schedule.courseNum}进入本课程！
                          ''');
                        }
                      }
                    }
                  });
                },
                title: '添加成员',
                icon: Icon(
                  Icons.group,
                  color: Colors.cyan,
                ),
              ),
            // ItemButton(
            //   onClick: () {
            //   },
            //   title: '挂科预警',
            //   icon: Icon(
            //     Icons.health_and_safety_rounded,
            //     color: Colors.red.shade400,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
  Widget signCodeForm(){
    return Form(
      key: _formKey, // 绑定表单Key
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.disabled, // 禁用自动验证模式
            controller: _signCodeController,
            decoration: InputDecoration(labelText: '只允许输入数字',prefixIcon: const Icon(Icons.drive_file_rename_outline_rounded),),
            validator: RequiredValidator(errorText: "只允许输入数字"),
          ),
        ],
      ),
    );
  }
  Widget addMemberToScheduleWidget(){
    return Form(
      key: _formKey, // 绑定表单Key
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.disabled, // 禁用自动验证模式
            controller: _tuStuNumberController,
            decoration: InputDecoration(labelText: '学号只允许输入数字',prefixIcon: const Icon(Icons.drive_file_rename_outline_rounded),),
            validator: RequiredValidator(errorText: "学号只允许输入数字"),
          ),
        ],
      ),
    );
  }
  CardView _buildMemberListTool() {
    return CardView(
      title: "成员列表",
      // height: 300,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: _buildExpansionTileCards(),
      ),
    );
  }
  Widget _buildExpansionTileCards() {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    );
    if (_loading) {
      // 如果正在加载数据
      return Center(child: CircularProgressIndicator()); // 显示加载指示器
    }
    double height = screenHeight - statusBarHeight - topMargin - TodayCourseCardHeight - bottomNavBarHeight - 310;
    // print('我是成员列表栏目所占高度:$height');
    return Container(
      height: height, // 设置一个固定的高度
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          // final ValueKey<String> key = ValueKey<String>('expansion_tile_$index');
          bool isAvatar = _data[index].avatar=="" || _data[index].avatar==null;
          final GlobalKey<ExpansionTileCardState> cardB = GlobalKey<ExpansionTileCardState>(); // 在这里初始化GlobalKey
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: ExpansionTileCard(
              key: cardB, // 使用UniqueKey确保每个ExpansionTileCard都是唯一的
              baseColor: Colors.white,
              leading: CircleAvatar(backgroundImage: !isAvatar ? NetworkImage(_data[index].avatar!) : null,
                                    child: isAvatar ? Image.asset("images/user_icon.png",width: 30,height: 30,) : null ,),
              title: Text(_data[index].stuName!),
              subtitle: Text(_data[index].stuNum??"学号无"),
              children: <Widget>[
                const Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Text(
                      """成员简介：嗨，我是${_data[index].stuName}""",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 16),
                    ),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceAround,
                  buttonHeight: 52.0,
                  buttonMinWidth: 90.0,
                  children: <Widget>[
                    if(isTeacher)
                    TextButton(
                      style: flatButtonStyle,
                      onPressed: () {
                        // cardB.currentState?.toggleExpansion();
                        DialogUtil.showConfirmDialog(context, "确定从本课程中移除成员${_data[index].stuName}吗？", () async {
                          Member member = Member();
                          member.userId = _data[index].userId;
                          member.courseId = _data[index].courseId;
                          member.arrive = _data[index].arrive;
                          member.resource = _data[index].resource;
                          member.experience = _data[index].experience;
                          member.score = _data[index].score;
                          member.remark = _data[index].remark;
                          int res = await ApiClientSchdedule.customDelete(member);
                          if(res>0){
                            Util.showToastCourse("移除成功！", context);
                          }
                        });
                      },
                      child: const Column(
                        children: <Widget>[
                          Icon(Icons.error,color: Colors.red,),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('移除'),
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Icon(Icons.score_rounded,color: Colors.blue,),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.0),
                        ),
                        Text('资源经验值'),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.0),
                        ),
                        Text('${_data[index].experience}'),
                      ],
                    ),
                    Container(
                      // style: flatButtonStyle,
                      // onPressed: () {
                      //   // 目前毕业设计只设置签到操作与和简单显示功能，不设置补签功能与显示历史签到功能。
                      //   // cardB.currentState?.expand();
                      // },
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.co_present_rounded,color: Colors.blue,),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('签到次数/考勤次数'),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('${_data[index].arrive}/${attendance_count}'),
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

  void getCourseDetail() async {
    try {
      final resp = await HttpUtil.client.get(
          "/cschedule/classes/${widget.schedule.courseId}",
          data: {
            'courseId': widget.schedule.courseId,
          });
      // log(resp.toString());
      final data = HttpUtil.getDataFromResponse(resp.toString()); // 解析响应数据
      if (data['members'] is List) {
        // 如果数据是列表类型
        setState(() {
          _data.clear(); // 清空数据列表
          for(var i=0;i<data['members'].length;i++){
            // print('我是MemberDTO$i:${MemberDto.fromJson(data['members'][i]).toJson()}');
            _data.add(MemberDto.fromJson(data['members'][i]));
          }
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
  void getAttendanceAccount()async{
    try {
      final resp = await HttpUtil.client.get(
          "/cschedule/classes/signCount?courseId=${widget.schedule.courseId}");
      final data = HttpUtil.getDataFromResponse(resp.toString()); // 解析响应数据
      if (data!=null) {
        // 如果数据是列表类型
        setState(() {
          attendance_count = data;
        });
      }
    }catch (e) {
      print(e); // 打印错误信息
    }
  }
  List<Widget> _buildExpansionTileCard(List<Member> list_member) {
    List<Widget> expansionTiles = [];
    // 根据网络请求或其他条件动态生成ExpansionTileCard
    for (int i = 0; i < list_member.length; i++) {
      expansionTiles.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: ExpansionTileCard(
            key: UniqueKey(), // 使用UniqueKey确保每个ExpansionTileCard都是唯一的
            leading: const CircleAvatar(child: Text('A')),
            title: const Text('Tap me!'),
            subtitle: const Text('I expand!'),
            children: <Widget>[
              // ExpansionTileCard的内容
              // 可根据需要自定义
            ],
          ),
        ),
      );
    }
    return expansionTiles;
  }
}
