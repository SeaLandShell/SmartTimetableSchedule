import 'package:course_schedule/db/dao/member_dao.dart';
import 'package:course_schedule/model/index.dart';
import 'package:course_schedule/model/memberDTO.dart';
import 'package:course_schedule/model/resource.dart';
import 'package:course_schedule/net/apiClientSchedule.dart';
import 'package:course_schedule/pages/tabs/course/upload/photo_document_preview.dart';
import 'package:course_schedule/pages/tabs/plan/today_course.dart';
import 'package:add_calendar_event/add_calendar_event.dart'; // 导入添加日历事件的库
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';
import 'package:shine_flutter/shine_flutter.dart';
import 'package:tbib_downloader/tbib_downloader.dart';

import '../../../../components/card_view.dart';
import '../../../../components/clipper/bottom_curve_clipper.dart';
import '../../../../components/item_button.dart';
import '../../../../data/values.dart';
import '../../../../model/member.dart';
import '../../../../provider/store.dart';
import '../../../../utils/device_type.dart';
import '../../../../utils/dialog_util.dart';
import '../../../../utils/http_util.dart';
import '../../../../utils/util.dart';
enum FileType {
  any,
  media,
  image,
  video,
  audio,
  custom,
}

class ResourceRespositoryPage extends StatefulWidget {
  final Schedule schedule;
  const ResourceRespositoryPage({super.key,required this.schedule});

  @override
  State<ResourceRespositoryPage> createState() => _ResourceRespositoryPageState();
}

class _ResourceRespositoryPageState extends State<ResourceRespositoryPage> {
  /// 内容距状态栏的高度
  static const double topMargin = 32;
  static const double TodayCourseCardHeight = 40;
  double statusBarHeight = 0;
  double screenHeight = 0;
  double progress = 0;
  double bottomNavBarHeight = 0;
  String ext = "jpg";

  bool _loading = true; // 是否正在加载数据的标志
  final List<Resource> _data = [];

  @override
  void initState() {
    super.initState();
    getCourseDetail();
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
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 0, 0, 16),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '资源列表',
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
                child: _buildExpansionTileCards(),
              ),
            ],
          ),
        ],
      ),
    ),);
  }
  CardView _buildMemberListTool() {
    return CardView(
      title: "成员列表",
      // height: 300,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: _buildExpansionTileCards(),
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
    double height = screenHeight - statusBarHeight - topMargin - TodayCourseCardHeight - bottomNavBarHeight-50;
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
                    TextButton(
                      style: flatButtonStyle,
                      onPressed: () {
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
            print('我是Resourse$i:${Resource.fromJson(data['resources'][i]).toJson()}');
            _data.add(Resource.fromJson(data['resources'][i]));
          }
          _data.sort((a, b) => a.uploadTime.compareTo(b.uploadTime));
          _loading = false; // 加载完成，更新_loading状态为false
        });
      }
    }catch (e) {
      print(e); // 打印错误信息
      setState(() {
        _loading = false; // 加载完成，更新_loading状态为false
      });
    }
  }
}
