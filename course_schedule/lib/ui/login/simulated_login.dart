import 'package:http/http.dart' as http;

class SimulatedLogin {
  SimulatedLogin._(); // 私有构造函数，防止类被实例化
  Map<String, String> cookies = {};
  static final SimulatedLogin instance = SimulatedLogin._();
  Future<bool> login(String url, Map<String, String> body) async {
    // 发送登录请求
    http.Response response = await http.post(
      // headers: {'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7}',
      Uri.parse(url),
      body: body,
    );

    // 检查响应状态码是否为200
    if (response.statusCode == 200) {
      // 更新Cookie
      updateCookies(response);
      return true;
    } else {
      return false;
    }
  }

  void updateCookies(http.Response response) {
    // 获取所有的Set-Cookie头
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      // 多个Set-Cookie头通常由逗号分隔
      List<String> rawCookies = rawCookie.split(',');
      for (var rawCookie in rawCookies) {
        // Cookie的格式通常是key=value; 其他信息
        List<String> cookieParts = rawCookie.split(';');
        // 只取key=value部分
        String cookie = cookieParts[0];
        // 分割Cookie的key和value
        int index = cookie.indexOf('=');
        if (index != -1) {
          String name = cookie.substring(0, index).trim();
          String value = cookie.substring(index + 1).trim();
          // 存储或更新Cookie
          cookies[name] = value;
        }
      }
    }
  }

// 使用存储的Cookie发送请求
  Future<String> fetchDataWithCookies(String url) async {
    http.Response response = await http.get(
      Uri.parse(url),
      // 将Cookie转换为一个字符串
      headers: {'Cookie': cookies.keys.map((name) => '$name=${cookies[name]}').join('; ')},
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }

}

