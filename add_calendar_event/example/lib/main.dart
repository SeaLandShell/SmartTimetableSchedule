import 'package:flutter/material.dart'; // 导入Flutter的Material库
import 'dart:async'; // 导入Dart的异步操作库

import 'package:flutter/services.dart'; // 导入Flutter的系统服务库，用于与平台通信
import 'package:add_calendar_event/add_calendar_event.dart'; // 导入添加日历事件的插件

void main() {
  runApp(const MyApp()); // 运行Flutter应用程序，并传入MyApp作为根组件
}

class MyApp extends StatefulWidget {
  // MyApp类继承自StatefulWidget，表示应用的根组件
  const MyApp({Key? key}) : super(key: key); // 构造函数，接受一个可选的Key参数

  @override
  State<MyApp> createState() => _MyAppState(); // 创建与MyApp关联的状态对象
}

class _MyAppState extends State<MyApp> {
  // _MyAppState类表示MyApp的状态
  String _platformVersion = 'Unknown'; // 平台版本信息，默认为'Unknown'
  final _addCalendarEventPlugin = AddCalendarEvent(); // 添加日历事件的插件实例

  @override
  void initState() {
    // 初始化状态，通常用于执行一次性操作
    super.initState(); // 调用父类的initState方法
    initPlatformState(); // 初始化平台状态
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  // 平台消息是异步的，因此我们在一个异步方法中初始化。
  Future<void> initPlatformState() async {
    // 异步方法，用于初始化平台状态
    String platformVersion; // 平台版本信息
    try {
      // 尝试执行以下代码块
      platformVersion = // 获取平台版本信息
          await _addCalendarEventPlugin.getPlatformVersion() ??
              'Unknown platform version'; // 调用添加日历事件插件的获取平台版本信息方法，并获取返回值
    } on PlatformException {
      // 捕获PlatformException异常
      platformVersion =
          'Failed to get platform version.'; // 如果出现异常，将平台版本信息设置为获取失败
    }

    if (!mounted) return; // 如果该状态对象已经被移除，直接返回，避免更新UI

    setState(() {
      // 更新UI
      _platformVersion = platformVersion; // 更新平台版本信息
    });
  }

  @override
  Widget build(BuildContext context) {
    // 构建UI界面的方法
    return MaterialApp(
      // 返回一个MaterialApp组件作为根组件
      home: Scaffold(
        // 返回一个Scaffold组件作为页面的基本结构
        appBar: AppBar(
          // 设置应用栏
          title: const Text('Plugin example app'), // 标题为'Plugin example app'
        ),
        body: Center(
          // 居中显示内容
          child: Text('Running on: $_platformVersion\n'), // 显示平台版本信息
        ),
      ),
    );
  }
}
