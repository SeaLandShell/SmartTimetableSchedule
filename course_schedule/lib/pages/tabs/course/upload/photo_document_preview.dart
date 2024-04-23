// https://github.com/JakesMD/flutter_capped_progress_indicator
// https://github.com/pktintali/flutter_custom_cards
// https://github.com/fluttercandies/flutter_wechat_assets_picker/blob/main/README-ZH.md

import 'package:course_schedule/model/index.dart';
import 'package:course_schedule/net/globalVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:file_preview/file_preview.dart';

import '../../../../components/card_view.dart';
import '../../../../components/clipper/bottom_curve_clipper.dart';
import '../../../../data/values.dart';
import 'dart:io';



class PhotoDocumentPreviewPage extends StatefulWidget {
  final String fileUrl;
  final Schedule schedule;
  const PhotoDocumentPreviewPage({super.key,required this.fileUrl,required this.schedule});

  @override
  State<PhotoDocumentPreviewPage> createState() => _PhotoDocumentPreviewPageState();
}

class _PhotoDocumentPreviewPageState extends State<PhotoDocumentPreviewPage> {
  /// 内容距状态栏的高度
  static const double topMargin = 32;
  static const double TodayCourseCardHeight = 40;
  double statusBarHeight = 0;
  double screenHeight = 0;
  double bottomNavBarHeight = 0;
  double progress = 0;
  String fileName = "";
  String? version;
  String fileUrl = "";
  String filePath = "";
  final String liscenKey = GlobalVariables.liscenKey;
  bool isImg = false;
  bool isTeacher = false;
  bool isDocument = false;
  final List<String> documentExtensions = ['doc', 'docx', 'rtf', 'ppt', 'pptx', 'xls', 'xlsx', 'xlsm', 'csv', 'pdf', 'txt', 'epub', 'chm'];
  final List<String> imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'tiff', 'tif', 'webp'];
  bool hide = false;
  bool isInit = false;

  File? selectedFile;

  @override
  void initState() {
    super.initState();
    _initTBS();
    setState(() {
      fileUrl = widget.fileUrl;
    });
    isDocumentImgFile(fileUrl);
  }
  void _initTBS() async {
    isInit = await FilePreview.initTBS(license: liscenKey);
    version = await FilePreview.tbsVersion();
    if (mounted) {
      setState(() {});
    }
  }
  void isDocumentImgFile(String fileUrl) {
    String fileExtension = fileUrl.split('.').last;
    isDocument = documentExtensions.contains(fileExtension.toLowerCase());
    isImg = imageExtensions.contains(fileExtension.toLowerCase());
    return;
  }
  @override
  Widget build(BuildContext context) {
    statusBarHeight = MediaQuery.of(context).padding.top; // 获取状态栏高度
    screenHeight =  MediaQuery.of(context).size.height;
    bottomNavBarHeight = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: Values.bgWhite,
      appBar: AppBar(title: Text(widget.schedule.courseName!)),
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: [
              // 使用ClipPath小部件，通过指定clipper来裁剪子部件
              ClipPath(
                // 指定裁剪的方式为BottomCurveClipper，传入一个偏移量作为参数
                clipper: BottomCurveClipper(offset: TodayCourseCardHeight / 2 + 8),
                // 子部件为一个Container容器
                child: Container(
                  // 设置容器的高度，包括状态栏高度、顶部边距和用户卡片高度
                  height: statusBarHeight + topMargin + TodayCourseCardHeight,
                  // 设置容器的装饰，包括一个渐变背景色
                  decoration: BoxDecoration(
                    // 定义一个线性渐变，指定起点和终点
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft, // 渐变起点为居中左侧
                        end: Alignment.centerRight, // 渐变终点为居中右侧
                        colors: [Colors.blue.shade400, Colors.blue.shade700] // 渐变色从浅蓝到深蓝
                    ),
                  ),
                  // 应用渐变背景色
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: _buildPreview(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  CardView _buildPreview() {
    double height = screenHeight - statusBarHeight - topMargin - TodayCourseCardHeight - bottomNavBarHeight;
    //文件控制器
    FilePreviewController controller = FilePreviewController();
    //切换文件
    //path 文件地址 https/http开头、文件格式结尾的地址，或者本地绝对路径
    controller.showFile(fileUrl);
    return CardView(
      title: "资源预览",
      height: height,
      child: !isImg && !isDocument ? Container(
        height: height-60,
        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Center(
          child: Text('''支持任意类型文件链接上传，
但暂支持图片与文档预览！''',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
        ),
      ) : Container(
        height: height-60,
        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: isImg? PhotoView(
          backgroundDecoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          imageProvider: NetworkImage(fileUrl),
        ) : SingleChildScrollView(child: FilePreviewWidget(
          controller: controller,
          width: 500,
          height: height-60,
          //path 文件地址 https/http开头、文件格式结尾的地址，或者本地绝对路径
          path: fileUrl,
          callBack: FilePreviewCallBack(onShow: () {
            print("文件打开成功");
          }, onDownload: (progress) {
            print("文件下载进度$progress");
          }, onFail: (code, msg) {
            print("文件打开失败 $code  $msg");
          }),
        ),
        ),),
    );
  }
}
