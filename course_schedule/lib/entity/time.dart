import 'package:course_schedule/ext/int_extension.dart'; // 导入自定义的整数扩展

import 'package:json_annotation/json_annotation.dart'; // 导入json_annotation库，用于JSON序列化和反序列化

part 'time.g.dart'; // 导入自动生成的part文件，用于JSON序列化和反序列化

@JsonSerializable() // 标注类TimeEntity为可JSON序列化的类
class TimeEntity {
  Time? start; // 开始时间
  Time? end; // 结束时间

  TimeEntity({this.start, this.end}); // 构造函数，初始化字段值

  factory TimeEntity.fromJson(Map<String, dynamic> json) => // JSON反序列化方法，将JSON转换为对象
  _$TimeEntityFromJson(json);

  Map<String, dynamic> toJson() => _$TimeEntityToJson(this); // JSON序列化方法，将对象转换为JSON

  bool get isEmpty => start == null || end == null; // 判断时间段是否为空

  TimeEntity clone() => TimeEntity(start: this.start, end: this.end); // 克隆时间段对象
}

@JsonSerializable() // 标注类Time为可JSON序列化的类
class Time {
  final int hour; // 小时
  final int minute; // 分钟

  Time({required this.hour, required this.minute}); // 构造函数，初始化字段值

  factory Time.fromJson(Map<String, dynamic> json) => _$TimeFromJson(json); // JSON反序列化方法，将JSON转换为对象

  Map<String, dynamic> toJson() => _$TimeToJson(this); // JSON序列化方法，将对象转换为JSON

  @override
  String toString() { // 重写toString方法，返回时间的字符串表示形式
    return "${hour.toStringZeroFill(2)}:${minute.toStringZeroFill(2)}"; // 使用整数扩展中的方法补零并拼接小时和分钟
  }
}
