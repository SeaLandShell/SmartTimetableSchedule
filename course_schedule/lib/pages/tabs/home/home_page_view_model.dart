import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:course_schedule/components/color_picker_dialog.dart';
import 'package:course_schedule/data/values.dart';
import 'package:course_schedule/entity/background_config.dart';
import 'package:course_schedule/entity/time.dart';
import 'package:course_schedule/model/course.dart';
import 'package:course_schedule/provider/store.dart';
import 'package:course_schedule/ui/editcourse/edit_course_page.dart';
import 'package:course_schedule/pages/tabs/home/home_page_model.dart';
import 'package:course_schedule/ui/qrscan/qr_scan.dart';
import 'package:course_schedule/utils/file_util.dart';
import 'package:course_schedule/utils/http_util.dart';
import 'package:course_schedule/utils/shared_preferences_util.dart';
import 'package:course_schedule/utils/text_util.dart';
import 'package:course_schedule/utils/util.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 回调函数类型，用于在视图模型中执行更新操作时通知视图
typedef UpdateCallBack = void Function();

// HomePageViewModel 类，用于处理首页视图的业务逻辑和状态管理
class HomePageViewModel extends ChangeNotifier {
  final HomePageModel _model = HomePageModel(); // 首页视图模型
  BackgroundConfig _backgroundConfig =
      BackgroundConfig(type: BackgroundType.defaultBg); // 背景配置信息，默认为默认背景

  final Store _store; // 数据存储对象

  HomePageViewModel(this._store); // 构造函数，传入数据存储对象

  // 获取背景配置信息
  BackgroundConfig get backgroundConfig => _backgroundConfig;

  final picker = ImagePicker(); // 图片选择器对象

  // 更新背景配置信息
  void updateBgConfig({BackgroundConfig? value}) {
    if (value != null) {
      _backgroundConfig = value;
    }
    notifyListeners(); // 通知侦听器进行更新
    SharedPreferencesUtil.savePreference(SharedPreferencesKey.BG_CONFIG,
        json.encode(backgroundConfig)); // 将背景配置信息保存到 SharedPreferences 中
  }

  // 更新状态，并执行回调函数通知视图更新
  void update(UpdateCallBack updateCallBack) {
    updateCallBack();
    notifyListeners(); // 通知侦听器进行更新
  }

  // 跳转到教务系统登录页面
  void jumpToCollegeLoginPage(BuildContext context) async {
    final name = await SharedPreferencesUtil.getPreference(
        SharedPreferencesKey.COLLEGE_NAME, ""); // 从 SharedPreferences 中获取学校名称
    if (TextUtil.isNotEmpty(name)) {
      Navigator.pushNamed(context, "/collegeLogin"); // 跳转到教务系统登录页面，并传递学校名称参数
    } else {
      // 如果学校名称为空，则跳转到选择学校页面
      Navigator.pushNamed(context, "/selectCollege").then((value) {
        if (value is String && TextUtil.isNotEmpty(value)) {
          Navigator.pushNamed(context, "/collegeLogin"); // 跳转到教务系统登录页面，并传递选择的学校名称参数
        }
      });
    }
  }

  // 分享课程表
  Future shareTimetable(String timetableJson) async {
    final resp = await _model.shareTimetable(timetableJson); // 调用模型层的方法分享课程表
    final data = HttpUtil.getDataFromResponse(resp.toString()); // 从响应数据中获取分享链接
    return data["shareUrl"]; // 返回分享链接
  }

