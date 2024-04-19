import 'package:flutter/material.dart';

// 自定义的操作按钮组件，用于显示一个图标按钮
class ActionIconButton extends StatelessWidget {
  // 按钮点击事件的回调函数
  final VoidCallback? onPressed;
  // 鼠标悬停时显示的提示信息
  final String? tooltip;
  // 按钮显示的图标
  final Widget icon;

  // 构造函数
  ActionIconButton({
    required this.icon, // 必需的参数：图标组件
    this.onPressed, // 可选参数：按钮点击事件的回调函数
    this.tooltip, // 可选参数：鼠标悬停时显示的提示信息
    Key? key, // 可选参数：用于识别组件的唯一键
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 返回一个IconButton组件，用于显示图标按钮
    return IconButton(
      splashRadius: 16, // 设置点击水波纹的半径
      padding: const EdgeInsets.all(5), // 设置按钮的内边距
      constraints: const BoxConstraints(
        minWidth: 24, // 设置按钮的最小宽度
        minHeight: 24, // 设置按钮的最小高度
      ),
      icon: IconTheme.merge(
        data: IconThemeData(size: 24), // 设置图标的大小
        child: icon, // 设置图标组件
      ),
      tooltip: tooltip, // 设置鼠标悬停时显示的提示信息
      onPressed: onPressed, // 设置按钮点击事件的回调函数
    );
  }
}
