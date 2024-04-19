import 'package:course_schedule/pages/tabs/plan/plan.dart';
import 'package:flutter/material.dart';
import './tabs/home/home_page.dart';
import './tabs/message.dart';
import './tabs/setting.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentIndex=widget.index;
  }
  final List<Widget> _pages = const [
    PlanPage(),
    HomePage(),
    // MessagePage(),
    // SettingPage(),
    UserPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("便利课表堂")),
      drawer: Drawer(
        child: Column(
          children: [
            Row(
              children:  [
                Expanded(
                    flex: 1,
                    child: UserAccountsDrawerHeader(
                      accountName: const Text("wxw"),
                      accountEmail: const Text("wxw@qq.com"),
                      otherAccountsPictures:[
                        Image.network("https://www.itying.com/images/flutter/1.png"),
                           Image.network("https://www.itying.com/images/flutter/2.png"),
                           Image.network("https://www.itying.com/images/flutter/3.png"),
                      ],
                      currentAccountPicture:const CircleAvatar(
                        backgroundImage:NetworkImage("https://www.itying.com/images/flutter/3.png")
                      ),
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                              image: NetworkImage(
                                  "https://www.itying.com/images/flutter/2.png"))),
                    ))
              ],
            ),
            const ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.people),
              ),
              title: Text("个人中心"),
            ),
            const Divider(),
            const ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.settings),
              ),
              title: Text("系统设置"),
            ),
            const Divider(),
          ],
        ),
      ),
     
      body: _pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
          fixedColor: Colors.blue, //选中的颜色
          // iconSize:20,           //底部菜单大小
          currentIndex: _currentIndex, //第几个菜单选中
          type: BottomNavigationBarType.fixed, //如果底部有4个或者4个以上的菜单的时候就需要配置这个参数
          onTap: (index) {
            //点击菜单触发的方法
            //注意
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.ballot), label: "计划"),
            BottomNavigationBarItem(icon: Icon(Icons.grid_on), label: "课表"),
            // BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "日程"),
            // BottomNavigationBarItem(icon: Icon(Icons.speaker_notes), label: "待办"),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: "我的"),
          ]),
      floatingActionButton: Container(
        height: 60, //调整FloatingActionButton的大小
        width: 60,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(top: 5), //调整FloatingActionButton的位置
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: FloatingActionButton(
            backgroundColor: _currentIndex == 1 ? Colors.lightBlue : Colors.blue,
            child: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                _currentIndex = 1;
              });
            }),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked, //配置浮动按钮的位置
    );
  }
}
