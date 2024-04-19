import 'package:json_annotation/json_annotation.dart'; // 导入json_annotation库，用于JSON序列化和反序列化

part 'background_config.g.dart'; // 导入自动生成的part文件，用于JSON序列化和反序列化

enum BackgroundType { // 定义枚举类型BackgroundType，表示背景类型
  /// 默认
  defaultBg,

  /// 纯色
  color,

  /// 图片
  img
}

@JsonSerializable() // 标注类BackgroundConfig为可JSON序列化的类
class BackgroundConfig {
  /// 背景类型
  BackgroundType type; // 背景类型字段，类型为BackgroundType枚举

  /// 颜色
  int? color; // 颜色字段，可为空

  /// 图片路径
  String? imgPath; // 图片路径字段，可为空

  BackgroundConfig({required this.type, this.color, this.imgPath}); // 构造函数，初始化字段值

  factory BackgroundConfig.fromJson(Map<String, dynamic> json) => // JSON反序列化方法，将JSON转换为对象
  _$BackgroundConfigFromJson(json);

  Map<String, dynamic> toJson() => _$BackgroundConfigToJson(this); // JSON序列化方法，将对象转换为JSON
}


//import 'package:json_annotation/json_annotation.dart'; 导入了用于JSON序列化和反序列化的 json_annotation 库。
// part 'background_config.g.dart'; 导入了自动生成的part文件，其中包含了fromJson和toJson方法的实现。
// enum BackgroundType 定义了一个枚举类型 BackgroundType，用于表示背景类型，包括默认、纯色和图片三种类型。
// @JsonSerializable() 标注了类 BackgroundConfig，表示该类可以进行JSON序列化和反序列化。
// BackgroundConfig 类中包含了三个字段：type 表示背景类型，color 表示颜色，imgPath 表示图片路径。
// 构造函数 BackgroundConfig({required this.type, this.color, this.imgPath}); 用于初始化对象的字段值。
// factory BackgroundConfig.fromJson(Map<String, dynamic> json) 方法是一个工厂方法，用于从JSON中创建对象。
// Map<String, dynamic> toJson() 方法是一个实例方法，用于将对象转换为JSON格式。
// 自动生成的代码中包含了fromJson和toJson方法的具体实现，它们是由json_serializable库根据类的定义自动生成的。
// int? color; 和 String? imgPath; 中的 ? 表示字段可为空，即可以为null。