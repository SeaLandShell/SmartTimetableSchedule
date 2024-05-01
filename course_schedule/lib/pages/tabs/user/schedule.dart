import 'dart:convert';

import 'package:course_schedule/model/index.dart';
import 'package:course_schedule/net/apiClientSchedule.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';
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
import '../course/course_import_page.dart';
import '../course/course_page.dart';

class MeCoursePage extends StatefulWidget {
  const MeCoursePage({super.key});

  @override
  State<MeCoursePage> createState() => _MeCoursePageState();
}

class _MeCoursePageState extends State<MeCoursePage> {
  /// 内容距状态栏的高度
  static const double topMargin = 32;
  static const double TodayCourseCardHeight = 40;
  double statusBarHeight = 0;
  double screenHeight = 0;
  double progress = 0;
  double bottomNavBarHeight = 0;
  String term="";
  bool _loading=true;
  final List<Course> _data = [];

  @override
  void initState() {
    super.initState();
    getCourseDetail();
    getTerm();
  }
  void getTerm() async {
    String ter="";
    ter=await SharedPreferencesUtil.getPreference("term", "");
    setState(() {
      term=ter;
    });
  }
  @override
  Widget build(BuildContext context) {
    statusBarHeight = MediaQuery.of(context).padding.top; // 获取状态栏高度
    screenHeight = MediaQuery.of(context).size.height;
    bottomNavBarHeight = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      appBar: AppBar(title: Text("我的课程")),
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
                          '${term}',
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
                              '${_data.length}个开通课程',
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
                  child: _buildExpansionTileCards(),
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
                      """暂未开通任何课程，空空如也~""", // 标题文本
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
    double height = screenHeight - statusBarHeight - topMargin - TodayCourseCardHeight - bottomNavBarHeight-50;
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
                        _getInitials(_data[index].name),
                        gradient: SweepGradient(
                          colors: [Colors.blue[900]!, Colors.blueAccent],
                        ),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              title: Text(_data[index].name),
              subtitle: Text(_data[index].classRoom),
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
                    """班级：${_data[index].group}
课程号：${_data[index].teacher}""",
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
                    TextButton(
                      style: flatButtonStyle,
                      onPressed: () {
                        _showCourseDetailDialog(context, _data[index]);
                      },
                      child: const Column(
                        children: <Widget>[
                          Icon(Icons.details_rounded,color: Colors.green,),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('详情',style: TextStyle(color: Colors.green),),
                        ],
                      ),
                    ),
                    TextButton(
                      style: flatButtonStyle,
                      onPressed: () async {
                        jumPage(_data[index], context);
                      },
                      child: const Column(
                        children: <Widget>[
                          Icon(Icons.grass_outlined,color: Colors.blue,),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('进入',style: TextStyle(color: Colors.blueAccent),),
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
    var buffer = StringBuffer();
    var split = user.split(" ");
    for (var s in split) buffer.write(s[0]);
    return buffer.toString().substring(0, split.length);
    // return user.substring(user.length-1,user.length);
  }

  Future<bool?> _showCourseDetailDialog(BuildContext context, Course course) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(8),
          content: CourseDetailWidget(
            course: course,
          ),
        );
      },
    );
  }

  Future<void> jumPage(Course course,BuildContext context) async {
    UserDb? user = await DataBaseManager.queryUserById(await SharedPreferencesUtil.getPreference('userID', 0));
    bool isEnlight = course.courseNum!="";
    Schedule? schedule;
    if(isEnlight){
      schedule = await ApiClientSchdedule.searchCourse(course.courseNum);
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      if(user!.userType=='01'){
        return isEnlight ? CoursePage(index: 0,backgroundColor: Values.bgWhite,className: course.name,schedule: schedule!,) :
        CourseImportPage(course: course,isTeacher: true,);
      }else{
        return isEnlight ? CoursePage(index: 0,backgroundColor: Values.bgWhite,className: course.name,schedule: schedule!,) :
        CourseImportPage(course: course,isTeacher: false,);
      }
    }));
  }

  void getCourseDetail() async {
    try {
      FileUtil.readFromJson(Store.COURSE_JSON_FILE_NAME).then((value) {
        if (value.isEmpty) {
          _loading=false;
          return;
        }
        final List<dynamic>? list = json.decode(value); // 解析 JSON 字符串为 List
        if (list != null) {
          setState(() {
            list.forEach((v) {
              if(v["courseNum"]!=""){
                _data.add(new Course.fromJson(v));
              }
            });
            _loading=false;
          });
        }
      }).catchError((error) {
        print(error);
        Util.showToastCourse("从本地读取课程数据失败", context as BuildContext); // 弹出错误信息
        _loading=false;
      });
    }catch (e) {
      print(e); // 打印错误信息
      _loading=false;
    }
  }
}
