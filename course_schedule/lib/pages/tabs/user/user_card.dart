import 'dart:io'; // 导入 dart:io 库，用于文件和输入/输出操作

import 'package:course_schedule/db/domain/user_db.dart';
import 'package:course_schedule/utils/shared_preferences_util.dart';
import 'package:dio/dio.dart' as dio; // 导入 dio 库并命名为 dio，用于进行网络请求
import 'package:flutter/cupertino.dart'; // 导入 Flutter 框架的 Cupertino 部件
import 'package:flutter/material.dart'; // 导入 Flutter 框架的 Material 部件
import 'package:image_cropper/image_cropper.dart'; // 导入图片裁剪库
import 'package:image_picker/image_picker.dart'; // 导入图片选择库
import 'package:course_schedule/components/card_view.dart'; // 导入自定义的 CardView 部件
import 'package:course_schedule/data/token_repository.dart'; // 导入令牌存储库
import 'package:course_schedule/provider/user_provider.dart'; // 导入用户提供者
import 'package:course_schedule/utils/device_type.dart'; // 导入设备类型工具
import 'package:course_schedule/utils/dialog_util.dart'; // 导入对话框工具
import 'package:course_schedule/utils/file_util.dart'; // 导入文件工具
import 'package:course_schedule/utils/http_util.dart'; // 导入 HTTP 请求工具
import 'package:course_schedule/utils/text_util.dart'; // 导入文本工具
import 'package:course_schedule/utils/util.dart'; // 导入通用工具
import 'package:provider/provider.dart'; // 导入 Provider 状态管理库

import '../../../provider/store.dart';
import '../../user/login.dart'; // 导入登录页面

class UserCard extends StatelessWidget {
  static const double height = 80; // 卡片的高度
  static const double iconSize = 56; // 头像的尺寸

  final picker = ImagePicker(); // 图片选择器实例
  late final BuildContext _context; // 上下文
  late final UserProvider _userProvider; // 用户提供者
  ImageCropper imageCropper = ImageCropper(); // 图片裁剪器

  @override
  Widget build(BuildContext context) {
    _context = context; // 初始化上下文
    _userProvider =
        Provider.of<UserProvider>(context, listen: false); // 获取用户提供者

    // 构建用户卡片
    return CardView(
      height: height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // 头像部分
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ClipOval(
                child: SizedBox(
                  height: iconSize,
                  width: iconSize,
                  child: Selector<UserProvider, bool>(
                    selector: (context, provider) => provider.isLogin,
                    builder: (context, value, child) {
                      return InkWell(
                        child: Selector<UserProvider, String>(
                          selector: (context, provider) => provider.userIcon,
                          builder: (context, value, child) {
                            if (value.trim().isEmpty) {
                              return Image.asset(
                                  "images/user_icon.png"); // 如果头像为空，显示默认头像
                            }
                            return FadeInImage.assetNetwork(
                              placeholder: "images/user_icon.png",
                              image: value,
                              fit: BoxFit.cover,
                            ); // 否则显示网络头像
                          },
                        ),
                        onTap: () {
                          if (!value) {
                            return;
                          }
                          if (DeviceType.isMobile) {
                            // 如果是移动设备
                            DialogUtil.showConfirmDialog(context, "确定要修改头像吗？",
                                () {
                              _uploadIconBtnClick(); // 显示确认对话框，点击后执行上传头像操作
                            });
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            // 用户名部分
            Selector<UserProvider, String>(
                selector: (context, provider) => provider.name,
                builder: (context, value, child) {
                  return Text(TextUtil.isEmptyOrDefault(value, "请先登录"),
                      style: TextStyle(fontSize: 18)); // 显示用户名或登录提示
                }),
            Expanded(child: Container()), // 占位，使注销按钮靠右对齐
            Selector<UserProvider, bool>(
                selector: (context, provider) => provider.isLogin,
                builder: (context, value, child) {
                  if (!value) {
                    return _buildLoginButton(context); // 如果未登录，显示登录按钮
                  } else {
                    return _buildLogOutButton(context); // 如果已登录，显示注销按钮
                  }
                },
            ),
          ],
        ),
      ),
    );
  }

  // 构建登录按钮
  Widget _buildLoginButton(BuildContext context) {
    return _buildButton(context, "登录", Colors.blue, () {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LoginPage(); // 跳转到登录页面
      }));
    });
  }

  // 构建注销按钮
  Widget _buildLogOutButton(BuildContext context) {
    return _buildButton(context, "登出", Colors.red.shade400, () {
      DialogUtil.showConfirmDialog(context, "确定要退出当前账号吗？", () {
        Util.getReadProvider<UserProvider>(context)
            .updateLoginState(false, "", "");
        Util.getReadProvider<Store>(context).updateLoginState();
        // 更新用户登录状态
        TokenRepository.getInstance().clear(); // 清除令牌
      });
    });
  }

  // 构建按钮
  Widget _buildButton(
      BuildContext context, String text, Color color, VoidCallback onClick) {
    return SizedBox(
      height: 32,
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        onPressed: onClick,
        child: Text(
          text,
          style: TextStyle(
              fontSize: 13.0, fontFamily: Util.getDesktopFontFamily()),
        ),
      ),
    );
  }

  // 头像上传按钮点击事件
  void _uploadIconBtnClick() async {
    try {
      final pickedFile =
          await picker.pickImage(source: ImageSource.gallery); // 从相册选择图片
      if (pickedFile == null) {
        return;
      }
      File? croppedFile = await imageCropper.cropImage(
          sourcePath: pickedFile.path,
          maxHeight: 300,
          maxWidth: 300,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          cropStyle: CropStyle.circle,
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: '图片裁剪',
              toolbarColor: Colors.blue,
              toolbarWidgetColor: Colors.white,
              lockAspectRatio: true),
          compressQuality: 100,
          compressFormat: ImageCompressFormat.png,
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          )); // 裁剪图片
      FileUtil.delete(pickedFile.path); // 删除原始图片
      String iconPath = croppedFile?.path ?? ""; // 获取裁剪后的图片路径
      DialogUtil.showLoadingDialog(_context); // 显示加载对话框
      print('iconpath:$iconPath');
      await _uploadIcon(iconPath); // 上传头像
      Navigator.pop(_context); // 关闭加载对话框
    } catch (e) {
      print(e);
    }
  }

  // 上传头像
  Future<bool> _uploadIcon(String iconPath) async {
    try {
      String phonenumber = await SharedPreferencesUtil.getPreference('phoneNumber', '13522170961');
      final form = dio.FormData.fromMap({
        'file': await dio.MultipartFile.fromFile(iconPath),
        'phone': phonenumber,
      }); // 构建表单数据
      final resp = await HttpUtil.client.post(
        "/acuser/acuser/avatar",
        data: form,
      ); // 发起上传请求
      final data = HttpUtil.getDataFromResponse(resp.toString()); // 解析响应数据
      if (data['avatar'] is String && data['avatar'].trim().isNotEmpty) {
        _userProvider.userIcon = data['avatar']; // 更新用户头像
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }
}
