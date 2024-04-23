import 'package:course_schedule/db/dao/member_dao.dart';
import 'package:course_schedule/model/index.dart';
import 'package:course_schedule/model/memberDTO.dart';
import 'package:course_schedule/net/apiClientSchedule.dart';
import 'package:course_schedule/pages/tabs/plan/today_course.dart';
import 'package:add_calendar_event/add_calendar_event.dart'; // 导入添加日历事件的库
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

import '../../../components/card_view.dart';
import '../../../components/clipper/bottom_curve_clipper.dart';
import '../../../components/item_button.dart';
import '../../../data/values.dart';
import '../../../model/member.dart';
import '../../../provider/store.dart';
import '../../../utils/device_type.dart';
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
  bool _loading = true; // 是否正在加载数据的标志
  final List<MemberDto> _data = []; // 学校数据列表

  @override
  void initState() {
    super.initState();
    getCourseDetail();
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
              title: '签到',
              icon: Icon(
                Icons.assignment_turned_in_rounded,
                color: Colors.blue.shade400,
              ),
            ),
            ItemButton(
              onClick: () {
              },
              title: '小组方案',
              icon: Icon(
                Icons.group,
                color: Colors.orange.shade400,
              ),
            ),
            ItemButton(
              onClick: () {
              },
              title: '挂科预警',
              icon: Icon(
                Icons.health_and_safety_rounded,
                color: Colors.red.shade400,
              ),
            ),
          ],
        ),
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
    print('我是成员列表栏目所占高度:$height');
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
                    TextButton(
                      style: flatButtonStyle,
                      onPressed: () {
                        cardB.currentState?.expand();
                      },
                      child: const Column(
                        children: <Widget>[
                          Icon(Icons.arrow_downward,color: Colors.blue,),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('Open'),
                        ],
                      ),
                    ),
                    TextButton(
                      style: flatButtonStyle,
                      onPressed: () {
                        cardB.currentState?.collapse();
                      },
                      child: const Column(
                        children: <Widget>[
                          Icon(Icons.arrow_upward),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('Close'),
                        ],
                      ),
                    ),
                    TextButton(
                      style: flatButtonStyle,
                      onPressed: () {
                        cardB.currentState?.toggleExpansion();
                      },
                      child: const Column(
                        children: <Widget>[
                          Icon(Icons.swap_vert),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('Toggle'),
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
      final data = HttpUtil.getDataFromResponse(resp.toString()); // 解析响应数据
      if (data['members'] is List) {
        // 如果数据是列表类型
        setState(() {
          _data.clear(); // 清空数据列表
          for(var i=0;i<data['members'].length;i++){
            print('我是MemberDTO$i:${MemberDto.fromJson(data['members'][i]).toJson()}');
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
