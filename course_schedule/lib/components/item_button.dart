import 'package:flutter/material.dart';

// 自定义项目按钮组件
class ItemButton extends StatelessWidget {
  final GestureTapCallback? onClick; // 点击事件回调函数
  final Icon icon; // 图标
  final String title; // 标题

  // 构造函数
  const ItemButton({
    required this.icon, // 必传参数：图标
    required this.title, // 必传参数：标题
    this.onClick, // 点击事件回调函数
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 返回一个带有点击效果的按钮
    return Padding(
      padding: const EdgeInsets.only(right: 16), // 设置右边距
      child: Material(
        color: Colors.transparent, // 背景颜色透明
        child: InkWell(
          onTap: onClick, // 点击事件回调
          child: Container(
            constraints:
                BoxConstraints(minHeight: 64, minWidth: 64), // 设置容器最小宽高
            padding: const EdgeInsets.all(3), // 设置内边距
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // 主轴居中对齐
              children: [
                IconTheme.merge(
                  data: IconThemeData(size: 24), // 图标尺寸
                  child: icon, // 图标
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8), // 设置顶部边距
                  child: Text(
                    title, // 标题文本
                    style: TextStyle(fontSize: 13), // 文本样式
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