  // 跳转到编辑课程页面
  void jumpToEditCoursePage(BuildContext context, int index, bool isAppended) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditCoursePage(
        index: index,
        isAppended: isAppended,
      );
    }));
  }

  // 扫描二维码动作
  void scanQRCodeAction(BuildContext context) async {
    try {
      final qrData = await Navigator.push<String>(context,
          MaterialPageRoute(builder: (context) {
        return QRCodeScanPage(); // 跳转到二维码扫描页面，并等待返回扫描结果
      }));
      if (TextUtil.isEmpty(qrData)) {
        return;
      }
      final resp = await HttpUtil.client
          .get<String>(qrData!); // 使用 HTTP 客户端发送 GET 请求获取二维码数据
      final data =
          await HttpUtil.getDataFromResponse(resp.toString()); // 从响应数据中获取二维码数据
      List<Course> courses = [];
      if (data is List) {
        for (final item in data) {
          courses.add(Course.fromJson(item)); // 将获取到的课程数据转换为 Course 对象并添加到课程列表中
        }
        _store.courses = courses; // 更新课程数据
        Util.showToastCourse("导入分享课程表成功", context); // 弹出提示信息
      }
    } catch (e) {
      print(e);
      Util.showToastCourse("导入分享课程表失败", context); // 弹出错误信息
    }
  }

  // 选择纯色背景动作
  void pickColorAction(BuildContext context) async {
    try {
      final color = await ColorPickerDialog.show(context,
          initColor: backgroundConfig.color == null
              ? Values.bgWhite
              : Color(backgroundConfig.color!)); // 显示颜色选择对话框，并等待用户选择颜色
      if (color != null) {
        backgroundConfig
          ..type = BackgroundType.color
          ..color = color.value; // 更新背景配置信息为纯色背景，并设置颜色值
        updateBgConfig(); // 更新背景配置信息
      }
    } catch (e) {
      print(e);
    }
  }

  // 初始化方法，用于初始化课程数据、当前周数和课程时间
  void init() {
    _initCoursesData(); // 初始化课程数据
    _initCurrentWeek(); // 初始化当前周数
    _initClassTime(); // 初始化课程时间

    try {
      SharedPreferencesUtil.getPreference(SharedPreferencesKey.BG_CONFIG, "")
          .then((value) {
        if (value is String && value.trim().isNotEmpty) {
          final map = json.decode(value); // 解析背景配置信息的 JSON 字符串
          if (map is Map<String, dynamic>) {
            _backgroundConfig = BackgroundConfig.fromJson(
                map); // 将解析得到的 JSON 数据转换为 BackgroundConfig 对象
            notifyListeners(); // 通知侦听器进行更新
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }

  // 初始化课程数据
  Future<void> _initCoursesData() async {
    // for(int i=0;i<_store.courses.length;i++){
    //   print('所有课程$i：${_store.courses[i].toJson()}');
    // }
    // String aa=await FileUtil.getApplicationDocumentPath();
    // for(int i=0;i<_store.courses.length;i++){print(_store.courses[i].toJson());}
    FileUtil.readFromJson(Store.COURSE_JSON_FILE_NAME).then((value) {
      if (value.isEmpty) {
        return;
      }
      final courses = <Course>[];
      final List<dynamic>? list = json.decode(value); // 解析 JSON 字符串为 List
      if (list != null) {
        int i=0;
        list.forEach((v) {
          courses.add(new Course.fromJson(v)); // 将 JSON 数据转换为 Course 对象并添加到课程列表中
          // print(v);
          // print('object:${courses[i].toJson()}');
          i++;
        });
      }
      _store.courses = courses; // 更新课程数据
    }).catchError((error) {
      print(error);
      Util.showToastCourse("从本地读取课程数据失败", context as BuildContext); // 弹出错误信息
    });
  }

  // 初始化当前周数
  void _initCurrentWeek() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? currentWeek = prefs.getInt(
          SharedPreferencesKey.CURRENT_WEEK); // 从 SharedPreferences 中获取当前周数
      if (currentWeek != null) {
        currentWeek = Util.getWeekSinceEpoch() - currentWeek; // 计算当前周数
      }
      _store.updateCurrentWeek(currentWeek ?? 1); // 更新当前周数
    } catch (e) {
      print(e);
      Util.showToastCourse("读取当前周数失败", context as BuildContext); // 弹出错误信息
    }
  }

  // 初始化课程时间
  void _initClassTime() async {
    var times = await SharedPreferencesUtil.getTime();
    if (times.isEmpty) {
      times = [
        TimeEntity(
            start: Time(hour: 8, minute: 0), end: Time(hour: 8, minute: 45)),
        TimeEntity(
            start: Time(hour: 8, minute: 55), end: Time(hour: 9, minute: 40)),
        TimeEntity(
            start: Time(hour: 10, minute: 0), end: Time(hour: 10, minute: 45)),
        TimeEntity(
            start: Time(hour: 10, minute: 55), end: Time(hour: 11, minute: 40)),
        TimeEntity(
            start: Time(hour: 14, minute: 0), end: Time(hour: 14, minute: 45)),
        TimeEntity(
            start: Time(hour: 14, minute: 55), end: Time(hour: 15, minute: 40)),
        TimeEntity(
            start: Time(hour: 16, minute: 0), end: Time(hour: 16, minute: 45)),
        TimeEntity(
            start: Time(hour: 16, minute: 55), end: Time(hour: 17, minute: 40)),
        TimeEntity(
            start: Time(hour: 19, minute: 0), end: Time(hour: 19, minute: 45)),
        TimeEntity(
            start: Time(hour: 19, minute: 55), end: Time(hour: 20, minute: 40)),
        TimeEntity(
            start: Time(hour: 21, minute: 00), end: Time(hour: 21, minute: 45)),
        TimeEntity(
            start: Time(hour: 21, minute: 55), end: Time(hour: 22, minute: 40))
      ];
    }
    _store.classTime = times; // 更新课程时间
  }

  // 从相册中选择背景图片
  void selectBgImgFromPhotoGallery() async {
    try {
      final pickedFile =
          await picker.pickImage(source: ImageSource.gallery); // 从相册中选择图片
      if (pickedFile == null) {
        return;
      }
      final extension =
          FileUtil.getExtensionFromPath(pickedFile.path); // 获取文件路径的扩展名
      final dir = await FileUtil.getApplicationDocumentPath(); // 获取应用文档目录路径
      final newPath =
          "$dir/bg${new DateTime.now().millisecondsSinceEpoch}.$extension"; // 构建新的文件路径

      if (await FileUtil.copy(pickedFile.path, newPath)) {
        if (backgroundConfig.imgPath?.trim().isNotEmpty ?? false) {
          final old = File(backgroundConfig.imgPath!);
          if (old.existsSync()) {
            old.delete(); // 删除旧的背景图片文件
          }
        }
        backgroundConfig
          ..imgPath = newPath
          ..type = BackgroundType.img; // 更新背景配置信息为图片背景，并设置图片路径
        updateBgConfig(); // 更新背景配置信息
      } else {
        Util.showToastCourse("设置背景图片失败", context as BuildContext); // 弹出错误信息
      }
    } catch (e) {
      print(e);
      Util.showToastCourse("设置背景图片失败", context as BuildContext); // 弹出错误信息
    }
  }
}
