import 'package:flutter/material.dart';

// TextUtil 类提供了一系列静态方法，用于文本处理和测量
class TextUtil {
  TextUtil._(); // 私有构造函数，防止类被实例化

  /// 检查文本是否为空
  static bool isEmpty(String? text) {
    return text?.isEmpty ?? true;
  }

  /// 检查文本是否不为空
  static bool isNotEmpty(String? text) {
    return !isEmpty(text);
  }

  /// 如果文本为空，则返回默认字符串，否则返回文本本身
  static String isEmptyOrDefault(String? text, String defaultStr) {
    return isEmpty(text) ? defaultStr : text!;
  }

  /// 构建一个 TextPainter 对象，用于测量文本的宽度和高度
  /// [context]: 当前界面上下文
  /// [value]: 文本内容
  /// [fontSize]: 字体大小
  /// [maxWidth]: 文本框的最大宽度
  /// [fontWeight]: 字体权重，默认为普通
  /// [maxLines]: 文本支持的最大行数，默认为 null 表示不限制行数
  static TextPainter buildTextPainter(
      BuildContext context,
      String value,
      double fontSize,
      double maxWidth, {
        FontWeight? fontWeight = FontWeight.normal,
        int? maxLines,
      }) {
    TextPainter painter = TextPainter(
      locale: Localizations.localeOf(context), // 设置语言环境
      maxLines: maxLines, // 设置最大行数
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: value,
        style: Theme.of(context).textTheme.bodyText2?.merge(
          TextStyle(
            fontWeight: fontWeight,
            fontSize: fontSize,
          ),
        ) ??
            TextStyle(
              fontWeight: fontWeight,
              fontSize: fontSize,
            ),
      ),
    );
    // 设置 layout
    painter.layout(maxWidth: maxWidth);
    // 返回 TextPainter 对象
    return painter;
  }

  /// 计算文本的大小
  /// 返回值: 文本的大小(Size)
  static Size calculateTextSize(
      BuildContext context,
      String value,
      double fontSize,
      double maxWidth, {
        FontWeight? fontWeight,
        int? maxLines,
      }) {
    return buildTextPainter(
      context,
      value,
      fontSize,
      maxWidth,
      fontWeight: fontWeight,
      maxLines: maxLines,
    ).size;
  }

  /// 计算文本的高度
  /// 返回值: 文本的高度(double)
  static double calculateTextHeight(
      BuildContext context,
      String value,
      double fontSize,
      double maxWidth, {
        FontWeight? fontWeight,
        int? maxLines,
      }) {
    return calculateTextSize(
      context,
      value,
      fontSize,
      maxWidth,
      fontWeight: fontWeight,
      maxLines: maxLines,
    ).height;
  }
}
