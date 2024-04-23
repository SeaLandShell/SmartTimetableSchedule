// import 'dart:developer';
// import 'package:html/parser.dart' show parse;
// import 'package:html/dom.dart' as html_parser;
//
// import 'package:course_schedule/utils/parse_util.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
//
// import '../../model/course.dart';
// import '../../provider/store.dart';
// import '../../utils/util.dart';
// import 'my_javascript_interface.dart';
//
// class InAppWebViewPage extends StatefulWidget {
//   final String initialUrl;
//
//   InAppWebViewPage({required this.initialUrl});
//
//   @override
//   _InAppWebViewPageState createState() => _InAppWebViewPageState();
// }
//
// class _InAppWebViewPageState extends State<InAppWebViewPage> {
//   InAppWebViewController? _webViewController;
//   CookieManager? cookieManager;
//   bool _isTimetablePageLoaded = false;
//   String url = "";
//   double progress = 0;
//   String html="";
//   @override
//   void initState() {
//     super.initState();
//     cookieManager = CookieManager.instance();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("教务系统登录"),
//       ),
//       // 使用Column来排列子组件
//       body: Column(
//         children: [
//           // 使用Expanded来使InAppWebView填充剩余空间
//           Expanded(
//             child: Stack(
//               children: [
//                 InAppWebView(
//                   initialUrlRequest: URLRequest(url: Uri.parse(widget.initialUrl)),
//                   initialOptions: InAppWebViewGroupOptions(
//                     crossPlatform: InAppWebViewOptions(
//                       useShouldOverrideUrlLoading: true,
//                       javaScriptEnabled: true,
//                       javaScriptCanOpenWindowsAutomatically: true,
//                       userAgent: "Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1",
//                     ),
//                   ),
//                   onWebViewCreated: (controller) {
//                     _webViewController = controller;
//                     _webViewController?.addJavaScriptHandler(
//                       handlerName: 'MyInterface',
//                       callback: (args) {
//                         String html = args[0]; // 获取 JavaScript 传递过来的参数
//                         MyJavaScriptInterface.showHtml(html);
//                       },
//                     );
//                   },
//                   onLoadStart: (InAppWebViewController controller, Uri? url) {
//                     setState(() {
//                       this.url = url.toString();
//                     });
//                     log('我在onLoadStarthtmlURL:${this.url}');
//                     if (this.url.contains("/xs_main.aspx?xh=2020240332044#a")) {
//                       print('_loadNewUrl(); 执行！：');
//                     }
//                     // _checkIfTimetablePageLoaded(url.toString());
//                   },
//                   onLoadStop: (InAppWebViewController controller, Uri? url) async {
//                         if (this.url.contains("/xs_main.aspx?xh=2020240332044#a")) {
//                         String href = await _webViewController!.evaluateJavascript(source: """
//                               var hrefValue = document.querySelector('#navxl > li:nth-child(6) > ul > li:nth-child(2) > a').getAttribute('href');
//                               hrefValue;
//                             """);
//                         String newUrl = this.url.replaceFirst("xs_main.aspx?xh=2020240332044#a", href);
//                         log('href:$href\nnewHref:$newUrl');
//                         _loadNewUrl(this.url);
// }
//                     // 判断是否为课表页面
//                     String checkTimetableJS = """
//     (function() {
//       var element = document.querySelector('#dqwz');
//       return element ? element.innerText.includes('学生个人课表') : false;
//     })();
//   """;
//
//                     // 执行JavaScript检查
//                     var isTimetablePage = await controller.evaluateJavascript(source: checkTimetableJS);
//
//                     // 根据JavaScript检查的结果更新状态
//                     setState(() {
//                       _isTimetablePageLoaded = isTimetablePage == 'true';
//                     });
//
//                     // 获取页面HTML（如果需要）
//                     if (_isTimetablePageLoaded) {
//                       html = await controller.evaluateJavascript(
//                           source: "window.document.getElementsByTagName('html')[0].outerHTML;"
//                       );
//                       log('当前页面HTML：$html');
//                     }
//                   },
//                   onProgressChanged: (InAppWebViewController controller, int progress) {
//                     if (progress == 100) {
//                       print('// 页面加载完成$url');
//                     }
//                     setState(() {
//                       this.progress = progress / 100;
//                     });
//                   },
//                   onUpdateVisitedHistory: (InAppWebViewController controller, Uri? url, bool? androidIsReload) {
//                     // uri containts newly loaded url
//                     setState(() {
//                       this.url = url.toString();
//                     });
//                   },
//                 ),
//                 // 按钮栏固定在底部
//                 Positioned(
//                   bottom: 0,
//                   left: 0,
//                   right: 0,
//                   child: ButtonBar(
//                     alignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       ElevatedButton(
//                         child: Text("导入课表"),
//                         onPressed: () async {
//                           // 执行 JavaScript 代码
//                           html= await _webViewController?.evaluateJavascript(source: """
//       var ifrs = document.getElementsByTagName("iframe");
//       var iframeContent = "";
//       for (var i = 0; i < ifrs.length; i++) {
//         iframeContent = iframeContent + ifrs[i].contentDocument.body.parentElement.outerHTML;
//       }
//       var frs = document.getElementsByTagName("frame");
//       var frameContent = "";
//       for (var i = 0; i < frs.length; i++) {
//         frameContent = frameContent + frs[i].contentDocument.body.parentElement.outerHTML;
//       }
//       MyInterface.postMessage(document.getElementsByTagName("html")[0].innerHTML + iframeContent + frameContent);
//     """);
//                         },
//
//                       ),
//                       ElevatedButton(
//                         child: Icon(Icons.arrow_back),
//                         onPressed: () {
//                           _webViewController?.goBack();
//                         },
//                       ),
//                       ElevatedButton(
//                         child: Icon(Icons.arrow_forward),
//                         onPressed: () {
//                           _webViewController?.goForward();
//                         },
//                       ),
//                       ElevatedButton(
//                         child: Icon(Icons.refresh),
//                         onPressed: () {
//                           _webViewController?.reload();
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       // 设置resizeToAvoidBottomInset为false，确保键盘弹出时不会顶起按钮栏
//       resizeToAvoidBottomInset: false,
//     );
//   }
//   _loadNewUrl() {
//     // Concatenate the new URL by appending '/xskscx.aspx?' to the original URL
//     String newUrl = _generateNewUrl(this.url);
//     // Load the new URL
//     _webViewController?.loadUrl(urlRequest: URLRequest(url: Uri.parse(newUrl)));
//   }
//   String _generateNewUrl(String originalUrl) {
//     // Split the original URL by '?' to get the base URL and query parameters
//     List<String> parts = originalUrl.split('?');
//     String baseUrl = parts[0]; // Extract the base URL
//     // Append '/xskbcx.aspx' to the base URL
//     String newUrl = baseUrl + '/xskbcx.aspx';
//     // If there are query parameters, append them to the new URL
//     if (parts.length > 1) {
//       newUrl += '?' + parts[1];
//     }
//     return newUrl;
//   }
//
//   Future<void> delayedExecution() async {
//     print('Delayed execution completed.');
//   }
//   // 检查是否加载了课表页
//   void _checkIfTimetablePageLoaded(String url) {
//     // 此处根据你的教务系统网页结构来确定是否已经到达了课表页
//     if (url.contains('timetable')) {
//       setState(() {
//         _isTimetablePageLoaded = true;
//       });
//     }
//   }
//
//   List<Course> generateDummyCourses() {
//   List<Course> dummyCourses = [];
//
//   // 添加假数据
//   dummyCourses.add(Course(
//   name: "Windows网络应用技术",
//   teacher: "秦广军",
//   classRoom: "教4034",
//   dayOfWeek: 1,
//   classStart: 1,
//   weekOfTerm: 1, // 表示所有周
//   classLength: 2,
//   ));
//
//   dummyCourses.add(Course(
//   name: "软件工程",
//   teacher: "娄海涛",
//   classRoom: "实0715",
//   dayOfWeek: 2,
//   classStart: 1,
//   weekOfTerm: 1, // 表示第9-15周的单周
//   classLength: 2,
//   ));
//
//   dummyCourses.add(Course(
//   name: "Java面向对象程序设计",
//   teacher: "刘治国",
//   classRoom: "实0711",
//   dayOfWeek: 2,
//   classStart: 1,
//   weekOfTerm: 1, // 表示第8-14周的双周
//   classLength: 2,
//   ));
//
//   // 添加连续周的数据
//   dummyCourses.add(Course(
//   name: "连续周的课程1",
//   teacher: "连续周的老师1",
//   classRoom: "连续周的教室1",
//   dayOfWeek: 3,
//   classStart: 3,
//   weekOfTerm: 2, // 表示第1-4周
//   classLength: 2,
//   ));
//
//   dummyCourses.add(Course(
//   name: "连续周的课程2",
//   teacher: "连续周的老师2",
//   classRoom: "连续周的教室2",
//   dayOfWeek: 4,
//   classStart: 4,
//   weekOfTerm: 3, // 表示第5-8周
//   classLength: 2,
//   ));
//
//   // 添加更多假数据...
//
//   return dummyCourses;
//   }
//
// }