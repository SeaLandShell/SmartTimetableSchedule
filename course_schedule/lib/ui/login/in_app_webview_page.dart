import 'dart:developer';
import 'package:course_schedule/utils/parse_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../models/course.dart';

class InAppWebViewPage extends StatefulWidget {
  final String initialUrl;

  InAppWebViewPage({required this.initialUrl});

  @override
  _InAppWebViewPageState createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  InAppWebViewController? _webViewController;
  CookieManager? cookieManager;
  bool _isTimetablePageLoaded = false;
  String url = "";
  double progress = 0;
  String html="";
  Map<String, String> allCookies = {};
  @override
  void initState() {
    super.initState();
    cookieManager = CookieManager.instance();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("教务系统登录"),
      ),
      // 使用Column来排列子组件
      body: Column(
        children: [
          // 使用Expanded来使InAppWebView填充剩余空间
          Expanded(
            child: Stack(
              children: [
                InAppWebView(
                  initialUrlRequest: URLRequest(url: Uri.parse(widget.initialUrl)),
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      useShouldOverrideUrlLoading: true,
                      javaScriptEnabled: true,
                      javaScriptCanOpenWindowsAutomatically: true,
                      userAgent: "Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1",
                    ),
                    android: AndroidInAppWebViewOptions(
                        // on Android you need to set supportMultipleWindows to true,
                        // otherwise the onCreateWindow event won't be called
                          supportMultipleWindows: true,
                      useHybridComposition: true,
                    ),
                  ),
                  onWebViewCreated: (controller) {
                    _webViewController = controller;
                  },
                  onLoadStart: (InAppWebViewController controller, Uri? url) async {
                    setState(() {
                      this.url = url.toString();
                    });
                    // log('我在onLoadStart：${this.url}');
                  },
                  onLoadError: (controller, url, code, message) {
                    // 输出加载错误信息
                    print("Error loading $url: $message");
                  },
                  onLoadStop: (InAppWebViewController controller, Uri? url) async {
                    List<Cookie> cookies = await cookieManager!.getCookies(url: Uri.parse(this.url));
                    for (var cookie in cookies) {
                      allCookies[cookie.name] = cookie.value;
                      print('cookie${cookie.value}');
                    }
                    await Future.delayed(Duration(seconds: 1));
                    if(this.url.contains('/xs_main.aspx?')){
                      setState(() {
                        this._isTimetablePageLoaded=true;
                      });
                    }
                    // log('当前url与html：${this.url}+\n+html');
                  },
                  onProgressChanged: (InAppWebViewController controller, int progress) {
                    setState(() {
                      this.progress = progress / 100;
                    });
                  },
                  onUpdateVisitedHistory: (InAppWebViewController controller, Uri? url, bool? androidIsReload) {
                    // uri containts newly loaded url
                    setState(() {
                      this.url = url.toString();
                    });
                  },
                    androidOnPermissionRequest: (InAppWebViewController controller, String origin, List<String> resources) async {
                      return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
                    },
                  onReceivedServerTrustAuthRequest: (controller, challenge) async {
                    return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
                  },
                ),
                // 按钮栏固定在底部
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue.withOpacity(0.5)),
                        ),
                        child: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          _webViewController?.goBack();
                        },
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue.withOpacity(0.5)),
                        ),
                        child: Icon(Icons.arrow_forward, color: Colors.white),
                        onPressed: () {
                          _webViewController?.goForward();
                        },
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue.withOpacity(0.5)),
                        ),
                        child: Icon(Icons.refresh, color: Colors.white),
                        onPressed: () {
                          _webViewController?.reload();
                        },
                      ),
                      _isTimetablePageLoaded ? ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue.withOpacity(0.5)),
                        ),
                        child: Text("导入课表", style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          String iframeHtml = await _webViewController?.evaluateJavascript(source: """
        var iframeContent = document.querySelector('iframe').contentDocument.body.innerHTML;
        iframeContent;
      """);
                          // log(iframeHtml);
                          ParseUtil.instance.importTimetable(iframeHtml,context);
                        },
                      ): SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // 设置resizeToAvoidBottomInset为false，确保键盘弹出时不会顶起按钮栏
      resizeToAvoidBottomInset: false,
    );
  }

  Future<void> _loadNewUrl(String newUrl) async {
    // 将所有cookies转化为Cookie header字符串
    String cookieHeader = allCookies.entries.map((e) => "${e.key}=${e.value}").join("; ");
    log('cookieHeader:$cookieHeader');
    Map<String, String> headers = {
      'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
      'Accept-Encoding': 'gzip, deflate, br, zstd',
      'Accept-Language': 'zh-CN,zh;q=0.9',
      'Connection': 'keep-alive',
      'Cookie': cookieHeader,
      'Referer': 'https://wvpn.buu.edu.cn/https/77726476706e69737468656265737421fae0598869327d45300d8db9d6562d/xs_main.aspx?xh=2020240332044',
      'Sec-Fetch-Dest': 'document',
      'Sec-Fetch-Mode': 'navigate',
      'Sec-Fetch-Site': 'same-origin',
      'Sec-Fetch-User': '?1',
      'Upgrade-Insecure-Requests': '1',
      'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1',
    };
    // 加载新的URL
    _webViewController?.loadUrl(
      urlRequest: URLRequest(
        url: Uri.parse(newUrl),
        headers: headers,
      ),
    );
  }

}