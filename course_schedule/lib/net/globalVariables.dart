import 'dart:io';

import '../data/token_repository.dart';

class GlobalVariables {
  // 创建一个私有的构造函数，确保该类只能被实例化一次
  GlobalVariables._();

  // 创建一个静态实例
  static final GlobalVariables instance = GlobalVariables._();

  // 定义baseURL变量
  String baseUrl = "http://10.12.31.253:8080";
  String ip="10.12.31.253";

  //寝室BUU：
  // String baseUrl = "http://10.12.48.84:8080";
  // String ip="10.12.48.84";
  // String baseUrl = "http://10.12.48.84:8080";
  // 410

  // String baseUrl = "http://10.14.4.145:8080";
  // String ip="10.14.4.145";

  // String baseUrl = "http://192.168.1.10:8080";
  // String ip="192.168.1.10";

  // OPPOA32
  // String baseUrl = "http://192.168.214.186:8080";
  // String ip="192.168.214.186";

  // String baseUrl = "http://192.168.73.186:8080";
  // String ip="192.168.73.186";
  String access_token=TokenRepository.getInstance().token ?? '';
  final Map<String, String> headers = {
    'Authorization': TokenRepository.getInstance().token ?? '',
  };
}
