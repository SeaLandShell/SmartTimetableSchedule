// import 'dart:io';
import 'dart:developer';

import 'package:course_schedule/provider/store.dart';
import 'package:course_schedule/provider/user_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:tbib_file_uploader/tbib_file_uploader.dart';
import './routers/routers.dart';
import 'data/token_repository.dart';
import 'package:tbib_downloader/tbib_downloader.dart';
Future<void> main() async {
  // Avoid errors caused by flutter upgrade.
// Importing 'package:flutter/widgets.dart' is required.
//Flutter应用程序中的一种约定，用于确保Flutter应用程序已经初始化完成。通常情况下，它被用于在使用Flutter框架之前执行一些必要的初始化操作，例如初始化插件或执行异步操作。
  WidgetsFlutterBinding.ensureInitialized();
  // 腾讯文件预览
  await TBIBFileUploader().init();
  await TBIBDownloader().init();
  // 存储平台
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorage.webStorageDirectory
          : await getApplicationDocumentsDirectory(),);
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Store()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
  ], child: const MyApp()));
  // if (Platform.isAndroid) {
  //   // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
  //   SystemUiOverlayStyle systemUiOverlayStyle =
  //   const SystemUiOverlayStyle( statusBarColor: Colors.transparent,
  //       ///这是设置状态栏的图标和字体的颜色
  //       ///Brightness.light  一般都是显示为白色
  //       ///Brightness.dark 一般都是显示为黑色
  //       statusBarIconBrightness: Brightness.dark);
  //   SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  // }
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);
  static bool token_bool = false;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
        String? token = TokenRepository.getInstance().token??'';
    int? expire = TokenRepository.getInstance().expire??0;
    int? timestamp =TokenRepository.getInstance().timeStamp??0;
    log('token:$token\nexpire:$expire\ntimestamp:$timestamp');
    log('current:${DateTime.now().millisecondsSinceEpoch ~/ 60000}');
    int current = DateTime.now().millisecondsSinceEpoch ~/ 60000;
    int expirationTime = timestamp + expire;
    log('expirtionTime:$expirationTime');
    if(expirationTime>=current && token!='' && expirationTime!=0){
      token_bool = true;
    }else{
      token_bool = false;
      // final userProvider = Provider.of<UserProvider>(context, listen: false);
      // userProvider.updateLoginState(
      //   true,
      //   '开发者王星武',
      //   'http://192.168.73.186:9300/statics/2024/04/17/IMG_20240401_141115_20240417152043A002.jpg',
      // );
      print("口令为空");
    }
    return MaterialApp(
      // builder: (context, child) {
      //   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      //     statusBarColor: Colors.transparent, // 设置状态栏颜色为透明
      //     systemNavigationBarColor: Colors.transparent, // 设置底部导航栏颜色为透明
      //   ));
      //   return child!;
      // },
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: '智课表',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue.withOpacity(0.5), // 设置为浅蓝色
            centerTitle: true,
          )
      ),
      initialRoute: token_bool ? "/tabs" : "/login",
      onGenerateRoute: onGenerateRoute,
    );
  }
}