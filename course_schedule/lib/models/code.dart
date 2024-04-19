import 'package:json_annotation/json_annotation.dart';

part 'code.g.dart';

@JsonSerializable()
class Code {
  Code();

  late String msg;
  late String img;
  late num code;
  late bool captchaEnabled;
  late String uuid;
  
  factory Code.fromJson(Map<String,dynamic> json) => _$CodeFromJson(json);
  Map<String, dynamic> toJson() => _$CodeToJson(this);
}
