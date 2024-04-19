// // import 'dart:io';
//
// import 'package:course_schedule/data/token_repository.dart';
// import 'package:course_schedule/pages/tabs.dart';
// import 'package:course_schedule/provider/store.dart';
// import 'package:course_schedule/provider/user_provider.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import './routers/routers.dart';
// Future<void> main() async {
//   // Avoid errors caused by flutter upgrade.
// // Importing 'package:flutter/widgets.dart' is required.
// //Flutter应用程序中的一种约定，用于确保Flutter应用程序已经初始化完成。通常情况下，它被用于在使用Flutter框架之前执行一些必要的初始化操作，例如初始化插件或执行异步操作。
//   WidgetsFlutterBinding.ensureInitialized();
//   if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
//     await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
//   }
//   runApp(MultiProvider(providers: [
//     ChangeNotifierProvider(create: (_) => Store()),
//     ChangeNotifierProvider(create: (_) => UserProvider()),
//   ], child: const MyApp()));
//   // if (Platform.isAndroid) {
//   //   // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
//   //   SystemUiOverlayStyle systemUiOverlayStyle =
//   //   const SystemUiOverlayStyle( statusBarColor: Colors.transparent,
//   //       ///这是设置状态栏的图标和字体的颜色
//   //       ///Brightness.light  一般都是显示为白色
//   //       ///Brightness.dark 一般都是显示为黑色
//   //       statusBarIconBrightness: Brightness.dark);
//   //   SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
//   // }
// }
//
// final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
//
// class MyApp extends StatelessWidget {
//   final bool a=false;
//  const MyApp({Key? key}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context){
//    return FutureBuilder<bool>(
//      future: checkAccessTokenValidity(),
//      builder: (context, snapshot) {
//        if (snapshot.connectionState == ConnectionState.waiting) {
//          return CircularProgressIndicator(); // 显示加载指示器
//        } else {
//          print('aaaaaaaaaaaaaaaaaa${snapshot.data}');
//          if (snapshot.hasError) {
//            return Text('出错啦: ${snapshot.error}'); // 显示错误信息
//          } else {
//            if (snapshot.data == true) {
//              return Tabs(); // access_token 有效，跳转到主页
//            } else {
//              return MaterialApp(
//                // builder: (context, child) {
//                //   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//                //     statusBarColor: Colors.transparent, // 设置状态栏颜色为透明
//                //     systemNavigationBarColor: Colors.transparent, // 设置底部导航栏颜色为透明
//                //   ));
//                //   return child!;
//                // },
//                debugShowCheckedModeBanner: false,
//                navigatorKey: navigatorKey,
//                title: '智课表',
//                theme: ThemeData(
//                    primarySwatch: Colors.blue,
//                    visualDensity: VisualDensity.adaptivePlatformDensity,
//                    appBarTheme: AppBarTheme(
//                      backgroundColor: Colors.blue.withOpacity(0.5), // 设置为浅蓝色
//                      centerTitle: true,
//                    )
//                ),
//                initialRoute: "/login",
//                onGenerateRoute: onGenerateRoute,
//              );
//            }
//          }
//        }
//      },
//    );
//  }
//
//   Future<bool> checkAccessTokenValidity() async {
//     String? token = TokenRepository.getInstance().token;
//     int? expire = TokenRepository.getInstance().expire;
//     int? timestamp =TokenRepository.getInstance().timeStamp;
//     if (token == null || token == "") {
//       return false; // access_token 不存在，需要重新登录
//     } else {
//       if (expire != null && expire!="" && timestamp != null) {
//         int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 60000;
//         int expirationTime = timestamp + expire;
//         if (currentTime < expirationTime) {
//           return true; // access_token 仍在有效期内，不需要重新登录
//         }
//       }
//       return false; // access_token 已过期，需要重新登录
//     }
//   }
// }
