// https://github.com/JakesMD/flutter_capped_progress_indicator
// https://github.com/pktintali/flutter_custom_cards
// https://github.com/fluttercandies/flutter_wechat_assets_picker/blob/main/README-ZH.md

import 'dart:io';

import 'package:capped_progress_indicator/capped_progress_indicator.dart';
import 'package:course_schedule/model/index.dart';
import 'package:course_schedule/net/apiClientSchedule.dart';
import 'package:course_schedule/pages/tabs/course/upload/teacher_resource/photo_document_preview.dart';
import 'package:course_schedule/pages/tabs/course/upload/teacher_resource/photo_document_upload.dart';
import 'package:course_schedule/pages/tabs/course/upload/teacher_resource/resource_respository.dart';
import 'package:course_schedule/pages/tabs/course/upload/teacher_resource/web_upload.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';
import 'package:shine_flutter/shine_flutter.dart';
import 'package:tbib_downloader/tbib_downloader.dart';
import 'package:tbib_file_uploader/tbib_file_uploader.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../components/card_view.dart';
import '../../../components/clipper/bottom_curve_clipper.dart';
import '../../../components/item_button.dart';
import '../../../data/values.dart';
import '../../../db/database_manager.dart';
import '../../../db/domain/user_db.dart';
import '../../../utils/http_util.dart';
import '../../../utils/shared_preferences_util.dart';
import '../../../utils/util.dart';



class CourseRecoursePage extends StatefulWidget {
  final Schedule schedule;
  const CourseRecoursePage({super.key,required this.schedule});

  @override
  State<CourseRecoursePage> createState() => _CourseRecoursePageState();
}

