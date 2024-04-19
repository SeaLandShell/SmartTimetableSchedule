import 'package:flutter/material.dart';

// 自定义卡片视图组件，用于显示带有标题的卡片
class CardView extends StatelessWidget {
  // 卡片的宽度
  final double? width;
  // 卡片的高度
  final double? height;
  // 卡片的标题
  final String? title;
  // 卡片的内容部分
  final Widget child;
  // 标题部分的内边距
  final EdgeInsets titlePadding;
  // 卡片的圆角属性
  final BorderRadiusGeometry borderRadius;

  // 构造函数
  CardView({
    required this.child, // 必需的参数：卡片的内容部分
    this.width, // 可选参数：卡片的宽度
    this.height, // 可选参数：卡片的高度
    this.title, // 可选参数：卡片的标题
    this.titlePadding = const EdgeInsets.all(16), // 可选参数：标题部分的内边距，默认为16
    this.borderRadius = const BorderRadius.all(Radius.circular(15)), // 可选参数：卡片的圆角属性，默认为圆角半径为15
  });

  @override
  Widget build(BuildContext context) {
    // 返回一个Container组件，用于显示卡片视图
    return Container(
      width: width, // 设置容器的宽度
      height: height, // 设置容器的高度
      decoration: BoxDecoration(
        borderRadius: borderRadius, // 设置容器的圆角属性
        color: Colors.white, // 设置容器的背景颜色为白色
      ),
      child: _buildChild(), // 设置容器的子组件
    );
  }

  // 根据是否有标题来构建卡片的子组件
  Widget _buildChild() {
    // 如果没有标题，则直接返回卡片的内容部分
    if (title == null) {
      return child;
    } else {
      // 如果有标题，则返回一个包含标题和内容部分的垂直布局
      return Column(
        mainAxisSize: MainAxisSize.min, // 垂直布局的尺寸大小设为最小
        children: [
          // 标题部分
          Container(
            width: double.infinity, // 标题部分的宽度设为最大
            padding: titlePadding, // 设置标题部分的内边距
            child: Text(
              title!, // 显示标题文本
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600), // 标题文本的样式
            ),
          ),
          // 内容部分
          child
        ],
      );
    }
  }
}
