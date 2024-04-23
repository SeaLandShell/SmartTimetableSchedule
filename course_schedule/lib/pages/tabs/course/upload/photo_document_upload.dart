// https://github.com/JakesMD/flutter_capped_progress_indicator
// https://github.com/pktintali/flutter_custom_cards
// https://github.com/fluttercandies/flutter_wechat_assets_picker/blob/main/README-ZH.md

import 'package:course_schedule/model/index.dart';
import 'package:course_schedule/model/memberDTO.dart';
import 'package:course_schedule/net/apiClientSchedule.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:file_preview/file_preview.dart';

import '../../../../components/card_view.dart';
import '../../../../components/clipper/bottom_curve_clipper.dart';
import '../../../../data/values.dart';
import '../../../../db/database_manager.dart';
import '../../../../db/domain/user_db.dart';
import '../../../../utils/shared_preferences_util.dart';
import '../../../../utils/util.dart';
import 'dart:io';



class PhotoDocumentUploadPage extends StatefulWidget {
  final Color backgroundColor;
  final Schedule schedule;
  final String name,path;
  const PhotoDocumentUploadPage(this.name,this.path,{super.key,required this.backgroundColor,required this.schedule});

  @override
  State<PhotoDocumentUploadPage> createState() => _PhotoDocumentUploadPageState();
}

class _PhotoDocumentUploadPageState extends State<PhotoDocumentUploadPage> {
  /// 内容距状态栏的高度
  static const double topMargin = 32;
  static const double TodayCourseCardHeight = 40;
  double statusBarHeight = 0;
  double screenHeight = 0;
  double bottomNavBarHeight = 0;
  String fileName = "";
  String? version;
  final String liscenKey = "nedHkix1XlQ5jxf7dkPu2dQdsJ59VfjWWjE6euOSM4F5WPzZ8eC+SlFcy14xC2i8";
  bool _loading = true; // 是否正在加载数据的标志
  bool isImg = true;
  bool isTeacher = false;
  final List<MemberDto> _data = []; // 学校数据列表
  bool hide = false;
  bool isInit = false;

  File? selectedFile;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _renameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initTBS();
    isTeacherOrStu();
    int dotIndex = widget.name.lastIndexOf('.');
    String fileNameNoExt= dotIndex != -1 ? widget.name.substring(0, dotIndex) : widget.name;
    String ext = dotIndex != -1 ? widget.name.substring(dotIndex+1,widget.name.length) : "img";
    setState(() {
      if (ext.toLowerCase() == "jpg" || ext.toLowerCase() == "jpeg" || ext.toLowerCase() == "png" || ext.toLowerCase() == "gif" || ext.toLowerCase() == "bmp") {
        isImg = true;
      }else{
        isImg =false;
        _renameController = TextEditingController(text: fileNameNoExt);
      }
      fileName = fileNameNoExt;
    });
  }
  void _initTBS() async {
    isInit = await FilePreview.initTBS(license: liscenKey);
    version = await FilePreview.tbsVersion();
    if (mounted) {
      setState(() {});
    }
  }
  void isTeacherOrStu() async {
    UserDb? user = await DataBaseManager.queryUserById(await SharedPreferencesUtil.getPreference('userID', 0));
    if(user?.userType=="01"){
      setState(() {isTeacher = true;});
    }
  }
  @override
  Widget build(BuildContext context) {
    statusBarHeight = MediaQuery.of(context).padding.top; // 获取状态栏高度
    screenHeight = MediaQuery.of(context).size.height;
    bottomNavBarHeight = MediaQuery.of(context).padding.bottom;
    return Scaffold(
        appBar: AppBar(title: Text(widget.schedule.courseName!)),
      body: Container(
      color: Values.bgWhite, // 设置背景颜色为白色
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
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: _buildRename(), // 构建提醒工具
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: _buildPreview(), // 构建提醒工具
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: SizedBox(
                    height: 50, // 设置按钮的高度与卡片的高度一致
                    width: 360,
                    child: ElevatedButton(
                      onPressed: () async {
                        //使用前进行判断是否已经初始化
                        isInit = await FilePreview.tbsHasInit();
                        if (!isInit) {
                          await FilePreview.initTBS(license: liscenKey);
                          return;
                        }
                        String courseId = widget.schedule.courseId!;
                        if (_formKey.currentState!.validate()) {
                          if(_renameController.text.trim()!=""){
                            fileName = _renameController.text.trim();
                          }else{
                            Util.showToastCourse("请重命名文件！", context);
                            return;
                          }
                          Resource? resource = await ApiClientSchdedule.uploadImage(courseId,fileName, widget.path);
                          if(resource==null){
                            Util.showToastCourse("文件上传失败！", context);
                          }else{
                            Util.showToastCourse("文件已上传", context);
                            Navigator.pop(context);
                          }
                        }
                      },
                      child: const Text('上传资源', style: TextStyle(color: Colors.white,fontSize: 16)),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),);
  }
  CardView _buildRename() {
    return CardView(
      title: "重命名资源",
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 主轴居中对齐
          children: [
            // LinearCappedProgressIndicator(value: 1, minHeight: 1,backgroundColor: Colors.blueGrey.shade100 ,color: Colors.lightBlue ,),
            SizedBox(height: 5,),
            Row(
              children: [
                Expanded(
                  child: Form(
                          key: _formKey, // 绑定表单Key
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                            autovalidateMode: AutovalidateMode.disabled, // 禁用自动验证模式
                            controller: _renameController,
                            decoration: InputDecoration(labelText: '重命名,已存在的同名文件会被替换！',prefixIcon: const Icon(Icons.drive_file_rename_outline_rounded),),
                            validator: RequiredValidator(errorText: '请命名文件'),
                          ),
                          ],
                          ),
                      ),
                ),
              ],
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
  CardView _buildPreview() {
    //文件控制器
    FilePreviewController controller = FilePreviewController();
//切换文件
//path 文件地址 https/http开头、文件格式结尾的地址，或者本地绝对路径
    controller.showFile(widget.path);
    return CardView(
      title: "资源预览",
      // height: 300,
      child: Container(
        height: 200,
        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: isImg? PhotoView(
          backgroundDecoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          imageProvider: FileImage(File(widget.path)),
        ) : FilePreviewWidget(
          controller: controller,
          width: 200,
          height: 800,
          //path 文件地址 https/http开头、文件格式结尾的地址，或者本地绝对路径
          path: widget.path,
          callBack: FilePreviewCallBack(onShow: () {
            print("文件打开成功");
          }, onDownload: (progress) {
            print("文件下载进度$progress");
          }, onFail: (code, msg) {
            print("文件打开失败 $code  $msg");
          }),
        ),
      ),
    );
  }
}
