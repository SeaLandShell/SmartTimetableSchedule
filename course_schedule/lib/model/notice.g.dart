// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notice _$NoticeFromJson(Map<String, dynamic> json) => Notice()
  ..noticeId = json['noticeId'] as String
  ..contentever = json['contentever'] as String
  ..author = json['author'] as String
  ..releaseTime = json['releaseTime'] as String
  ..type = json['type'] as num
  ..courseId = json['courseId'] as String
  ..id = json['id'] as num
  ..gmtCreate = json['gmtCreate'] as String
  ..gmtModified = json['gmtModified'] as String;

Map<String, dynamic> _$NoticeToJson(Notice instance) => <String, dynamic>{
      'noticeId': instance.noticeId,
      'contentever': instance.contentever,
      'author': instance.author,
      'releaseTime': instance.releaseTime,
      'type': instance.type,
      'courseId': instance.courseId,
      'id': instance.id,
      'gmtCreate': instance.gmtCreate,
      'gmtModified': instance.gmtModified,
    };
