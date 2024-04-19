import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:course_schedule/data/values.dart';

// 颜色选择对话框组件
class ColorPickerDialog extends StatefulWidget {
  final Color initColor; // 初始颜色

  // 构造函数
  ColorPickerDialog({required this.initColor});

  // 静态方法，用于显示颜色选择对话框
  static Future<Color?> show(BuildContext context,
      {Color initColor = Values.bgWhite}) {
    // 调用 showDialog 方法弹出对话框
    return showDialog<Color?>(
      context: context,
      builder: (BuildContext context) {
        // 返回颜色选择对话框组件
        return ColorPickerDialog(
          initColor: initColor, // 设置初始颜色
        );
      },
    );
  }

  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

// 颜色选择对话框组件的状态类
class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late Color _color; // 当前选中的颜色

  @override
  void initState() {
    super.initState();
    _color = widget.initColor; // 初始化选中的颜色为初始颜色
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero, // 设置内容的内边距为零
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 颜色选择器组件
          ColorPicker(
            pickerColor: _color, // 设置选中的颜色
            onColorChanged: _changeColor, // 当颜色改变时的回调函数
            pickerAreaHeightPercent: 0.6, // 设置颜色选择区域的高度百分比
            pickerAreaBorderRadius: const BorderRadius.only(
              topLeft: const Radius.circular(2.0),
              topRight: const Radius.circular(2.0),
            ), // 设置颜色选择区域的边框圆角
          ),
        ],
      ),
      actions: [
        // 确定按钮
        TextButton(
            onPressed: () {
              Navigator.pop(context, _color); // 关闭对话框并返回选中的颜色
            },
            child: Text("确定"))
      ],
    );
  }

  // 改变选中的颜色
  void _changeColor(Color color) {
    setState(() {
      _color = color; // 更新选中的颜色
    });
  }
}
