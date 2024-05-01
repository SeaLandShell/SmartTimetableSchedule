// https://github.com/sooxt98/google_nav_bar

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:course_schedule/pages/tabs/calendar/add_event.dart';
import 'package:course_schedule/pages/tabs/calendar/calendar.dart';
import 'package:course_schedule/pages/tabs/plan/plan.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

import '../utils/MyNotificationService.dart';
import './tabs/home/home_page.dart';
import './tabs/user/user_page.dart';

class Tabs extends StatefulWidget {
  final int index;
  final Color backgroundColor;
  const Tabs({super.key,this.index=0,this.backgroundColor = Colors.grey,});
  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  late int _currentIndex;
  List<GButton> tabs = [];
  List<Color> colors = [
    Colors.purple,
    Colors.pink,
    Colors.amber[600]!,
    Colors.teal,
    Colors.lightBlue
  ];
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.w600);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentIndex=widget.index;
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: MyNotificationService.onActionReceivedMethod,
        onNotificationCreatedMethod: MyNotificationService.onNotificationCreatedMethod,
        onNotificationDisplayedMethod: MyNotificationService.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod: MyNotificationService.onDismissActionReceivedMethod);
  }
  final List<Widget> _pages = const [
    PlanPage(),
    HomePage(),
    CalendarPage(),
    // MessagePage(),
    // SettingPage(),
    UserPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 1 ? null : AppBar(title: const Text("智课表"),
        actions: [
          if(_currentIndex==2)
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return AddEventPage();
                })).then((value) => null);
              },
              child: const SizedBox(
                  width: 80,
                  child: Text("新增日程",style: TextStyle(fontSize: 16),)
              ),
            ),
        ],
      ),
      // drawer: Drawer(
      //   child: Column(
      //     children: [
      //       Row(
      //         children:  [
      //           Expanded(
      //               flex: 1,
      //               child: UserAccountsDrawerHeader(
      //                 accountName: const Text("wxw"),
      //                 accountEmail: const Text("wxw@qq.com"),
      //                 otherAccountsPictures:[
      //                   Image.network("https://www.itying.com/images/flutter/1.png"),
      //                      Image.network("https://www.itying.com/images/flutter/2.png"),
      //                      Image.network("https://www.itying.com/images/flutter/3.png"),
      //                 ],
      //                 currentAccountPicture:const CircleAvatar(
      //                   backgroundImage:NetworkImage("https://www.itying.com/images/flutter/3.png")
      //                 ),
      //                 decoration: const BoxDecoration(
      //                     image: DecorationImage(
      //                       fit: BoxFit.cover,
      //                         image: NetworkImage(
      //                             "https://www.itying.com/images/flutter/2.png"))),
      //               ))
      //         ],
      //       ),
      //       const ListTile(
      //         leading: CircleAvatar(
      //           child: Icon(Icons.people),
      //         ),
      //         title: Text("个人中心"),
      //       ),
      //       const Divider(),
      //       const ListTile(
      //         leading: CircleAvatar(
      //           child: Icon(Icons.settings),
      //         ),
      //         title: Text("系统设置"),
      //       ),
      //       const Divider(),
      //     ],
      //   ),
      // ),
     
      body: _pages[_currentIndex],


      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              gap: 8,
              color: Colors.blue[800],
              activeColor: Colors.blue,
              iconSize: 24,
              tabBackgroundColor: Colors.blue.withOpacity(0.2),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              duration: Duration(milliseconds: 1000),
              tabs: [
                GButton(
                  icon: LineIcons.book,
                  text: '计划',
                ),
                GButton(
                  icon: LineIcons.table,
                  text: '课表',
                ),
                GButton(
                  icon: LineIcons.calendarAlt,
                  text: '日程',
                ),
                GButton(
                  icon: LineIcons.user,
                  text: '我的',
                )
              ],
              selectedIndex: _currentIndex,
              onTabChange: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ),
      ),

      // bottomNavigationBar: BottomNavigationBar(
      //     fixedColor: Colors.blue, //选中的颜色
      //     // iconSize:20,           //底部菜单大小
      //     currentIndex: _currentIndex, //第几个菜单选中
      //     type: BottomNavigationBarType.fixed, //如果底部有4个或者4个以上的菜单的时候就需要配置这个参数
      //     onTap: (index) {
      //       //点击菜单触发的方法
      //       //注意
      //       setState(() {
      //         _currentIndex = index;
      //       });
      //     },
      //     items: const [
      //       BottomNavigationBarItem(icon: Icon(Icons.ballot), label: "计划"),
      //       BottomNavigationBarItem(icon: Icon(Icons.view_comfy_rounded), label: "课表"),
      //       BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "日程"),
      //       // BottomNavigationBarItem(icon: Icon(Icons.speaker_notes), label: "待办"),
      //       BottomNavigationBarItem(icon: Icon(Icons.people), label: "我的"),
      //     ]),
      // floatingActionButton: Container(
      //   height: 60, //调整FloatingActionButton的大小
      //   width: 60,
      //   padding: const EdgeInsets.all(5),
      //   margin: const EdgeInsets.only(top: 5), //调整FloatingActionButton的位置
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.circular(30),
      //   ),
      //   child: FloatingActionButton(
      //       backgroundColor: _currentIndex == 1 ? Colors.lightBlue : Colors.blue,
      //       child: const Icon(Icons.add),
      //       onPressed: () {
      //         setState(() {
      //           _currentIndex = 1;
      //         });
      //       }),
      // ),
      // floatingActionButtonLocation:
      //     FloatingActionButtonLocation.centerDocked, //配置浮动按钮的位置
    );
  }
}
