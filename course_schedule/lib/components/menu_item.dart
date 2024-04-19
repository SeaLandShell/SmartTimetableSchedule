import 'package:flutter/material.dart';

// 菜单项视图组件
class MenuItemView extends StatelessWidget {
  final double height; // 视图高度
  final Widget? child; // 子部件
  final Icon? icon; // 图标
  final String label; // 标签文本
  final GestureTapCallback? onClick; // 点击事件回调函数

  // 构造函数
  MenuItemView({
    required this.label, // 必传参数：标签文本
    this.icon, // 图标
    this.height = 48.0, // 默认高度为48
    this.child, // 子部件
    this.onClick, // 点击事件回调函数
  });

  @override
  Widget build(BuildContext context) {
    // 返回一个带有点击效果的手势探测器
    return GestureDetector(
      onTap: onClick, // 点击事件回调
      child: Container(
        color: Colors.white, // 背景颜色为白色
        constraints: BoxConstraints(minHeight: height), // 设置最小高度
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 主轴对齐方式为两端对齐
          children: [
            if (icon != null) // 如果有图标
              Padding(
                padding: const EdgeInsets.all(8.0), // 设置内边距
                child: IconTheme.merge(
                    data: IconThemeData(size: 24), child: icon!), // 图标
              ),
            Text(
              label, // 标签文本
              style: TextStyle(fontSize: 16), // 文本样式
            ),
            if (child != null)
              Expanded(child: Container()), // 如果有子部件，则使用Expanded占据剩余空间
            if (child != null) // 如果有子部件
              Padding(
                padding: const EdgeInsets.only(right: 8), // 设置右边距
                child: child!, // 子部件
              )
          ],
        ),
      ),
    );
  }
}
