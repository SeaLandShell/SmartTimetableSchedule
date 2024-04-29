// https://github.com/JakesMD/flutter_capped_progress_indicator
// https://github.com/pktintali/flutter_custom_cards
// https://github.com/fluttercandies/flutter_wechat_assets_picker/blob/main/README-ZH.md

import 'dart:io';

import 'package:course_schedule/model/index.dart';
import 'package:course_schedule/net/apiClientSchedule.dart';
import 'package:course_schedule/pages/tabs/course/upload/studentwork/homework_record_submit.dart';
import 'package:course_schedule/pages/tabs/course/upload/studentwork/homework_submit.dart';
import 'package:course_schedule/pages/tabs/course/upload/teacherwork/submited_homework.dart';
import 'package:course_schedule/pages/tabs/course/upload/teacherwork/update_homework.dart';
import 'package:course_schedule/utils/dialog_util.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';
import 'package:shine_flutter/shine_flutter.dart';

import '../../../components/clipper/bottom_curve_clipper.dart';
import '../../../data/values.dart';
import '../../../db/database_manager.dart';
import '../../../db/domain/user_db.dart';
import '../../../model/Work.dart';
import '../../../utils/http_util.dart';
import '../../../utils/shared_preferences_util.dart';
import '../../../utils/util.dart';



class CourseActivityPage extends StatefulWidget {
  final Schedule schedule;
  const CourseActivityPage({super.key,required this.schedule});

  @override
  State<CourseActivityPage> createState() => _CourseActivityPageState();
}

