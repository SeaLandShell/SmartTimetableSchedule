// https://pub.dev/packages/group_list_view/example
import 'package:course_schedule/components/clipper/bottom_curve_clipper.dart'; // 导入自定义的底部曲线剪裁器
import 'package:course_schedule/data/values.dart'; // 导入常量值
import 'package:course_schedule/pages/tabs/user/approach.dart';
import 'package:course_schedule/pages/tabs/user/protocol.dart';
import 'package:course_schedule/pages/tabs/user/schedule.dart';
import 'package:course_schedule/pages/tabs/user/user_card.dart'; // 导入用户卡片页面
import 'package:course_schedule/utils/util.dart';
import 'package:flutter/material.dart'; // 导入 Flutter Material 部件

import '../../../components/select_term_dialog.dart';
import '../../../utils/app_colors.dart'; // 导入通用工具

typedef onClickCallBack = void Function ();
class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  /// 用户信息卡片的高度
  static const double userCardHeight = UserCard.height;

  /// 内容距状态栏的高度
  static const double topMargin = 32;

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top; // 获取状态栏高度
    return Container(
      color: Values.bgWhite, // 设置背景颜色为白色
      child: Stack(
        children: [
          // 使用ClipPath小部件，通过指定clipper来裁剪子部件
          ClipPath(
            // 指定裁剪的方式为BottomCurveClipper，传入一个偏移量作为参数
            clipper: BottomCurveClipper(offset: userCardHeight / 2 + 8),
            // 子部件为一个Container容器
            child: Container(
              // 设置容器的高度，包括状态栏高度、顶部边距和用户卡片高度
              height: statusBarHeight + topMargin + userCardHeight,
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
          SingleChildScrollView(child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding:
                    EdgeInsets.fromLTRB(16, statusBarHeight + topMargin, 16, 0),
                child: UserCard(), // 用户信息卡片
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: _buildCard("我的课表","需提前导入课表","",() async {
                      try {
                        showSelectTermDialog(
                            await getTermOptionsFormInternet(), context); // 异步获取学期信息并显示选择学期的对话框
                      } catch (e) {
                        Util.showToastCourse("获取学期信息失败", context);
                      }
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    child: _buildCard("我的课程","已开通课程","",(){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return MeCoursePage();
                      }));
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    child: _buildCard("我的信息","个人中心","",(){
                      Navigator.pushNamed(context, "/supplement");
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    child: _buildCard("用户协议","预览查看","",(){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return AgreementPage();
                      }));
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    child: _buildCard("使用技巧","快速掌握","",(){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return ApproachPage();
                      }));
                    }),
                  ),
                ],
              ),

            ],
          ),),
        ],
      ),
    );
  }

  Widget _buildCard(String title,String subTitle,String tip,onClickCallBack){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: GestureDetector(
        onTap: onClickCallBack,
        child: Card(
          elevation: 8,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6.0),
            tileColor: Colors.white,
            selectedTileColor: Colors.lightBlueAccent.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            leading: CircleAvatar(
              child: Text(
                _getInitials(title),
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              backgroundColor: _getAvatarColor(title),
            ),
            title: Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            subtitle: Text(
              subTitle,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            ),
            trailing:Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(tip),
                Icon(Icons.arrow_forward_ios,color: Colors.blue,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getInitials(String user) {
    // var buffer = StringBuffer();
    // var split = user.split(" ");
    // for (var s in split) buffer.write(s[0]);
    // return buffer.toString().substring(0, split.length);
    return user.substring(user.length-1,user.length);
  }

  Color _getAvatarColor(String user) {
    return AppColors
        .avatarColors[user.hashCode % AppColors.avatarColors.length];
  }

}
