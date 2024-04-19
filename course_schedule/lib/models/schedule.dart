import 'package:json_annotation/json_annotation.dart';

part 'schedule.g.dart';

@JsonSerializable()
class Schedule {
  Schedule();

  late String courseId;
  late String courseNum;
  late String courseName;
  late String coursePic;
  late String clazzName;
  late String term;
  late String synopsis;
  late num arrivesNum;
  late num resourcesNum;
  late num experiencesNum;
  late bool appraise;
  late String teacherId;
  late String teacherName;
  late num id;
  late String gmtCreate;
  late String gmtModified;
  
  factory Schedule.fromJson(Map<String,dynamic> json) => _$ScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleToJson(this);
}
