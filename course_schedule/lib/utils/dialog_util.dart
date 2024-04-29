import 'package:course_schedule/utils/text_util.dart';
import 'package:course_schedule/utils/util.dart'; // 导入工具库
import 'package:flutter/cupertino.dart'; // 导入 Flutter Cupertino 库
import 'package:flutter/material.dart'; // 导入 Flutter Material 库
import 'package:fluttertoast/fluttertoast.dart';

import '../components/pickerview/picker_view.dart'; // 导入自定义选择器组件
import '../components/pickerview/picker_view_popup.dart'; // 导入自定义选择器弹出框组件

// 定义回调函数类型
typedef onClickCallBack = void Function(); // 点击回调函数类型
typedef onPickerViewConfirmCallBack = void Function(int index); // 选择器确认回调函数类型
typedef pickerViewItemBuilder = Widget Function(int index); // 选择器项构建器回调函数类型

// 对话框工具类
class DialogUtil {
  static void showTipDialog(BuildContext context, String tip) {
    // 显示提示对话框
    showDialog(
        context: context, // 上下文对象
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero, // 对话框内容填充
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)), // 对话框形状
            ),
            title: Text(
              "提示", // 对话框标题
              textAlign: TextAlign.center, // 文本居中对齐
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min, // 垂直方向最小尺寸
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 24.0, 8, 24), // 设置边距
                  child: Text(
                    tip, // 提示文本内容
                    style:
                        TextStyle(fontSize: 16, color: Colors.black54), // 文本样式
                  ),
                ),
                Divider(height: 1.0), // 分割线
                Container(
                  height: 48, // 按钮容器高度
                  width: double.infinity, // 按钮容器宽度
                  child: TextButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15.0), // 底部左侧圆角
                            bottomRight: Radius.circular(15.0), // 底部右侧圆角
                          ),
                        )),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // 关闭对话框
                      },
                      child: Text(
                        "知道了", // 按钮文本内容
                      )),
                )
              ],
            ),
          );
        });
  }

  /// 当点击确定按钮时返回[DialogResult.OK],当点击取消按钮时返回[DialogResult.CANCEL]
  static Future<DialogResult?> showConfirmDialog(
      BuildContext context, String tip, onClickCallBack okBtnClick,
      {onClickCallBack? cancelBtnClick}) {
    return showDialog(
        context: context, // 上下文对象
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.lightBlue[50], // 设置背景色为浅蓝色
            contentPadding: EdgeInsets.zero, // 对话框内容填充
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))), // 对话框形状
            title: Text(
              "提示", // 对话框标题
              textAlign: TextAlign.center, // 文本居中对齐
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min, // 垂直方向最小尺寸
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0), // 设置边距
                  child: Text(
                    tip, // 提示文本内容
                    style:
                        TextStyle(fontSize: 16, color: Colors.black54), // 文本样式
                  ),
                ),
                Divider(height: 1.0), // 分割线
                Container(
                  height: 48, // 按钮容器高度
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch, // 交叉轴对齐方式
                    children: [
                      Expanded(
                        child: TextButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft:
                                                Radius.circular(15.0))))),
                            onPressed: () {
                              Navigator.pop(context,
                                  DialogResult.CANCEL); // 关闭对话框，并返回取消结果
                              if (cancelBtnClick != null) {
                                cancelBtnClick(); // 执行取消按钮回调函数
                              }
                            },
                            child: Text(
                              "取消", // 按钮文本内容
                              style: TextStyle(color: Colors.black), // 按钮文本样式
                            )),
                      ),
                      Container(
                        height: 48, // 按钮容器高度
                        child: VerticalDivider(
                          width: 1.0, // 分割线宽度
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            bottomRight:
                                                Radius.circular(15.0))))),
                            onPressed: () {
                              Navigator.pop(
                                  context, DialogResult.OK); // 关闭对话框，并返回确认结果
                              okBtnClick(); // 执行确定按钮回调函数
                            },
                            child: Text("确定")), // 按钮文本内容
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  static Future<DialogResult?> showCustomWidgetDialog(
      BuildContext context,String title ,Widget custom_widget, onClickCallBack okBtnClick,
      {onClickCallBack? cancelBtnClick}) {
    return showDialog(
        context: context, // 上下文对象
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.lightBlue[50], // 设置背景色为浅蓝色
            contentPadding: EdgeInsets.zero, // 对话框内容填充
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))), // 对话框形状
            title: Text(
              "$title", // 对话框标题
              textAlign: TextAlign.center, // 文本居中对齐
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min, // 垂直方向最小尺寸
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0), // 设置边距
                  child: custom_widget,
                ),
                Divider(height: 1.0), // 分割线
                Container(
                  height: 48, // 按钮容器高度
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch, // 交叉轴对齐方式
                    children: [
                      Expanded(
                        child: TextButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft:
                                            Radius.circular(15.0))))),
                            onPressed: () {
                              Navigator.pop(context,
                                  DialogResult.CANCEL); // 关闭对话框，并返回取消结果
                              if (cancelBtnClick != null) {
                                cancelBtnClick(); // 执行取消按钮回调函数
                              }
                            },
                            child: Text(
                              "取消", // 按钮文本内容
                              style: TextStyle(color: Colors.black), // 按钮文本样式
                            )),
                      ),
                      Container(
                        height: 48, // 按钮容器高度
                        child: VerticalDivider(
                          width: 1.0, // 分割线宽度
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            bottomRight:
                                            Radius.circular(15.0))))),
                            onPressed: () {
                              Navigator.pop(
                                  context, DialogResult.OK); // 关闭对话框，并返回确认结果
                              okBtnClick(); // 执行确定按钮回调函数
                            },
                            child: Text("确定")), // 按钮文本内容
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  static void showLoadingDialog(BuildContext context, {Future? task}) {
    showDialog(
        barrierDismissible: false, // 取消点击其他区域关闭对话框功能
        context: context, // 上下文对象
        builder: (context) {
          // 当异步任务结束关闭对话框
          task?.whenComplete(() => Navigator.pop(context));
          return AlertDialog(
            content: Container(
                padding: const EdgeInsets.all(8), // 设置内边距
                child: Row(
                  children: [
                    Container(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator()), // 加载指示器
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0), // 设置边距
                      child: Text("加载中..."), // 文本内容
                    )
                  ],
                )),
          );
        });
  }

  static Future<bool?> showPickerViewOneColumn(
      // 声明静态方法，显示一列选择器
      {required BuildContext context, // 参数：上下文对象，必需
      required String title, // 参数：选择器标题，必需
      required int count, // 参数：选择器项数量，必需
      required pickerViewItemBuilder builder, // 参数：选择器项构建器回调函数，必需
      required onPickerViewConfirmCallBack confirmCallBack, // 参数：选择器确认回调函数，必需
      int initIndex = 0}) {
    // 参数：选择器初始索引，默认为0
    PickerController pickerController = // 创建选择器控制器
        PickerController(count: 1, selectedItems: [initIndex]); // 设置选择器控制器属性

    return PickerViewPopup.showMode<bool>(
        // 返回显示选择器的异步方法
        PickerShowMode.BottomSheet, // 显示底部选择器
        controller: pickerController,
        // 设置选择器控制器
        context: context,
        // 设置上下文对象
        title: Text(
          // 设置选择器标题
          title, // 使用传入的标题文本
          style: TextStyle(fontSize: 14), // 设置标题文本样式
        ),
        cancel: Text(
          // 设置取消按钮文本
          '取消', // 取消按钮文本内容
          style: TextStyle(color: Colors.grey), // 取消按钮文本样式
        ),
        confirm: Text(
          // 设置确认按钮文本
          '确定', // 确认按钮文本内容
          style: TextStyle(color: Colors.blue), // 确认按钮文本样式
        ),
        onConfirm: (controller) {
          // 设置选择器确认回调函数
          confirmCallBack(controller.selectedRowAt(section: 0)!); // 执行选择确认回调函数
        },
        builder: (context, popup) {
          // 设置选择器项构建器
          return Container(
            // 返回选择器容器组件
            height: 250, // 设置选择器容器高度
            child: popup, // 显示选择器
          );
        },
        itemExtent: 40,
        // 设置选择器项高度
        numberofRowsAtSection: (section) {
          // 设置每个分区的选择器项数量
          return count; // 返回选择器项数量
        },
        itemBuilder: (section, row) {
          // 设置选择器项构建器
          return DefaultTextStyle(
            // 设置选择器项默认文本样式
            style: Theme.of(context) // 使用当前主题的文本样式
                .textTheme
                .bodyText2! // 获取默认文本样式
                .merge(TextStyle(fontFamily: Util.getDesktopFontFamily())),
            // 合并自定义字体样式
            child: builder(row), // 构建选择器项
          );
        });
  }


  /// 显示 Toast 消息
  static void showToast(String? msg) {
    if (TextUtil.isEmpty(msg)) {
      return;
    }
    Fluttertoast.showToast(
      msg: msg!,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.black87,
      fontSize: 16.0,
    );
  }
}

// 对话框结果枚举类型
enum DialogResult { OK, CANCEL }
