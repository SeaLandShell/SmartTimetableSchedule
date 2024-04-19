import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../entity/time.dart'; // 导入时间实体类

class SharedPreferencesUtil {
  SharedPreferencesUtil._(); // 私有构造函数，防止类被实例化

  /// 存数据
  static Future<bool> savePreference(String key, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // 获取 SharedPreferences 实例
    if (value is int) { // 如果 value 是整数类型
      return await prefs.setInt(key, value); // 存储整数类型数据
    } else if (value is double) { // 如果 value 是浮点数类型
      return await prefs.setDouble(key, value); // 存储浮点数类型数据
    } else if (value is bool) { // 如果 value 是布尔类型
      return await prefs.setBool(key, value); // 存储布尔类型数据
    } else if (value is String) { // 如果 value 是字符串类型
      return await prefs.setString(key, value); // 存储字符串类型数据
    } else if (value is List<String>) { // 如果 value 是字符串列表类型
      return await prefs.setStringList(key, value); // 存储字符串列表类型数据
    } else { // 如果 value 类型不支持
      throw new Exception("不能得到这种类型"); // 抛出异常
    }
  }

  /// 取数据
  static Future<dynamic> getPreference(String key, dynamic defaultValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // 获取 SharedPreferences 实例
    if (defaultValue is int) { // 如果 defaultValue 是整数类型
      return prefs.getInt(key) ?? defaultValue; // 获取整数类型数据，若为空则返回默认值
    } else if (defaultValue is double) { // 如果 defaultValue 是浮点数类型
      return prefs.getDouble(key) ?? defaultValue; // 获取浮点数类型数据，若为空则返回默认值
    } else if (defaultValue is bool) { // 如果 defaultValue 是布尔类型
      return prefs.getBool(key) ?? defaultValue; // 获取布尔类型数据，若为空则返回默认值
    } else if (defaultValue is String) { // 如果 defaultValue 是字符串类型
      return prefs.getString(key) ?? defaultValue; // 获取字符串类型数据，若为空则返回默认值
    } else if (defaultValue is List) { // 如果 defaultValue 是列表类型
      return prefs.getStringList(key) ?? defaultValue; // 获取字符串列表类型数据，若为空则返回默认值
    } else { // 如果 defaultValue 类型不支持
      throw new Exception("不能得到这种类型"); // 抛出异常
    }
  }

  /// 删除指定数据
  static void remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // 获取 SharedPreferences 实例
    prefs.remove(key); // 删除指定键
  }

  /// 清空整个缓存
  static void clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // 获取 SharedPreferences 实例
    prefs.clear(); // 清空缓存
  }

  /// 获取时间列表
  static Future<List<TimeEntity>> getTime() async {
    final String content = await getPreference(SharedPreferencesKey.CLASS_TIME, ""); // 获取时间信息的 JSON 字符串
    if (content.trim().isNotEmpty) { // 如果 JSON 字符串不为空
      final list = json.decode(content); // 解码 JSON 字符串
      if (list is List) { // 如果解码后的结果是列表
        return list.map((e) => TimeEntity.fromJson(e)).toList(); // 将列表中的 JSON 对象转换为时间实体对象并返回列表
      }
    }
    return []; // 若无数据，则返回空列表
  }
}

class SharedPreferencesKey {
  SharedPreferencesKey._(); // 私有构造函数，防止类被实例化

  /// token
  static const TOKEN = "token";

  static const EXPIRE = "expire";

  static const TIMESTAMP = "timestamp";

  /// 教务系统账号
  static const COLLEGE_ACCOUNT = "college_account";

  /// 教务系统密码
  static const COLLEGE_PWD = "college_pwd";

  /// 学校名称
  static const COLLEGE_NAME = "college_name";

  /// 是否导入课程
  static const IS_IMPORT_CALENDAR = "isImportCalendar";

  static const CLASS_TIME = "class_time";

  static const BG_CONFIG = "bg_config";

  static const CURRENT_WEEK = "currentWeek";
}
