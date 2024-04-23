import 'package:json_annotation/json_annotation.dart';

part 'notice.g.dart';

@JsonSerializable()
class Notice {
  Notice();

  late String noticeId;
  late String contentever;
  late String author;
  late String releaseTime;
  late num type;
  late String courseId;
  late num id;
  late String gmtCreate;
  late String gmtModified;
  
  factory Notice.fromJson(Map<String,dynamic> json) => _$NoticeFromJson(json);
  Map<String, dynamic> toJson() => _$NoticeToJson(this);
}
