import 'dart:io';

import '../data/token_repository.dart';

class GlobalVariables {
  // 创建一个私有的构造函数，确保该类只能被实例化一次
  GlobalVariables._();

  // 创建一个静态实例
  static final GlobalVariables instance = GlobalVariables._();
  static String liscenKey = "nedHkix1XlQ5jxf7dkPu2dQdsJ59VfjWWjE6euOSM4F5WPzZ8eC+SlFcy14xC2i8";

  // 定义baseURL变量
  // String baseUrl = "http://10.12.31.253:8080";
  // String ip="10.12.31.253";

  //寝室BUU：
  String baseUrl = "http://10.12.83.99:8080";
  String ip="10.12.83.99";
  // String baseUrl = "http://10.12.48.84:8080";
  // 410

  // String baseUrl = "http://10.14.6.12:8080";
  // String ip="10.14.6.12";

  // String baseUrl = "http://192.168.1.10:8080";
  // String ip="192.168.1.10";

  // OPPOA32
  // String baseUrl = "http://192.168.208.186:8080";
  // String ip="192.168.208.186";
  //
  // String baseUrl = "http://192.168.1.3:8080";
  // String ip="192.168.1.3";
  String access_token=TokenRepository.getInstance().token ?? '';
  final Map<String, String> headers = {
    'Authorization': TokenRepository.getInstance().token ?? '',
  };
}
