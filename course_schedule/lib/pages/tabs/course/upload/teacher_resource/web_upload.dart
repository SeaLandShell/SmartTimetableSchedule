// https://github.com/JakesMD/flutter_capped_progress_indicator
// https://github.com/pktintali/flutter_custom_cards
// https://github.com/fluttercandies/flutter_wechat_assets_picker/blob/main/README-ZH.md

import 'package:course_schedule/model/index.dart';
import 'package:course_schedule/model/memberDTO.dart';
import 'package:course_schedule/net/apiClientSchedule.dart';
import 'package:course_schedule/net/globalVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tbib_downloader/tbib_downloader.dart';
import 'package:file_preview/file_preview.dart';

import '../../../../../components/card_view.dart';
import '../../../../../components/clipper/bottom_curve_clipper.dart';
import '../../../../../db/database_manager.dart';
import '../../../../../db/domain/user_db.dart';
import '../../../../../utils/shared_preferences_util.dart';
import '../../../../../utils/util.dart';
import 'dart:io';



class WebUploadPage extends StatefulWidget {
  final Color backgroundColor;
  final Schedule schedule;
  const WebUploadPage({super.key,required this.backgroundColor,required this.schedule});

  @override
  State<WebUploadPage> createState() => _WebUploadPageState();
}

class _WebUploadPageState extends State<WebUploadPage> {
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
  bool _loading = true; // 是否正在加载数据的标志
  bool isImg = false;
  bool isTeacher = false;
  bool isDocument = false;
  final List<MemberDto> _data = []; // 学校数据列表
  final List<String> documentExtensions = ['doc', 'docx', 'rtf', 'ppt', 'pptx', 'xls', 'xlsx', 'xlsm', 'csv', 'pdf', 'txt', 'epub', 'chm'];
  final List<String> imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'tiff', 'tif', 'webp'];
  bool hide = false;
  bool isInit = false;

  File? selectedFile;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  final TextEditingController _weblinkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initTBS();
    isTeacherOrStu();
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
      backgroundColor: widget.backgroundColor,
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
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: _buildRename(),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: _buildPreview(),
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
                                if(_nameController.text.trim()!="" && _weblinkController.text.trim()!=""){
                                  fileName = _nameController.text.trim();
                                  fileUrl = _weblinkController.text.trim();
                                  isDocumentImgFile(fileUrl);
                                  filePath = await TBIBDownloader().downloadFile(
                                    context: context,
                                    url: fileUrl,
                                    fileName: fileName,
                                    directoryName: 'RemoteDownload',
                                    onReceiveProgress: ({int? receivedBytes, int? totalBytes}) {
                                      if (!context.mounted) {
                                        return;
                                      }
                                      setState(() {
                                        progress = (receivedBytes! / totalBytes!);
                                      });
                                    },
                                  )??"";
                                  if (!context.mounted) {
                                    return;
                                  }
                                  setState(() {
                                    progress = 0;
                                  });
                                }else{
                                  Util.showToastCourse("请输入文件名与文件链接", context);
                                  return;
                                }
                                fileName = fileName.substring(0,fileName.lastIndexOf('.'));
                                print('我是链接页面filename：$fileName');
                                Resource? resource = await ApiClientSchdedule.uploadImage(courseId,fileName, filePath);
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
          ),
        ),
    );
  }
  CardView _buildRename() {
    return CardView(
      title: "链接上传",
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
                          controller: _nameController,
                          decoration: InputDecoration(labelText: '带后缀文件名',prefixIcon: const Icon(Icons.drive_file_rename_outline_rounded),),
                          validator: MultiValidator([
                            RequiredValidator(errorText: '请输入带后缀文件名'),
                            PatternValidator(
                              r'(\S+).(\S+)',
                              errorText: '文件名必须含有后缀且不能包含空格！',
                            ),
                          ]).call,
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.disabled, // 禁用自动验证模式
                          controller: _weblinkController,
                          onChanged: (value) {
                            setState(() {
                              fileUrl = value;
                              isDocumentImgFile(fileUrl);
                            });
                          },
                          decoration: InputDecoration(labelText: '资源链接',prefixIcon: const Icon(Icons.link_rounded),),
                          validator: RequiredValidator(errorText: '请输入web链接'),
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
    controller.showFile(fileUrl);
    return CardView(
      title: "资源预览",
      // height: 300,
      child: !isImg && !isDocument ? Container(
        height: 100,
        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Center(
          child: Text('''支持任意类型文件链接上传，
但暂支持图片与文档预览！''',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
        ),
      ) : Container(
        height: 200,
        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: isImg? PhotoView(
          backgroundDecoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          imageProvider: NetworkImage(fileUrl),
        ) : SingleChildScrollView(child: FilePreviewWidget(
          controller: controller,
          width: 349,
          height: 800,
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
