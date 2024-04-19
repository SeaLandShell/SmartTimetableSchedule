import '../utils/shared_preferences_util.dart'; // 导入 shared_preferences_util.dart 文件，用于存储和获取 token

class TokenRepository { // 定义 TokenRepository 类，用于管理 token
  TokenRepository._privateConstructor(); // 私有构造函数，防止类被实例化

  static final TokenRepository _instance = // 创建 TokenRepository 的单例对象
  TokenRepository._privateConstructor(); // 调用私有构造函数创建对象

  static TokenRepository getInstance() => _instance; // 获取 TokenRepository 的单例对象

  String? _token; // 定义私有变量 _token，用于存储 token
  int? _expire;
  int? _timeStamp;


  int? get timeStamp => _timeStamp;
  String? get token => _token; // 获取 token 的 getter 方法
  int? get expire => _expire;
  set token(String? value) { // 设置 token 的 setter 方法
    _token = value; // 更新私有变量 _token 的值
    timeStamp = DateTime.now().millisecondsSinceEpoch ~/ 60000;
    SharedPreferencesUtil.savePreference( // 调用 SharedPreferencesUtil 中的 savePreference 方法保存 token
        SharedPreferencesKey.TOKEN, value ?? ""); // 将 token 存储到 SharedPreferences 中
  }
  set expire(int? value) {
    _expire = value;
    SharedPreferencesUtil.savePreference( // 调用 SharedPreferencesUtil 中的 savePreference 方法保存 token
        SharedPreferencesKey.EXPIRE, value ?? 0);
  }
  set timeStamp(int? value) {
    _timeStamp = value;
    SharedPreferencesUtil.savePreference( // 调用 SharedPreferencesUtil 中的 savePreference 方法保存 token
        SharedPreferencesKey.TIMESTAMP, value ?? 0);
  }
  Future<String> getTokenFromSharedPreferences() async { // 从 SharedPreferences 中获取 token 的异步方法
    _token = await SharedPreferencesUtil.getPreference( // 调用 SharedPreferencesUtil 中的 getPreference 方法获取 token
        SharedPreferencesKey.TOKEN, ""); // 从 SharedPreferences 中获取 token，并设置默认值为空字符串
    return _token!; // 返回获取到的 token
  }
  Future<int> getExpireFromSharedPreferences() async { // 从 SharedPreferences 中获取 token 的异步方法
    _expire = await SharedPreferencesUtil.getPreference( // 调用 SharedPreferencesUtil 中的 getPreference 方法获取 token
        SharedPreferencesKey.EXPIRE, 0); // 从 SharedPreferences 中获取 token，并设置默认值为空字符串
    return _expire!; // 返回获取到的 token
  }
  Future<int> getTimeStampFromSharedPreferences() async { // 从 SharedPreferences 中获取 token 的异步方法
    _timeStamp = await SharedPreferencesUtil.getPreference( // 调用 SharedPreferencesUtil 中的 getPreference 方法获取 token
        SharedPreferencesKey.TIMESTAMP, 0); // 从 SharedPreferences 中获取 token，并设置默认值为空字符串
    return _timeStamp!; // 返回获取到的 token
  }


  void clear() { // 清除 token 的方法
    _token = ""; // 将私有变量 _token 置空
    _expire =0;
    _timeStamp=0;
    SharedPreferencesUtil.remove(SharedPreferencesKey.TIMESTAMP);
    SharedPreferencesUtil.remove(SharedPreferencesKey.TOKEN); // 调用 SharedPreferencesUtil 中的 remove 方法删除 SharedPreferences 中的 token
    SharedPreferencesUtil.remove(SharedPreferencesKey.EXPIRE);
  }
}
