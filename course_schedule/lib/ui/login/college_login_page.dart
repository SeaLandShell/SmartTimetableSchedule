import 'package:course_schedule/utils/shared_preferences_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marquee/marquee.dart';
import '../../data/values.dart';
import '../../model/course.dart';
import '../../provider/store.dart';
import '../../utils/http_util.dart';
import '../../utils/util.dart';
import '../select/select_college_page.dart';
import 'in_app_webview_page.dart';

class CollegeLoginPage extends StatefulWidget {
  @override
  _CollegeLoginPageState createState() => _CollegeLoginPageState();
}

class _CollegeLoginPageState extends State<CollegeLoginPage> {
  String? _collegeName;
  final List<String> _data = []; // 学校数据列表

  @override
  void initState() {
    super.initState();
    _getCollegeName();
    getCollegeList();
  }

  // 获取学校名称
  Future<void> _getCollegeName() async {
    // 从SharedPreferences中获取学校名称，如果获取失败则使用默认名称
    String collegeName = await SharedPreferencesUtil.getPreference(
        SharedPreferencesKey.COLLEGE_NAME, "北京联合大学");
    // 更新界面显示的学校名称
    setState(() {
      _collegeName = collegeName;
    });
  }
  // 获取学校列表数据的方法
  void getCollegeList() async {
    try {
      final resp = await HttpUtil.client.get("/ctimetable/collegeList"); // 发起HTTP请求获取学校列表数据
      final data = HttpUtil.getDataFromResponse(resp.toString()); // 解析响应数据
      if (data is List) {
        // 如果数据是列表类型
        setState(() {
          _data.clear(); // 清空数据列表
          _data.addAll(data.cast<String>()); // 将获取的学校名称数据添加到_data列表中
        });
      }
    } catch (e) {print(e);}
  }

  // 导航到WebView页面
  void _navigateToWebView(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InAppWebViewPage(initialUrl: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Values.bgWhite,
      appBar: AppBar(
        title: Text("教务系统登录"),
        actions: _buildActions(), // 设置 AppBar 的右侧操作按钮，调用 _buildActions 方法生成
        systemOverlayStyle: SystemUiOverlayStyle.light, // 设置系统覆盖样式为亮色模式
      ),
      body: Column(
        children: [
        Container(
        // color: const Color.fromRGBO(0, 131, 213, 1),
        // color: const Color(0x90C8F9),
        // color: const Color.fromRGBO(144, 200, 249, 1),
        color: Colors.blue,
        height: 50,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Marquee(
            text: '请前往课表页点击“导入课表”按钮导课。', // 要滚动的文本
            style: TextStyle(color: Colors.white), // 文本样式，白色
            velocity: 50.0, // 滚动速度
            pauseAfterRound: Duration(seconds: 0), // 一轮滚动后的暂停时间
            blankSpace: 20.0, // 文本之间的间距
            crossAxisAlignment: CrossAxisAlignment.center, // 文本对齐方式，居中
            startPadding: 10.0, // 开始滚动前的内边距
            accelerationDuration: Duration(seconds: 1), // 加速度持续时间
            accelerationCurve: Curves.linear, // 加速度曲线
            decelerationDuration: Duration(milliseconds: 500), // 减速度持续时间
            decelerationCurve: Curves.easeOut, // 减速度曲线
          ),
        ),
      ),
          Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // 设置下拉框的背景颜色
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: false,
                    value: _collegeName,
                    items: _data.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _collegeName = newValue ?? "";
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // 设置下拉框与卡片间的间距
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start, // 从列的开始位置对齐小部件
                  children: [
                    _buildCard(
                      title: '学校内网登录',
                      onPressed: () {
                        _navigateToWebView("https://jwxt.buu.edu.cn");
                      },
                    ),
                    SizedBox(height: 20), // 设置卡片之间的间距
                    _buildCard(
                      title: 'WebVPN登录',
                      onPressed: () {
                        _navigateToWebView("https://wvpn.buu.edu.cn/https/77726476706e69737468656265737421fae0598869327d45300d8db9d6562d");
                      },
                    ),
                    // 可以根据需要添加更多的卡片
                  ],
                ),
              ),
            ),
          ],
        ),
      ),],)
    );
  }

  Widget _buildCard({required String title, required void Function() onPressed}) {
    return Card(
      elevation: 5.0,
      shadowColor: Colors.white,
      surfaceTintColor: Colors.white,
      color: Colors.white, // 设置卡片的背景颜色
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          width: double.infinity,
          // 假设这是你想要的卡片高度，可以根据需要调整
          height: MediaQuery.of(context).size.width / 2 - 60,
          child: Center(
            child: Text(
              title,
              style: TextStyle(fontSize: 36.0,fontFamily: 'Microsoft YaHei'),
            ),
          ),
        ),
      ),
    );
  }
  List<Widget> _buildActions() {
    // 定义一个方法 _buildActions，返回一个 Widget 列表作为 AppBar 的右侧操作按钮
    return [
      // 返回一个包含一个 Center 组件的列表
      Center(
        // 创建一个 Center 组件，用于使其子组件居中显示
          child: InkWell(
            // 创建一个 InkWell 组件，实现点击效果
              onTap: () {
                // 设置点击事件处理函数
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  // 使用导航器跳转到选择学校页面
                  return SelectCollegePage(); // 返回选择学校页面
                }));
              },
              child: const Padding(
                // 创建一个 Padding 组件，设置内边距
                padding: EdgeInsets.all(8.0), // 设置四周的内边距均为 8
                child: Text("选择学校"), // 在内边距内显示文本 "选择学校"
              )
          )
      )
    ];
  }

}













// 解析周数字符串，返回表示本学期周数的整数
int getWeekOfTermFromString(String weekString) {
  // 你的解析逻辑
  // 返回表示本学期周数的整数
  return 0;
}