class _CourseActivityPageState extends State<CourseActivityPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  /// 内容距状态栏的高度
  static const double topMargin = 32;
  static const double TodayCourseCardHeight = 40;
  double statusBarHeight = 0;
  double screenHeight = 0;
  double screenWidth = 0;
  double bottomNavBarHeight = 0;
  int userId = 0;
  int resourceLearnCount = 0;
  int tabIndex = 0;
  String ext = "jpg";
  bool _loading = true; // 是否正在加载数据的标志
  bool isTeacher = false;
  bool hasLearn = false;
  final List<Work> _data=[];
  bool hide = false;
  File? selectedFile;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    isTeacherOrStu();
    getCourseDetail();
    _tabController = TabController(length: 3, vsync: this);
    //监听_tabController的改变事件
    _tabController.addListener(() {
      setState(() {
        _loading=true;
        _data.clear();
        tabIndex = _tabController.index;
      });
      getCourseDetail();
    });
    resourcehasLearnCount();
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
  //组件销毁的时候触发
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //销毁_tabController
    _tabController.dispose();
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
                const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                child: SizedBox(
                  //改TabBar的高度
                  height: TodayCourseCardHeight / 2 + 8,
                  child: TabBar(
                    labelStyle: const TextStyle(fontSize: 16),
                    dividerColor: Colors.blueGrey.shade100,
                    dividerHeight: 3,
                    tabAlignment: TabAlignment.center,
                    isScrollable: true, // 设置为可滚动
                    indicatorColor: Colors.cyanAccent, //底部指示器的颜色
                    labelColor: Colors.cyanAccent,
                    unselectedLabelColor: Colors.white, //lable未选中的颜色
                    indicatorSize: TabBarIndicatorSize.label, // 设置指示器大小
                    controller: _tabController,
                    tabs: [
                      Tab(
                        child: SizedBox( // 使用SizedBox设置Tab的宽度
                          width: screenWidth / 4, // 屏幕宽度除以Tab数量
                          child: Center(child: Text("全部")),
                        ),
                      ),
                      Tab(
                        child: SizedBox(
                          width: screenWidth / 4,
                          child: Center(child: Text("进行中")),
                        ),
                      ),
                      Tab(
                        child: SizedBox(
                          width: screenWidth / 4,
                          child: Center(child: Text("已结束")),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 900,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, statusBarHeight + topMargin + TodayCourseCardHeight, 0, 0),
              child: TabBarView(controller: _tabController, children: [
                SingleChildScrollView(child: _buildAllWork(),),
                SingleChildScrollView(child: _buildAllWork(),),
                SingleChildScrollView(child: _buildAllWork(),),
              ]),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildAllWork(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 0, 16),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  '作业列表',
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
                      _data.isNotEmpty && _data.length!=0 ? '共计${_data.length}作业':'共0作业',
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: _buildExpansionTileCardsAll(),
        ),
      ],
    );
  }
  Widget _buildExpansionTileCardsAll() {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    );
    if (_loading || _data.isEmpty || _data.length==0) {
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
                      """暂无作业，空空如也~""", // 标题文本
                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold), // 文本样式
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ); // 显示加载指示器
    }
    double height = screenHeight - statusBarHeight - topMargin - TodayCourseCardHeight - bottomNavBarHeight-150;
    return Container(
      height: height, // 设置一个固定的高度
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
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
                        "作业",
                        gradient: SweepGradient(
                          colors: [Colors.blue[900]!, Colors.blueAccent],
                        ),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              title: Text("${_data[index].workName!}"),
              subtitle: subTitle(_data[index].state!),
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
                    """发布时间：${_data[index].gmtCreate!}
开始时间：${_data[index].startTime!}
结束时间：${_data[index].endTime!}""",
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
                    isTeacher? TextButton(
                      style: flatButtonStyle,
                      onPressed: () {
                        DialogUtil.showConfirmDialog(context, "确认删除作业：${_data[index].workName!}",() async {
                          if(await ApiClientSchdedule.workDelete(_data[index])>0){
                            Util.showToastCourse("删除作业${_data[index].workName!}成功！", context);
                            setState(() {
                              _data.clear();
                              _loading=false;
                              getCourseDetail();
                            });
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
                    ) : TextButton(
                      style: flatButtonStyle,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return HomeworkRecordSubmitPage(schedule: widget.schedule, work: _data[index]);
                        }));
                      },
                      child: const Column(
                        children: <Widget>[
                          Icon(Icons.event_note_rounded,color: Colors.blueAccent,),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('提交记录',style: TextStyle(color: Colors.blueAccent),),
                        ],
                      ),
                    ),
                    isTeacher? TextButton(
                      style: flatButtonStyle,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return UpdateHomeworkPage(schedule: widget.schedule,work: _data[index],);
                        }),);
                      },
                      child: const Column(
                        children: <Widget>[
                          Icon(Icons.edit_note_rounded,color: Colors.blue,),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('编辑',style: TextStyle(color: Colors.blue),),
                        ],
                      ),
                    ) : TextButton(
                      style: flatButtonStyle,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return UpdateHomeworkPage(schedule: widget.schedule, work: _data[index]);
                        }));
                      },
                      child: const Column(
                        children: <Widget>[
                          Icon(Icons.details_rounded,color: Colors.blue,),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('要求',style: TextStyle(color: Colors.blue),),
                        ],
                      ),
                    ),
                    isTeacher ? TextButton(
                      style: flatButtonStyle,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return SubmitedHomeworkPage(schedule: widget.schedule,work: _data[index],);
                        }),);
                      },
                      child: const Column(
                        children: <Widget>[
                          Icon(Icons.swap_vert_circle_rounded,color: Colors.blue,),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('提交情况',style: TextStyle(color: Colors.blue),),
                        ],
                      ),
                    ) : TextButton(
                      style: flatButtonStyle,
                      onPressed: () {
                        if(_data[index].state==2){
                          Util.showToastCourse("已结束，不允许提交！", context);
                          return;
                        }else if(_data[index].state==0){
                          Util.showToastCourse("未开始，不允许提交！", context);
                          return;
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return HomeworkSubmitPage(schedule: widget.schedule,work: _data[index],);
                        }),);
                      },
                      child: const Column(
                        children: <Widget>[
                          Icon(Icons.navigation_rounded,color: Colors.greenAccent,),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('提交',style: TextStyle(color: Colors.green),),
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
  Widget subTitle(int state){
    if(state==0){
      return Text("未开始",style: TextStyle(color: Colors.blue.shade300),);
    }else if(state==1){
      return Text("正在进行中",style: TextStyle(color: Colors.blue.shade600),);
    }else{
      return Text("已结束",style: TextStyle(color: Colors.black),);
    }
  }

  void getCourseDetail() async {
    try {
      final resp = await HttpUtil.client.get(
          "/cschedule/works/${widget.schedule.courseId}",
          data: {
            'courseId': widget.schedule.courseId,
          });
      // log(resp.toString());
      final data = HttpUtil.getDataFromResponse(resp.toString()); // 解析响应数据
      if (data is List) {
        if(data.isEmpty){
          _loading=false;
          return;
        }
        // 如果数据是列表类型
        setState(() {
          _data.clear();
          if(tabIndex==0){
            for(var i=0;i<data.length;i++){
              _data.add(Work.fromJson(data[i]));
            }
          }else if(tabIndex == 1){
            for(var i=0;i<data.length;i++){
              if(data[i]["state"]==1){
                _data.add(Work.fromJson(data[i]));
              }
            }
          }else{
            for(var i=0;i<data.length;i++){
              if(data[i]["state"]==2){
                _data.add(Work.fromJson(data[i]));
              }
            }
          }
          _data.sort((a, b) => a.startTime!.compareTo(b.startTime!));
          _loading = false; // 加载完成，更新_loading状态为false
        });
      }else{
        _loading = false;
      }
    } catch (e) {
      print(e); // 打印错误信息
      setState(() {
        _loading = false; // 加载完成，更新_loading状态为false
      });
    }
  }

//   资源学习个数总数
  void resourcehasLearnCount()async{
    try {
      final resp = await HttpUtil.client.get(
        "/cschedule/members/resourcehasLearnCount?userId=${await SharedPreferencesUtil.getPreference("userID", 0)}&courseId=${widget.schedule.courseId}",);
      final data = HttpUtil.getDataFromResponse(resp.toString()); // 解析响应数据
      if (data!=null) {
        // 如果数据是列表类型
        setState(() {
          resourceLearnCount = data;
        });
      }
    } catch (e) {
      print(e); // 打印错误信息
    }
  }
}
