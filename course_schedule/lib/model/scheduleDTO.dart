import 'package:course_schedule/model/resource.dart';
import 'package:json_annotation/json_annotation.dart';

import 'member.dart';
import 'notice.dart';
part 'scheduleDTO.g.dart';
@JsonSerializable()
class ScheduleDTO {
  ScheduleDTO();

  late String courseId;
  late String courseNum;
  late String courseName;
  late String coursePic;
  late String clazzName;
  late String synopsis;
  late String term;
  late int arrivesNum;
  late int resourcesNum;
  late int experiencesNum;
  late bool appraise;
  late int teacherId;
  late String teacherName;
  late List<Member> members;
  late List<Resource> resources;
  late List<Notice> notices;

  factory ScheduleDTO.fromJson(Map<String,dynamic> json) => _$ScheduleDTOFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleDTOToJson(this);
}
