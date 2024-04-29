import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:course_schedule/components/action_icon_button.dart';
import 'package:course_schedule/components/select_term_dialog.dart';
import 'package:course_schedule/entity/background_config.dart';
import 'package:course_schedule/provider/store.dart';
import 'package:course_schedule/pages/tabs/home/home_page_view_model.dart';
import 'package:course_schedule/pages/tabs/home/timetable.dart';
import 'package:course_schedule/pages/tabs/home/timetable_header.dart';
import 'package:course_schedule/utils/device_type.dart';
import 'package:course_schedule/utils/dialog_util.dart';
import 'package:course_schedule/utils/text_util.dart';
import 'package:course_schedule/utils/util.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

// 定义首页菜单选项的枚举类型
enum _HomeMenu {
  SelectWeekOfTerm, // 选择周数
  CollegeImport,    // 教务系统导入
  ShareTimetable,   // 分享课程表
  SetTime,          // 设置时间
  SelectBgImg       // 设置背景
}

class HomePage extends StatefulWidget {
  final Color backgroundColor;
  const HomePage({
    Key? key,
    this.backgroundColor = Colors.black, //默认为灰色
  }):super(key:key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// 左侧节数表头的宽度
  static const double _leftHeaderWidth = 41;

  /// 顶部星期表头的高度
  static const double _topHeaderHeight = 41;

  late final Store _store; // 用于管理数据的 Store 实例

  late final HomePageViewModel _viewModel; // 首页视图模型

  @override
  void initState() {
    super.initState();
    _store = Store.getInstanceReadMode(context); // 获取 Store 的实例
    _viewModel = HomePageViewModel(_store); // 创建首页视图模型
    _viewModel.init(); // 初始化视图模型
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size; // 获取屏幕尺寸
    final double tableWidth = screenSize.width - _leftHeaderWidth; // 计算课程表的宽度
    final double tableCellWidth = tableWidth / 7.0; // 计算每个单元格的宽度

    return ChangeNotifierProvider.value(
      value: _viewModel, // 使用 Provider 提供视图模型
      child: Column(
        children: [
          AppBar(
            centerTitle: true,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 显示当前周数
                Selector<Store, int>(
                  builder: (context, value, child) {
                    return GestureDetector(
                      onTap: () {
                        _selectWeekOfTerm(); // 调用 _selectWeekOfTerm 函数并传递参数 value
                      },
                      child: Text("第$value周"),
                    );
                  },
                  selector: (context, provider) {
                    return provider.currentWeek;
                  },
                ),
                // 显示当前日期
                Text(
                  _getDate(),
                  style: TextStyle(fontSize: 12.0),
                ),
              ],
            ),
            leading: _buildAppbarLeading(), // 构建 AppBar 左侧的 leading 控件
            actions: _buildActions(), // 构建 AppBar 右侧的操作按钮
          ),
          Expanded(
            child: Stack(
              children: [
                _buildBgImg(), // 构建背景图片
                Column(
                  children: [
                    DayOfWeekTableHeader(
                      height: _topHeaderHeight,
                      leftPadding: _leftHeaderWidth,
                    ),
                    Expanded(
                      flex: 1,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          double tableHeight = max(tableCellWidth * 12, constraints.maxHeight);
                          return _buildScrollView(tableHeight); // 构建课程表的可滚动视图
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 构建背景图片
  SizedBox _buildBgImg() {
    return SizedBox.expand(
      child: Selector<HomePageViewModel, BackgroundConfig?>(
        selector: (_, viewModel) => _viewModel.backgroundConfig,
        shouldRebuild: (oldValue, value) => true,
        builder: (context, value, child) {
          if (value == null) {
            return Container(color: Colors.white);
          }
          switch (value.type) {
            case BackgroundType.defaultBg:
              return Container(color: Colors.white);
            case BackgroundType.color:
              if (value.color != null) {
                return Container(color: Color(value.color!));
              }
              break;
            case BackgroundType.img:
              if (TextUtil.isNotEmpty(value.imgPath)) {
                return Image.file(
                  File(value.imgPath!),
                  fit: BoxFit.cover,
                );
              }
              break;
          }
          return Container(color: Colors.white);
        },
      ),
    );
  }

  // 构建课程表
  Widget _buildTimetable(double height) {
    var screenSize = MediaQuery.of(context).size;
    final double tableWidth = screenSize.width - _leftHeaderWidth;
    final double tableCellWidth = tableWidth / 7.0;
    final double tableHeight = max(tableCellWidth * 12, height);
    return Timetable(width: tableWidth, height: tableHeight);
  }

  // 构建 AppBar 左侧的 leading 控件
  Widget? _buildAppbarLeading() {
    if (!DeviceType.isMobile) {
      return null;
    }
    return IconButton(
      splashRadius: 16,
      padding: const EdgeInsets.all(3),
      constraints: const BoxConstraints(
        minWidth: 24,
        minHeight: 24,
      ),
      icon: Icon(Icons.qr_code_scanner),
      tooltip: "扫描二维码",
      onPressed: _scanQRCode,
    );
  }

  // 扫描二维码
  void _scanQRCode() {
    _viewModel.scanQRCodeAction(context);
  }

  // 构建 AppBar 右侧的操作按钮
  List<Widget> _buildActions() {
    return <Widget>[
      ActionIconButton(
        icon: Icon(
          Icons.add,
        ),
        tooltip: "添加",
        onPressed: () {
          _viewModel.jumpToEditCoursePage(context, -1, true);
        },
      ),
      ActionIconButton(
        icon: Icon(Icons.file_download),
        tooltip: "选择学期",
        onPressed: () async {
          try {
            showSelectTermDialog(
                await getTermOptionsFormInternet(), context); // 异步获取学期信息并显示选择学期的对话框
          } catch (e) {
            Util.showToastCourse("获取学期信息失败", context);
          }
        },
      ),
      PopupMenuButton<_HomeMenu>(
        itemBuilder: (context) {
          return _buildMenu();
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0.0),
          child: Icon(Icons.more_vert),
        ),
        offset: DeviceType.isAndroid ? Offset(0, 20) : Offset.zero,
        onSelected: _onSelectMenuOption, // 菜单选项选择回调
      ),
    ];
  }

  // 构建菜单选项
  List<PopupMenuEntry<_HomeMenu>> _buildMenu() {
    return const <PopupMenuEntry<_HomeMenu>>[
      PopupMenuItem<_HomeMenu>(
        value: _HomeMenu.SelectWeekOfTerm,
        child: Text('选择周数'),
      ),
      PopupMenuItem<_HomeMenu>(
        value: _HomeMenu.CollegeImport,
        child: Text('教务系统导入'),
      ),
      PopupMenuItem<_HomeMenu>(
        value: _HomeMenu.ShareTimetable,
        child: Text('分享'),
      ),
      PopupMenuItem<_HomeMenu>(
        value: _HomeMenu.SetTime,
        child: Text('设置时间'),
      ),
      PopupMenuItem<_HomeMenu>(
        value: _HomeMenu.SelectBgImg,
        child: Text('设置背景'),
      ),
    ];
  }

  // 菜单选择回调
  void _onSelectMenuOption(_HomeMenu item) {
    switch (item) {
      case _HomeMenu.SelectWeekOfTerm:
        _selectWeekOfTerm(); // 选择周数
        break;
      case _HomeMenu.CollegeImport:
        _viewModel.jumpToCollegeLoginPage(context); // 跳转到教务系统登录页面
        break;
      case _HomeMenu.ShareTimetable:
        _shareTimetable(); // 分享课程表
        break;
      case _HomeMenu.SetTime:
        Navigator.pushNamed(context, "/setTime"); // 跳转到设置时间页面
        break;
      case _HomeMenu.SelectBgImg:
        _selectBgImg(); // 选择背景图片
        break;
    }
  }

  // 分享课程表
  void _shareTimetable() async {
    try {
      final url = await _viewModel.shareTimetable(json.encode(_store.courses)); // 生成分享链接
      print(url);
      if (url is String && TextUtil.isNotEmpty(url)) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("分享二维码"),
              content: Container(
                height: 166,
                width: 166,
                padding: const EdgeInsets.all(3),
                child: Center(
                  child: QrImageView(
                    data: url,
                    version: QrVersions.auto,
                    size: 160,
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("知道了"),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print(e);
    }
  }

  // 选择周数
  void _selectWeekOfTerm() {
    DialogUtil.showPickerViewOneColumn(
      context: context,
      title: "选择周数",
      count: _store.maxWeekNum,
      builder: (index) {
        return Text(
          '第${index + 1}周',
          style: const TextStyle(fontSize: 12),
        );
      },
      confirmCallBack: (index) {
        _store.updateCurrentWeek(index + 1); // 更新当前周数
      },
      initIndex: _store.currentWeek - 1,
    );
  }

  // 构建课程表的可滚动视图
  Widget _buildScrollView(double tableHeight) {
    return SingleChildScrollView(
      child: Container(
        height: tableHeight,
        child: Row(
          children: [
            ClassIndexTableHeader(width: _leftHeaderWidth),
            _buildTimetable(tableHeight),
          ],
        ),
      ),
    );
  }

  // 获取当前日期
  String _getDate() {
    final now = DateTime.now();
    return "${now.year}/${now.month}/${now.day}";
  }

  // 选择背景图片
  void _selectBgImg() async {
    await showSelectBgTypeDialog(); // 显示选择背景类型的对话框
  }

  // 显示选择背景类型的对话框
  Future showSelectBgTypeDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          title: Text(
            "设置背景类型",
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 从相册中选择背景图片
              if (DeviceType.isMobile)
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _viewModel.selectBgImgFromPhotoGallery();
                  },
                  child: Text(
                    "从相册中选择",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              // 选择纯色背景
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _viewModel.pickColorAction(context);
                },
                child: Text(
                  "选择纯色背景",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              // 恢复默认背景
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _viewModel.backgroundConfig.type = BackgroundType.defaultBg;
                  _viewModel.updateBgConfig();
                },
                child: Text(
                  "恢复默认背景",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
