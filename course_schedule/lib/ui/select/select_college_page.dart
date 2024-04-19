import 'package:flutter/material.dart'; // 导入flutter的Material库，提供Material风格的UI组件
import 'package:course_schedule/data/values.dart'; // 导入自定义的数值常量
import 'package:course_schedule/utils/http_util.dart'; // 导入自定义的HTTP请求工具类
import 'package:course_schedule/utils/shared_preferences_util.dart'; // 导入自定义的SharedPreferences工具类
import 'package:flutter/services.dart'; // 导入flutter的服务库，用于访问平台服务

class SelectCollegePage extends StatefulWidget {
  @override
  _SelectCollegePageState createState() =>
      _SelectCollegePageState(); // 创建SelectCollegePage的状态类
}

class _SelectCollegePageState extends State<SelectCollegePage> {
  bool _loading = true; // 是否正在加载数据的标志
  final List<String> _data = []; // 学校数据列表

  @override
  void initState() {
    super.initState();
    getCollegeList(); // 在页面初始化时获取学校列表数据
  }

  // 获取学校列表数据的方法
  void getCollegeList() async {
    try {
      final resp =
          await HttpUtil.client.get("/ctimetable/collegeList"); // 发起HTTP请求获取学校列表数据
      final data = HttpUtil.getDataFromResponse(resp.toString()); // 解析响应数据
      if (data is List) {
        // 如果数据是列表类型
        setState(() {
          _loading = false; // 加载完成，更新_loading状态为false
          _data.clear(); // 清空数据列表
          _data.addAll(data.cast<String>()); // 将获取的学校名称数据添加到_data列表中
        });
      }
    } catch (e) {
      print(e); // 打印错误信息
      setState(() {
        _loading = false; // 加载完成，更新_loading状态为false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Values.bgWhite,// 设置背景颜色为白色
      appBar: AppBar(
        title: Text("选择学校"), // 设置AppBar标题为“学校”
        actions: _buildActions(), // 设置AppBar右侧的操作按钮
        systemOverlayStyle: SystemUiOverlayStyle.light, // 设置状态栏样式为浅色
      ),
      body: _buildBody(), // 设置页面主体内容
    );
  }

  // 构建页面主体内容的方法
  Widget _buildBody() {
    if (_loading) {
      // 如果正在加载数据
      return Center(child: CircularProgressIndicator()); // 显示加载指示器
    }
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: GestureDetector(
              onTap: () {
                final name = _data[index].trim(); // 获取选中的学校名称
                SharedPreferencesUtil.savePreference(
                    SharedPreferencesKey.COLLEGE_NAME,
                    name); // 将选中的学校名称保存到SharedPreferences中
                Navigator.pop(context); // 关闭当前页面并返回选中的学校名称
              },
              child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Row(
                    children: [
                      Text(
                        _data[index], // 显示学校名称
                        style: TextStyle(fontSize: 18),
                      ),
                      const Expanded(
                          child: Text(
                        ">", // 显示向右箭头
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 18),
                      ))
                    ],
                  )),
            ),
          );
        },
        itemCount: _data.length); // 构建学校列表视图
  }

  // 构建AppBar右侧操作按钮的方法
  List<Widget> _buildActions() {
    return []; // 返回空的操作按钮列表
  }
}
