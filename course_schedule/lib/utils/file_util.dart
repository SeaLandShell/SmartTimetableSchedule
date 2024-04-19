import 'dart:io'; // 导入文件 I/O 库

import 'package:path_provider/path_provider.dart'; // 导入路径提供者库

class FileUtil {
  FileUtil._(); // 私有构造函数，防止实例化该类

  // 获取应用程序文档目录的路径
  static Future<String> getApplicationDocumentPath() async {
    return (await getApplicationDocumentsDirectory()).path; // 获取应用程序文档目录路径并返回
  }

  // 获取临时目录的路径
  static Future<String> getTempDirPath() {
    return getTemporaryDirectory().then((value) => value.path); // 获取临时目录路径并返回
  }

  // 复制文件，将源文件复制到目标路径
  static Future<bool> copy(String source, String dest) async {
    try {
      File sourceFile = File(source); // 创建源文件对象
      if (!sourceFile.existsSync()) { // 如果源文件不存在
        return false; // 返回 false 表示复制失败
      }
      await sourceFile.copy(dest); // 复制文件到目标路径
      return true; // 返回 true 表示复制成功
    } catch (e) {
      print(e); // 打印异常信息
    }
    return false; // 返回 false 表示复制失败
  }

  // 将 JSON 字符串保存为文件
  static Future<bool> saveAsJson(String fileName, String json) async {
    try {
      final directory = (await getApplicationDocumentsDirectory()).path; // 获取应用程序文档目录路径
      final path = "$directory/json/$fileName"; // 构建文件路径
      File file = File(path); // 创建文件对象
      if (!file.existsSync()) { // 如果文件不存在
        file.createSync(recursive: true); // 创建文件及其父目录
      }
      await file.writeAsString(json); // 将 JSON 字符串写入文件
      return true; // 返回 true 表示保存成功
    } catch (e) {
      print(e); // 打印异常信息
    }
    return false; // 返回 false 表示保存失败
  }

  // 从文件中读取 JSON 字符串
  static Future<String> readFromJson(String fileName) async {
    try {
      final directory = (await getApplicationDocumentsDirectory()).path; // 获取应用程序文档目录路径
      final path = "$directory/json/$fileName"; // 构建文件路径
      File file = File(path); // 创建文件对象
      if (!file.existsSync()) { // 如果文件不存在
        return ""; // 返回空字符串表示读取失败
      }
      return (await file.readAsString()); // 读取文件中的 JSON 字符串并返回
    } catch (e) {
      print(e); // 打印异常信息
    }
    return ""; // 返回空字符串表示读取失败
  }

  ///获取文件扩展名
  static String getExtensionFromPath(String path) {
    int index = path.lastIndexOf('.'); // 获取文件扩展名的索引
    if (index == -1) { // 如果找不到扩展名
      return ""; // 返回空字符串
    } else { // 找到扩展名
      return path.substring(index + 1); // 返回扩展名
    }
  }

  // 删除指定路径的文件
  static bool delete(String? path) {
    if (path == null) return true; // 如果路径为空，直接返回 true
    try {
      File file = File(path); // 创建文件对象
      if (!file.existsSync()) { // 如果文件不存在
        return true; // 直接返回 true
      }
      file.deleteSync(); // 同步删除文件
      return true; // 返回 true 表示删除成功
    } catch (e) {
      print(e); // 打印异常信息
    }
    return false; // 返回 false 表示删除失败
  }
}
