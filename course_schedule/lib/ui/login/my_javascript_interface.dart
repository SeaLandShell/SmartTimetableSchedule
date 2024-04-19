class MyJavaScriptInterface {
  static void showHtml(String html) {
    // 在这里处理来自 JavaScript 的 HTML 数据
    print("Received HTML from JavaScript: $html");
    // 可以将 HTML 数据传递给任何需要的地方，比如解析器进行解析
    // parseHtml(html);
  }
}
