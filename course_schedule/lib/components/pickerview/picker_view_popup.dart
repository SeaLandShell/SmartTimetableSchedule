import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'picker_view.dart';

// 用于构建PickerView弹窗的回调函数类型
typedef PickerViewBuilder = Widget Function(
    BuildContext context, PickerViewPopup pickerViewPopup);

// 枚举类型，表示PickerView的显示模式
enum PickerShowMode { AlertDialog, BottomSheet }

// PickerViewPopup类，用于显示PickerView的弹出窗口
class PickerViewPopup extends StatelessWidget {
  final PickerRowCallBack numberofRowsAtSection; // 获取每个Picker的行数的回调函数
  final PickerItemBuilder itemBuilder; // 构建每个Picker的行项的回调函数
  final PickerVoidCallBack? onSelectRowChanged; // 选中行发生变化时的回调函数
  final ValueChanged<PickerController>? onConfirm; // 确认选择时的回调函数
  final VoidCallback? onCancel; // 取消选择时的回调函数
  final PickerController controller; // Picker的控制器
  final double? itemExtent; // 行高
  final Widget? cancel; // 取消按钮的Widget
  final Widget? confirm; // 确认按钮的Widget
  final PickerShowMode mode; // 显示模式
  final Widget? title; // 标题栏的Widget

  // 私有构造函数，用于内部创建实例
  PickerViewPopup._({
    required this.numberofRowsAtSection,
    required this.itemBuilder,
    required this.controller,
    this.mode = PickerShowMode.BottomSheet,
    this.itemExtent,
    this.onSelectRowChanged,
    this.title,
    this.cancel,
    this.onCancel,
    this.confirm,
    this.onConfirm,
  }) : super();

  // 静态方法，根据显示模式展示PickerViewPopup弹窗
  static Future<T?> showMode<T>(
    PickerShowMode mode, {
    required BuildContext context, // 上下文对象
    required PickerViewBuilder builder, // 构建弹窗的方法
    required PickerController controller, // Picker的控制器
    required PickerRowCallBack numberofRowsAtSection, // 获取每个Picker的行数的回调函数
    required PickerItemBuilder itemBuilder, // 构建每个Picker的行项的回调函数
    PickerVoidCallBack? onSelectRowChanged, // 选中行发生变化时的回调函数
    double? itemExtent, // 行高
    Widget? title, // 标题栏的Widget
    Widget? cancel, // 取消按钮的Widget
    VoidCallback? onCancel, // 取消选择时的回调函数
    Widget? confirm, // 确认按钮的Widget
    ValueChanged<PickerController>? onConfirm, // 确认选择时的回调函数
  }) {
    // 创建PickerViewPopup对象
    PickerViewPopup pickerView = PickerViewPopup._(
      numberofRowsAtSection: numberofRowsAtSection,
      itemBuilder: itemBuilder,
      controller: controller,
      itemExtent: itemExtent,
      onSelectRowChanged: onSelectRowChanged,
      mode: mode,
      title: title,
      cancel: cancel,
      onCancel: () {
        Navigator.of(context).pop(false); // 关闭弹窗并返回false
        if (onCancel != null) onCancel(); // 执行取消回调函数
      },
      confirm: confirm,
      onConfirm: (controller) {
        Navigator.of(context).pop(true); // 关闭弹窗并返回true
        if (onConfirm != null) onConfirm(controller); // 执行确认回调函数
      },
    );

    // 根据显示模式展示弹窗
    if (mode == PickerShowMode.AlertDialog) {
      return showDialog(
          context: context,
          builder: (context) {
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: builder(context, pickerView));
          });
    } else {
      return showModalBottomSheet(
          context: context,
          builder: (context) {
            return builder(context, pickerView);
          });
    }
  }

  // 根据显示模式构建弹窗内容
  @override
  Widget build(BuildContext context) {
    // 根据显示模式选择构建不同类型的弹窗内容
    if (mode == PickerShowMode.AlertDialog) {
      return _buildDialogContent(context); // 构建AlertDialog的内容
    } else {
      return _buildBottomSheetContent(context); // 构建BottomSheet的内容
    }
  }

