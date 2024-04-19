// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User()
  ..code = json['code'] as num
  ..msg = json['msg'] as String
  ..data = json['data'] as Map<String, dynamic>
  ..mapData = json['mapData'] as Map<String, dynamic>;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data,
      'mapData': instance.mapData,
    };
