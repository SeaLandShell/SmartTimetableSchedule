// import 'dart:async';
//
// import 'package:webview_flutter/webview_flutter.dart'; // 导入 webview_flutter 插件库
// import 'dart:typed_data';
// import 'dart:convert'; // 导入 Dart 的 JSON 处理库
// import 'dart:io';
// import 'dart:developer'; // 导入日志记录库
// import 'package:flutter/material.dart'; // 导入 Flutter Material 组件库
// import '../../model/course.dart'; // 导入课程模型定义
//
// // 定义 WebViewPage 类，它是一个 StatefulWidget，可以在其中使用 WebView 控件
// class WebViewPage extends StatefulWidget {
//   final String initialUrl; // 初始加载的网址属性
//
//   WebViewPage({required this.initialUrl}); // 构造函数，接收一个初始网址
//
//   @override
//   _WebViewPageState createState() => _WebViewPageState(); // 创建状态类的实例
// }
//
// // 定义 _WebViewPageState 类，它包含 WebViewPage 的状态和逻辑
// class _WebViewPageState extends State<WebViewPage> {
//   late WebViewController _webViewController; // 定义一个 WebViewController 变量，用于控制 WebView
//   double progress = 0; // 页面加载进度
//   bool _isTimetablePageLoaded = false; // 课表页面是否已加载的标志
//   String url = ""; // 当前加载的网址
//
//   @override
//   void initState() {
//     super.initState();
//     // 如果是 Android 平台，启用混合模式来允许网页加载 HTTP 内容
//     _webViewController = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..loadRequest(Uri.parse(widget.initialUrl))
//       ..setNavigationDelegate(NavigationDelegate(
//         onNavigationRequest: (request) {
//           // if (request.url.endsWith('/a.html')) {
//           //   scheduleMicrotask(() =>
//           //       _webViewController.loadRequest(Uri.parse('http://localhost:8080/b.html')));
//           //   return NavigationDecision.prevent;
//           // }
//           return NavigationDecision.navigate;
//         },
//         onPageFinished: (url) async {
//           log('Page finished loading: $url');
//           final Object html = await _webViewController.runJavaScriptReturningResult("document.documentElement.outerHTML;");
//           log('Page HTML: $html');
//         },
//       ));
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // 构建 UI 界面
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("教务系统登录"), // 顶部应用栏标题
//       ),
//       body: Column(
//         children: [
//           // 显示加载进度的进度条
//           // LinearProgressIndicator(value: progress),
//           // 使用 Expanded 让 WebView 填充屏幕剩余空间
//           Expanded(
//               child: WebViewWidget(controller: _webViewController),
//             ),
//         ],
//       ),
//       // 悬浮动作按钮，用于导入课表
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.import_export), // 设置图标
//         onPressed: () async {
//           var title = await _webViewController.getTitle();
//           print(title);
//           // 按钮点击事件
//           if (_isTimetablePageLoaded) {
//             // _importTimetable(); // 如果页面加载完成，执行导入课表的函数
//           }
//         },
//       ),
//
//       // 当键盘弹出时，不调整布局
//       resizeToAvoidBottomInset: false,
//     );
//   }
//   Uint8List toUint8List(String str) {
//
//     final List<int> codeUnits = str.codeUnits;
//     final unit8List = Uint8List.fromList(codeUnits);
//
//     return unit8List;
//   }
//
//
//   // 创建模拟课程数据的函数
//   List<Course> _generateDummyCourses() {
//     // 此处创建一个模拟课程列表
//     List<Course> dummyCourses = [
//       Course(
//         name: "网络应用技术",
//         teacher: "张三",
//         classRoom: "教1-101",
//         dayOfWeek: 1,
//         classStart: 1,
//         weekOfTerm: 1,
//         classLength: 2,
//       ),
//       // ...添加其他模拟数据
//     ];
//     return dummyCourses; // 返回模拟课程列表
//   }
// }