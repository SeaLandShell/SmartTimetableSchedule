// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Course _$CourseFromJson(Map<String, dynamic> json) => Course(
      name: json['name'] as String? ?? "",
      teacher: json['teacher'] as String? ?? "",
      classRoom: json['classRoom'] as String? ?? "",
      dayOfWeek: json['dayOfWeek'] as int? ?? 0,
      classStart: json['classStart'] as int? ?? -1,
      weekOfTerm: json['weekOfTerm'] as int? ?? 0,
      classLength: json['classLength'] as int? ?? 0,
      group: json['group'] as String? ?? "智慧计算机2001B",
    );

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
      'name': instance.name,
      'teacher': instance.teacher,
      'classLength': instance.classLength,
      'classStart': instance.classStart,
      'classRoom': instance.classRoom,
      'weekOfTerm': instance.weekOfTerm,
      'dayOfWeek': instance.dayOfWeek,
      'group': instance.group,
    };
