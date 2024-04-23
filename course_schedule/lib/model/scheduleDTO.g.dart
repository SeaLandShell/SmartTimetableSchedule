// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduleDTO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleDTO _$ScheduleDTOFromJson(Map<String, dynamic> json) => ScheduleDTO()
  ..courseId = json['courseId'] as String
  ..courseNum = json['courseNum'] as String
  ..courseName = json['courseName'] as String
  ..coursePic = json['coursePic'] as String
  ..clazzName = json['clazzName'] as String
  ..synopsis = json['synopsis'] as String
  ..term = json['term'] as String
  ..arrivesNum = json['arrivesNum'] as int
  ..resourcesNum = json['resourcesNum'] as int
  ..experiencesNum = json['experiencesNum'] as int
  ..appraise = json['appraise'] as bool
  ..teacherId = json['teacherId'] as int
  ..teacherName = json['teacherName'] as String
  ..members = (json['members'] as List<dynamic>)
      .map((e) => Member.fromJson(e as Map<String, dynamic>))
      .toList()
  ..resources = (json['resources'] as List<dynamic>)
      .map((e) => Resource.fromJson(e as Map<String, dynamic>))
      .toList()
  ..notices = (json['notices'] as List<dynamic>)
      .map((e) => Notice.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$ScheduleDTOToJson(ScheduleDTO instance) =>
    <String, dynamic>{
      'courseId': instance.courseId,
      'courseNum': instance.courseNum,
      'courseName': instance.courseName,
      'coursePic': instance.coursePic,
      'clazzName': instance.clazzName,
      'synopsis': instance.synopsis,
      'term': instance.term,
      'arrivesNum': instance.arrivesNum,
      'resourcesNum': instance.resourcesNum,
      'experiencesNum': instance.experiencesNum,
      'appraise': instance.appraise,
      'teacherId': instance.teacherId,
      'teacherName': instance.teacherName,
      'members': instance.members,
      'resources': instance.resources,
      'notices': instance.notices,
    };
