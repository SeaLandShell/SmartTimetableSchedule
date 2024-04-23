import 'package:json_annotation/json_annotation.dart';

part 'resource.g.dart';

@JsonSerializable()
class Resource {
  Resource();

  late String resId;
  late String resName;
  late int resSize;
  late String downLink;
  late String uploadTime;
  late int experience;
  late String courseId;
  
  factory Resource.fromJson(Map<String,dynamic> json) => _$ResourceFromJson(json);
  Map<String, dynamic> toJson() => _$ResourceToJson(this);
}
