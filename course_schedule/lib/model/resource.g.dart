// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Resource _$ResourceFromJson(Map<String, dynamic> json) => Resource()
  ..resId = json['resId'] as String
  ..resName = json['resName'] as String
  ..resSize = json['resSize'] as int
  ..downLink = json['downLink'] as String
  ..uploadTime = json['uploadTime'] as String
  ..experience = json['experience'] as int
  ..courseId = json['courseId'] as String;

Map<String, dynamic> _$ResourceToJson(Resource instance) => <String, dynamic>{
      'resId': instance.resId,
      'resName': instance.resName,
      'resSize': instance.resSize,
      'downLink': instance.downLink,
      'uploadTime': instance.uploadTime,
      'experience': instance.experience,
      'courseId': instance.courseId,
    };
