import 'dart:async';
import 'dart:convert'; // 导入 dart:convert 库，用于 JSON 数据的编解码

import 'package:dio/dio.dart'; // 导入 dio 库，用于进行网络请求
import 'package:flutter/cupertino.dart'; // 导入 flutter 的 Cupertino 库，用于构建 Cupertino 风格的 UI 组件
import 'package:course_schedule/data/token_repository.dart'; // 导入 token_repository.dart 文件，用于获取身份验证 token
import 'package:course_schedule/utils/dialog_util.dart'; // 导入 dialog_util.dart 文件，用于显示对话框
import 'package:course_schedule/utils/text_util.dart'; // 导入 text_util.dart 文件，用于文本相关的工具函数
import 'package:course_schedule/utils/util.dart';
import 'package:path/path.dart';

import '../net/globalVariables.dart'; // 导入 util.dart 文件，用于通用的工具函数

class HttpUtil {
  HttpUtil._(); // 私有构造函数，防止类被实例化

  static String BASE_URL = GlobalVariables.instance.baseUrl; // 基础 URL 地址

  static Dio? _client; // Dio 客户端对象
  static Completer<bool> _lock = Completer<bool>();


  // 获取 Dio 客户端对象
  static Dio get client {
    if (_client == null) {
      // 如果客户端对象为空
      _client = Dio(BaseOptions(
        // 创建 Dio 客户端对象
        baseUrl: BASE_URL, // 设置基础 URL 地址
        connectTimeout: Duration(milliseconds: 10000), // 设置连接超时时间
        receiveTimeout: Duration(milliseconds: 3000), // 设置接收超时时间
        sendTimeout: Duration(milliseconds: 3000), // 设置发送超时时间
      ));
      // 添加一个请求拦截器，在请求发送前执行
      _client!.interceptors
          .add(InterceptorsWrapper(onRequest: _onRequest, onResponse: _onResponse, onError: _onError));
    }
    return _client!;
  }
  /// 请求拦截器
  static void _onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 对非open的接口的请求参数全部增加userId
    if (!options.path.contains("open")) {
      // options.queryParameters["userId"] = "xxx";
    }
    String? token = TokenRepository.getInstance().token;
    if (token == null) {
      TokenRepository.getInstance()
          .getTokenFromSharedPreferences()
          .then((value) {
        value = value.trim();
        if (value.isNotEmpty) {
          options.headers["Authorization"] = value;
        }
        // print('Authorization_value_token:$value');
        handler.next(options);
      }).catchError((e) {
        handler.reject(e);
      });
    } else {
      options.headers["Authorization"] = token;
      handler.next(options);
    }
    // print('options.headers["Authorization"]:${options.headers["Authorization"]}');
    // print('token:$token');
  }

  /// 相应拦截器
  static void _onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    // 请求成功是对数据做基本处理
    if (response.statusCode == 200) {
      // 处理成功的响应
      // print("响应结果: $response");
    } else {
      // 处理异常结果
      print("响应异常: $response");
    }
    handler.next(response);
  }

  /// 错误处理: 网络错误等
  static void _onError(DioException error, ErrorInterceptorHandler handler) {
    if (error.response?.statusCode == 401) {
      Util.showToastCourse("请先登录！",context as BuildContext);
    }
    handler.reject(error);
  }

  // 从 JSON 字符串中获取数据
  static dynamic getDataFromResponse(String? jsonStr,
      {bool isDialogMode = false, BuildContext? context}) {
    // var resp = json.decode(jsonStr ?? ""); // 解码 JSON 字符串为 Map 对象
    // jsonDecode(response.body) as Map<String, dynamic>;
    final Map<String, dynamic> resp = jsonDecode(jsonStr??"");
    if (resp["code"] == 200 || resp["status"]== 0) {
      // 如果响应状态码为 0（成功）
      return resp["data"]; // 返回数据部分
    } else {
      // 如果响应状态码不为 0（失败）
      if (!TextUtil.isEmpty(resp["msg"])) {
        // 如果响应中包含错误消息
        if (isDialogMode) {
          // 如果以对话框模式显示错误消息
          if (context == null) {
            // 如果上下文对象为空
            throw Exception("要使用tipDialog,请设置context"); // 抛出异常，提示需要设置上下文对象
          } else {
            // 如果上下文对象不为空
            DialogUtil.showTipDialog(context, resp["msg"]); // 显示提示对话框
          }
        } else {
          // 如果以普通模式显示错误消息
          Util.showToastCourse(resp["msg"],context!); // 显示普通提示消息
        }
      }
      return null; // 返回空值
    }
  }
}
