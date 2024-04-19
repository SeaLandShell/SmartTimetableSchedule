import 'package:flutter/material.dart'; // 导入Flutter的Material库

// 底部贝塞尔曲线切割
class BottomCurveClipper extends CustomClipper<Path> {
  /// 切割点与底部的距离
  final double offset; // 切割点与底部的距离

  BottomCurveClipper({this.offset = 20}); // 构造函数，可选参数offset，默认值为20

  @override
  Path getClip(Size size) {
    // 获取裁剪路径
    double top = 0; // 上边界位置
    double right = size.width; // 右边界位置
    double left = 0; // 左边界位置
    double bottom = size.height - offset; // 底部边界位置减去offset距离

    var path = Path(); // 创建路径对象
    path.lineTo(left, top); // 从当前点连接到给定点的直线段，左上角点
    path.lineTo(left, bottom); // 从当前点连接到给定点的直线段，左下角点

    path.quadraticBezierTo(
        size.width / 2, // 控制点的x坐标，取值为裁剪区域宽度的一半
        size.height, // 控制点的y坐标，取值为裁剪区域的高度
        right, // 终点的x坐标，取值为裁剪区域的宽度
        bottom); // 终点的y坐标，取值为裁剪区域底部的位置

    path.lineTo(right, 0); // 从当前点连接到给定点的直线段，右上角点

    return path; // 返回裁剪路径
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // 是否需要重新裁剪
    if (oldClipper.runtimeType != BottomCurveClipper)
      return true; // 如果类型不匹配，则需要重新裁剪
    final BottomCurveClipper typedOldClipper =
        oldClipper as BottomCurveClipper; // 将oldClipper转换为BottomCurveClipper类型
    return offset != typedOldClipper.offset; // 比较偏移量是否相等，若不相等则需要重新裁剪
  }
}

//BottomCurveClipper 类继承自 CustomClipper<Path>，用于实现自定义的裁剪路径。
// 构造函数 BottomCurveClipper 接受一个可选参数 offset，表示切割点与底部的距离，默认值为20。
// getClip() 方法用于获取裁剪路径，首先定义了四个边界位置，然后使用贝塞尔曲线连接这些点，形成底部弧线。
// shouldReclip() 方法用于判断是否需要重新裁剪，若旧的裁剪器类型不匹配或偏移量发生改变，则需要重新裁剪。