// 构建AlertDialog的内容
  Widget _buildDialogContent(BuildContext context) {
    // 返回一个ClipRRect包裹的容器，具有圆角边框
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: Colors.white, // 背景颜色为白色
        constraints: BoxConstraints.tightFor(height: 280), // 设置容器高度
        child: Column(
          children: <Widget>[
            // 标题部分
            Offstage(
              offstage: title == null, // 根据是否有标题判断是否隐藏
              child: Container(
                alignment: Alignment.center,
                padding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 20), // 设置内边距
                child: title, // 标题内容
              ),
            ),
            // 选择器部分
            Expanded(
              child: PickerView(
                numberOfRowsAtSection:
                    numberofRowsAtSection, // 获取每个Picker的行数的回调函数
                itemBuilder: itemBuilder, // 构建每个Picker的行项的回调函数
                controller: controller, // Picker的控制器
                onSelectRowChanged: onSelectRowChanged, // 选中行发生变化时的回调函数
                itemExtent: itemExtent, // 行高
              ),
            ),
            // 底部操作按钮
            Container(
              height: 50, // 设置高度
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: Theme.of(context).dividerColor), // 设置顶部边框
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // 取消按钮
                  Expanded(
                    child: _buildInkWellButton(
                      child: cancel ??
                          Text('取消',
                              style: TextStyle(color: Colors.grey)), // 取消按钮的文本
                      onTap: onCancel, // 取消按钮的点击事件
                    ),
                  ),
                  // 分隔线
                  Container(
                    color: Theme.of(context).dividerColor, // 使用主题颜色作为分隔线的颜色
                    width: 1, // 设置宽度
                    height: 50, // 设置高度
                  ),
                  // 确定按钮
                  Expanded(
                    child: _buildInkWellButton(
                      child: confirm ??
                          Text('确定',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .primaryColor)), // 确定按钮的文本
                      onTap: () {
                        if (onConfirm != null) {
                          onConfirm!(controller); // 执行确认回调函数
                        }
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

// 构建BottomSheet的内容
  Widget _buildBottomSheetContent(BuildContext context) {
    // 返回一个容器，用于构建底部弹出的BottomSheet
    return Container(
      constraints: BoxConstraints.tightFor(height: 280), // 设置容器高度
      child: Column(
        children: <Widget>[
          // 底部操作按钮和标题栏
          Container(
            color: Colors.white, // 背景颜色为白色
            height: 50, // 设置高度
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // 取消按钮
                _buildInkWellButton(
                  child: cancel ??
                      Text('取消',
                          style: TextStyle(color: Colors.grey)), // 取消按钮的文本
                  onTap: onCancel, // 取消按钮的点击事件
                ),
                // 标题
                Expanded(
                  child: Offstage(
                    offstage: title == null, // 根据是否有标题判断是否隐藏
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 10), // 设置内边距
                      child: title, // 标题内容
                    ),
                  ),
                ),
                // 确定按钮
                _buildInkWellButton(
                  child: confirm ??
                      Text('确定',
                          style: TextStyle(
                              color:
                                  Theme.of(context).primaryColor)), // 确定按钮的文本
                  onTap: () {
                    if (onConfirm != null) {
                      onConfirm!(controller); // 执行确认回调函数
                    }
                  },
                ),
              ],
            ),
          ),
          // 选择器部分
          Expanded(
            child: PickerView(
              numberOfRowsAtSection:
                  numberofRowsAtSection, // 获取每个Picker的行数的回调函数
              itemBuilder: itemBuilder, // 构建每个Picker的行项的回调函数
              controller: controller, // Picker的控制器
              onSelectRowChanged: onSelectRowChanged, // 选中行发生变化时的回调函数
              itemExtent: itemExtent, // 行高
            ),
          )
        ],
      ),
    );
  }

// 构建带有InkWell的按钮
  Widget _buildInkWellButton({Widget? child, VoidCallback? onTap}) {
    // 返回一个带有InkWell的Material组件，实现按钮点击效果
    return Material(
      child: Ink(
        color: Colors.white, // 设置Ink的背景颜色
        child: InkWell(
          child: Container(
            height: 50, // 设置高度
            padding: EdgeInsets.symmetric(horizontal: 20), // 设置内边距
            alignment: Alignment.center, // 文本居中对齐
            child: child, // 按钮文本
          ),
          onTap: onTap, // 点击事件
        ),
      ),
    );
  }
}