class _CourseRecoursePageState extends State<CourseRecoursePage> {
  /// 内容距状态栏的高度
  static const double topMargin = 32;
  static const double TodayCourseCardHeight = 40;
  double statusBarHeight = 0;
  double screenHeight = 0;
  double bottomNavBarHeight = 0;
  double progress = 0;
  int userId = 0;
  int resourceLearnCount = 0;
  String ext = "jpg";
  bool _loading = true; // 是否正在加载数据的标志
  bool isTeacher = false;
  bool hasLearn = false;
  final List<Resource> _data = [];
  bool hide = false;
  File? selectedFile;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    isTeacherOrStu();
    getCourseDetail();
    resourcehasLearnCount();
    // print("我是当前资源页Schedule：${widget.schedule.toJson()}");
  }
  void isTeacherOrStu() async {
    int userID = await SharedPreferencesUtil.getPreference('userID', 0);
    UserDb? user = await DataBaseManager.queryUserById(userID);
    setState(() {
      userId = userID;
    });
    if(user?.userType=="01"){
      setState(() {isTeacher = true;});
    }
  }
  @override
  Widget build(BuildContext context) {
    statusBarHeight = MediaQuery.of(context).padding.top; // 获取状态栏高度
    screenHeight = MediaQuery.of(context).size.height;
    bottomNavBarHeight = MediaQuery.of(context).padding.bottom;
    return Container(
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
                  child: isTeacher? _buildResourceDetailTeacherOpTool() : _buildResourceDetailOpTool(), // 构建提醒工具
                ),
                isTeacher? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    child: Text("提示",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),), // 构建提醒工具
                    ) : Padding(
                  padding: const EdgeInsets.fromLTRB(28, 0, 0, 16),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          '资源详情列表',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 28.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '共计${_data.length}资源',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: isTeacher? _buildTipToTeacher() : _buildExpansionTileCards(), // 构建提醒工具
                ),
              ],
            ),
          ],
        ),
    );
  }
  CardView _buildResourceDetailOpTool() {
    double value=0.0001;
    if(resourceLearnCount!=0 && _data.length!=0){
      value = resourceLearnCount/_data.length;
    }
    return CardView(
      title: "资源学习进度",
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 主轴居中对齐
          children: [
            LinearCappedProgressIndicator(value: value.toDouble(), minHeight: 5,backgroundColor: Colors.blueGrey.shade100 ,color: Colors.lightBlue ,),
            SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                  child: CustomCard(
                    height: 44,
                    width: 100,
                    elevation: 6,
                    childPadding: 10,
                    color: Colors.lightBlueAccent,
                    // onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.only(right: 0.0),
                      child: Text(
                        '已学习资源数$resourceLearnCount个',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: CustomCard(
                    height: 44,
                    width: 100,
                    elevation: 6,
                    childPadding: 10,
                    color: Colors.lightBlueAccent,
                    // onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.only(right: 0.0),
                      child: Text(
                        '资源总数${_data.length}个',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Future<void> wechatStyleAssetUpload(int type) async {
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        requestType: RequestType(type),
      ),
    );
    if (result != null) {
      List<Resource>? resources = await ApiClientSchdedule.uploadAssets(widget.schedule.courseId!, result);
      if (resources != null) {
        Util.showToastCourse("文件已上传！", context);
        return;
      } else {
        Util.showToastCourse("文件上传失败！", context);
      }
    } else {
      Util.showToastCourse("未选择任何文件！", context);
    }
  }
  CardView _buildResourceDetailTeacherOpTool() {
    return CardView(
      title: "资源服务",
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Row(
          children: [
            ItemButton(
              onClick: () {
                selectFileOrImage(
                  context: context,
                  selectedFile: ({String? name, String? path}) async {
                    print("name: $name\npath: $path");
                    if(name!.isNotEmpty && path!.isNotEmpty){
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return PhotoDocumentUploadPage(name,path,backgroundColor: Values.bgWhite,schedule: widget.schedule,);
                      }),);
                    }
                  },
                  selectFile: false,
                  selectImageCamera: true,
                  selectImageGallery: true,
                );
              },
              title: '拍照',
              icon: Icon(
                Icons.camera_alt_rounded,
                color: Colors.cyan.shade300,
              ),
            ),
            ItemButton(
              onClick: () async {
                await wechatStyleAssetUpload(1);
              },
              title: '图片',
              icon: Icon(
                Icons.image_rounded,
                color: Colors.red.shade300,
              ),
            ),
            ItemButton(
              onClick: () async {
                await wechatStyleAssetUpload(1<<2);
              },
              title: '音频',
              icon: Icon(
                Icons.audio_file_rounded,
                color: Colors.blue.shade400,
              ),
            ),
            ItemButton(
              onClick: () async {
                await wechatStyleAssetUpload(1<<1);
              },
              title: '视频',
              icon: Icon(
                Icons.switch_video_rounded,
                color: Colors.purpleAccent.shade400,
              ),
            ),
          ],
        ),
            // SizedBox(height: 5,),
            Row(
              children: [
                ItemButton(
                  onClick: () {
                    selectFileOrImage(
                      context: context,
                      selectedFile: ({String? name, String? path}) {
                        if(name!.isNotEmpty && path!.isNotEmpty){
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return PhotoDocumentUploadPage(name,path,backgroundColor: Values.bgWhite,schedule: widget.schedule,);
                          }),);
                        }
                      },
                      selectFile: true,
                      selectImageCamera: false,
                      selectImageGallery: false,
                    );
                  },
                  title: '文件',
                  icon: Icon(
                    Icons.file_upload_rounded,
                    color: Colors.lightGreen.shade800,
                  ),
                ),
                ItemButton(
                  onClick: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return WebUploadPage(backgroundColor: Values.bgWhite,schedule: widget.schedule,);
                    }),);
                  },
                  title: '网页链接',
                  icon: Icon(
                    Icons.add_link_rounded,
                    color: Colors.orange.shade400,
                  ),
                ),
                ItemButton(
                  onClick: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return ResourceRespositoryPage(schedule: widget.schedule,);
                    }),);
                  },
                  title: '资源库',
                  icon: Icon(
                    Icons.featured_play_list_rounded,
                    color: Colors.indigo.shade400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildTipToTeacher(){
    double height = screenHeight - statusBarHeight - topMargin - TodayCourseCardHeight - bottomNavBarHeight;
    return Container(
      height: height - 605,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 16), // 设置右边距
            child: Material(
              color: Colors.transparent, // 背景颜色透明
              child: Container(
                constraints: BoxConstraints(minHeight: 64, minWidth: 64), // 设置容器最小宽高
                padding: const EdgeInsets.all(3), // 设置内边距
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // 主轴居中对齐
                  children: [
                    IconTheme.merge(
                      data: IconThemeData(size: 24), // 图标尺寸
                      child: Icon(Icons.upload_file_rounded,
                              size: 100,
                              color: Colors.blueGrey.shade500,), // 图标
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8), // 设置顶部边距
                      child: Text(
                        """快点击上方相应的图标为你的班课上传资源，
                        展开教学吧~""", // 标题文本
                        style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold), // 文本样式
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), // 设置顶部边距
                      child: Text(
                        """小秘密：
1.在智课表网页的资源列表，能上传文档、音频等多种类型的资源呢!
2.上传资源后，你需要将资源发布出去，学生才会看到哦。""", // 标题文本
                        style: TextStyle(fontSize: 10,fontFamily: "宋体"), // 文本样式
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
  Widget _buildExpansionTileCards() {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    );
    if (_loading) {
      return Center(child: CircularProgressIndicator()); // 显示加载指示器
    }
    double height = screenHeight - statusBarHeight - topMargin - TodayCourseCardHeight - bottomNavBarHeight-280;
    return Container(
      height: height, // 设置一个固定的高度
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          String link = _data[index].downLink;
          ext = link.substring(link.lastIndexOf('.')+1,link.length);
          final GlobalKey<ExpansionTileCardState> cardB = GlobalKey<ExpansionTileCardState>(); // 在这里初始化GlobalKey
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: ExpansionTileCard(
              key: cardB, // 使用UniqueKey确保每个ExpansionTileCard都是唯一的
              baseColor: Colors.white,
              leading: CustomCard(
                height: 50,
                width: 50,
                elevation: 5,
                color: Colors.blue.shade400,
                borderColor: Colors.cyanAccent,
                borderWidth: 2,
                child: CardWidget(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  backgroundColor: Colors.white,
                  children: [
                    Align(
                      heightFactor: 1.8,
                      alignment: Alignment.center,
                      child: GradientText(
                        ext,
                        gradient: SweepGradient(
                          colors: [Colors.blue[900]!, Colors.blueAccent],
                        ),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              title: Text(_data[index].resName),
              subtitle: Text(Util.formatFileSize(_data[index].resSize??0)),
              children: <Widget>[
                const Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Text(
                      """发布时间：${_data[index].uploadTime}""",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 16),
                    ),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceAround,
                  buttonHeight: 52.0,
                  buttonMinWidth: 90.0,
                  children: <Widget>[
                    // if(!isTeacher)
                    //   hasLearn? Column(
                    //     children: <Widget>[
                    //       Icon(Icons.done_rounded,color: Colors.red,),
                    //       Padding(
                    //         padding: EdgeInsets.symmetric(vertical: 2.0),
                    //       ),
                    //       Text('已学习'),
                    //     ],
                    //   ):Column(
                    //     children: <Widget>[
                    //       Icon(Icons.tips_and_updates_rounded,color: Colors.blue,),
                    //       Padding(
                    //         padding: EdgeInsets.symmetric(vertical: 2.0),
                    //       ),
                    //       Text('待学习'),
                    //     ],
                    //   ),
                    TextButton(
                      style: flatButtonStyle,
                      onPressed: () async {
                        int count = await ApiClientSchdedule.resourceLearnCount(userId, widget.schedule.courseId!,_data[index].resId);
                        if(count==0){
                          setState(() {
                            hasLearn = true;
                          });
                        }else{
                          setState(() {
                            resourceLearnCount = count;
                          });
                        }
                        ApiClientSchdedule.expirence(userId, widget.schedule.courseId!,_data[index].resId);
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return PhotoDocumentPreviewPage(fileUrl: link, schedule: widget.schedule);
                        }),);
                      },
                      child: const Column(
                        children: <Widget>[
                          Icon(Icons.preview_rounded,color: Colors.blue,),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('预览',style: TextStyle(color: Colors.blueAccent),),
                        ],
                      ),
                    ),
                    TextButton(
                      style: flatButtonStyle,
                      onPressed: () async {
                        int count = await ApiClientSchdedule.resourceLearnCount(userId, widget.schedule.courseId!,_data[index].resId);
                        if(count==0){
                          setState(() {
                            hasLearn = true;
                          });
                        }else{
                          setState(() {
                            resourceLearnCount = count;
                          });
                        }
                        ApiClientSchdedule.expirence(userId, widget.schedule.courseId!,_data[index].resId);
                        String filePath = await TBIBDownloader().downloadFile(
                          context: context,
                          url: _data[index].downLink,
                          fileName: "${_data[index].resName}.$ext",
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
                      },
                      child: const Column(
                        children: <Widget>[
                          Icon(Icons.arrow_downward,color: Colors.blue,),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('下载',style: TextStyle(color: Colors.blueAccent),),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        itemCount: _data.length,
      ),
    );
  }

  void getCourseDetail() async {
    try {
      final resp = await HttpUtil.client.get(
          "/cschedule/classes/${widget.schedule.courseId}",
          data: {
            'courseId': widget.schedule.courseId,
          });
      final data = HttpUtil.getDataFromResponse(resp.toString()); // 解析响应数据
      if (data['resources'] is List) {
        // 如果数据是列表类型
        setState(() {
          _data.clear(); // 清空数据列表
          for(var i=0;i<data['resources'].length;i++){
            // print('我是Resource$i:${Resource.fromJson(data['resources'][i]).toJson()}');
            _data.add(Resource.fromJson(data['resources'][i]));
          }
          _data.sort((a, b) => a.uploadTime.compareTo(b.uploadTime));
          _loading = false; // 加载完成，更新_loading状态为false
        });
      }
    } catch (e) {
      print(e); // 打印错误信息
      setState(() {
        _loading = false; // 加载完成，更新_loading状态为false
      });
    }
  }

//   资源学习个数总数
  void resourcehasLearnCount()async{
    try {
      final resp = await HttpUtil.client.get(
          "/cschedule/members/resourcehasLearnCount?userId=${await SharedPreferencesUtil.getPreference("userID", 0)}&courseId=${widget.schedule.courseId}",);
      final data = HttpUtil.getDataFromResponse(resp.toString()); // 解析响应数据
      if (data!=null) {
        // 如果数据是列表类型
        setState(() {
          resourceLearnCount = data;
        });
      }
    } catch (e) {
      print(e); // 打印错误信息
    }
  }
}
