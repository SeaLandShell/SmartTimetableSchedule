import 'package:course_schedule/pages/user/forgetPassword.dart';
import 'package:course_schedule/pages/user/supplement.dart';
import 'package:course_schedule/ui/login/wecom_login.dart';
import 'package:flutter/cupertino.dart';
/*
配置ios风格的路由
1、删掉material.dart引入cupertino.dart
   import 'package:flutter/cupertino.dart';

2、把 MaterialPageRoute替换成 CupertinoPageRoute
*/

import '../pages/tabs.dart';
import '../pages/shop.dart';
import '../pages/user/login.dart';
import '../pages/user/register.dart';
import '../ui/login/college_login_page.dart';
import '../ui/select/select_college_page.dart';
import '../ui/settime/set_time_page.dart';
//1、配置路由
Map routes = {
  "/tabs": (contxt) => const Tabs(),
  "/login": (contxt) => const LoginPage(),
  "/forgetPassword": (contxt) => const ForgetPasswordPage(),
  "/register": (contxt) => const RegisterPage(),
  "/supplement": (contxt) => const SupplementPage(),
  "/shop": (contxt, {arguments}) => ShopPage(arguments: arguments),
  "/collegeLogin": (context) => CollegeLoginPage(),
  "/weComLogin": (context) => WeComLoginPage(),
  "/selectCollege": (_) => SelectCollegePage(),
  "/setTime": (_) => SetTimePage(),
};

//2、配置onGenerateRoute  固定写法  这个方法也相当于一个中间件，这里可以做权限判断
var onGenerateRoute = (RouteSettings settings) {
  final String? name = settings.name; //  /news 或者 /search
  final Function? pageContentBuilder = routes[name];                          //  Function = (contxt) { return const NewsPage()}

  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = CupertinoPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
          CupertinoPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
  return null;
};