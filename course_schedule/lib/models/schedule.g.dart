// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => Schedule()
  ..courseId = json['courseId'] as String
  ..courseNum = json['courseNum'] as String
  ..courseName = json['courseName'] as String
  ..coursePic = json['coursePic'] as String
  ..clazzName = json['clazzName'] as String
  ..term = json['term'] as String
  ..synopsis = json['synopsis'] as String
  ..arrivesNum = json['arrivesNum'] as num
  ..resourcesNum = json['resourcesNum'] as num
  ..experiencesNum = json['experiencesNum'] as num
  ..appraise = json['appraise'] as bool
  ..teacherId = json['teacherId'] as String
  ..teacherName = json['teacherName'] as String
  ..id = json['id'] as num
  ..gmtCreate = json['gmtCreate'] as String
  ..gmtModified = json['gmtModified'] as String;

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
      'courseId': instance.courseId,
      'courseNum': instance.courseNum,
      'courseName': instance.courseName,
      'coursePic': instance.coursePic,
      'clazzName': instance.clazzName,
      'term': instance.term,
      'synopsis': instance.synopsis,
      'arrivesNum': instance.arrivesNum,
      'resourcesNum': instance.resourcesNum,
      'experiencesNum': instance.experiencesNum,
      'appraise': instance.appraise,
      'teacherId': instance.teacherId,
      'teacherName': instance.teacherName,
      'id': instance.id,
      'gmtCreate': instance.gmtCreate,
      'gmtModified': instance.gmtModified,
    };
