import 'dart:io'; // 导入 Dart 标准库中的文件 I/O 模块

import 'package:flutter/foundation.dart'; // 导入 Flutter 框架中的 foundation 库，用于访问 Flutter 核心功能

class DeviceType { // 定义一个 DeviceType 类
  static bool isWeb = kIsWeb; // 判断是否运行在 Web 平台

  static bool isIOS = !isWeb && Platform.isIOS; // 判断是否运行在 iOS 平台
  static bool isAndroid = !isWeb && Platform.isAndroid; // 判断是否运行在 Android 平台
  static bool isMacOS = !isWeb && Platform.isMacOS; // 判断是否运行在 macOS 平台
  static bool isLinux = !isWeb && Platform.isLinux; // 判断是否运行在 Linux 平台
  static bool isWindows = !isWeb && Platform.isWindows; // 判断是否运行在 Windows 平台

  static bool get isDesktop => isWindows || isMacOS || isLinux; // 判断是否运行在桌面平台

  static bool get isMobile => isAndroid || isIOS; // 判断是否运行在移动设备上

  static bool get isDesktopOrWeb => isDesktop || isWeb; // 判断是否运行在桌面或 Web 平台上

  static bool get isMobileOrWeb => isMobile || isWeb; // 判断是否运行在移动设备或 Web 平台上
}
